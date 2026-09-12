Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C86C4908B9;
	Sat, 12 Sep 2026 18:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237922; cv=none; b=gO6XlQ4HzKCPf70W1r/2GU1+mg7V36VW+O0VIa2sqUk+l2GTpwfIHXiHCwszojsEawMSXt1zhBlWKuZtyM2AzSSc+uBev1+fk8ZvJnoaJhvAZDBhaLsawtq/yE6yMtAfsO0cDxSdJ0nCtWx2mHUz0FDU94ZuPTQJHOiQAfnXePY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237922; c=relaxed/simple;
	bh=lN8SmJhtmeEmOjvFWysNDbNxJqmrkP7X2Vomdm3WkUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibJu4nRr4+Q6Eooes1sfca5msyx7FLG8XkSR+FWQ6XzTA+XdnOlQLZcP1Y1Rgtsn13JUHUzeXIsnYf3BM+D3pN5X8XbiGW2CgSnU23GTE8hGL8e7P1by11jnw6rfXg7UDZI6xYAadxIw1c/JhPA7eaeMxrCl0kavelBE4VnPWIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFh32svs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFh32svs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA321F000FF;
	Sat, 12 Sep 2026 18:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237917;
	bh=JmhK/e2YY3dic0n6nLASqnNYBe38o9LA75qEClAoLcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFh32svs5FbTUvDviVl/RppXjXjqou4UT38Qv0xkj4NKkkrse3fEKHCAWN+8a4BVT
	 aoeoA6ENDuLnbmyjxK45ckEkZwOhwyz3g4/7stGR79u7O8CYFUxcq2PrQ/T4udx5H0
	 YGOy+HhcVxNBce/ZuFSyh91yG2USGOTCv77PasK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 312/935] media: cobalt: Avoid freeing ALSA private data twice
Date: Sat, 12 Sep 2026 08:55:42 +0200
Message-ID: <20260912065533.962342822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


