Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787432DA775;
	Wed,  9 Sep 2026 14:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962623; cv=none; b=KhOUturHxroryqPtvz7IbYFZ7AWjdp8B9B/bm2+U1F1/HTl8ApJx433KTZReinjn6LhSrGRzVp+ohSHOawBEzvUqSXy1Y03fryVjIhIf80HGghOeqB38q+CZznSgCjzTvMF2pNA2GR/0PlLcQs2K4p2va6XfComes0uIwc9YgnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962623; c=relaxed/simple;
	bh=3eNkZ2DBAz37DLobaffv3SSfjhGq5rZ6W3ju5cD3q3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3ADb4UEPXrvOw8wOYLnkHUXQLuvk4cJiwpra/rzfe2c10xj3XaY1bYt4wEni4nIdUqXja1zxsPdwr2FWnXb/bcr7PZZsRSwkb5GZL29PnO9JwKOeG0WPqZUVM69W9N9wdU4B+RhHH1jM9aJN5ttUdfQ4+TzMo8nXT7AdmXLngs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNkyJRV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNkyJRV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20EE1F00A3A;
	Wed,  9 Sep 2026 14:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962622;
	bh=1qEdtGPeU47JYSRXXDt4oMd5A8/y9K6X2wYpextxvvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNkyJRV3oR8Rv1QtzrYP9HAF/oJyjsO6yIBR64lXJENk1Q6L1STpPyYnufrKyiBop
	 ZXFhDEC2SvD/SDbFtl928+j5kUECL45TOJQ4Lj4qyYZukcv04xe0Gqe9quanEkZdMX
	 d9HvKffdbmZdJ+3vnSH/oh3Z9y0YzoAcAIv+s3bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 355/556] media: cobalt: Avoid freeing ALSA private data twice
Date: Wed,  9 Sep 2026 15:40:35 +0200
Message-ID: <20260909134243.157507643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

commit 3a7d6b9c4cb5ac18cbd3f1c7f8c7b159c42ba0b1 upstream.

snd_cobalt_card_create() stores cobsc in sc->private_data and installs
snd_cobalt_card_private_free() as sc->private_free. From that point,
snd_card_free(sc) releases cobsc through the ALSA card cleanup path.

If cobalt_alsa_init() fails after snd_cobalt_card_create(), the
err_exit_free path calls snd_card_free(sc) and then kfree(cobsc). That
second free releases the same object again.

Remove the explicit kfree(cobsc) and leave ownership with the ALSA card.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 85756a069c55 ("[media] cobalt: add new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cobalt/cobalt-alsa-main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/pci/cobalt/cobalt-alsa-main.c
+++ b/drivers/media/pci/cobalt/cobalt-alsa-main.c
@@ -135,7 +135,6 @@ int cobalt_alsa_init(struct cobalt_strea
 err_exit_free:
 	if (sc != NULL)
 		snd_card_free(sc);
-	kfree(cobsc);
 err_exit:
 	return ret;
 }


