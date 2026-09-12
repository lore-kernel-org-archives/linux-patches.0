Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B653264F4;
	Sat, 12 Sep 2026 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228344; cv=none; b=CVRKqQVpV9I71McToCGB6NHLTRnZ3sRngefnpToc2cjY4flKGnPJWMOtEMecXUTvzZwQhSw7aUHkgTjIfCvyhL6f/VQ33qMPBYRK8j/TOQEtecRBFNz/TKXAsWuyl9/9DbfsAclYPHIepnDkjj8kx6lOQvc7/E5xa/bwacW94W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228344; c=relaxed/simple;
	bh=yVeD1uobl31wnX6X5hVvJMPVYoyfH7iN5COgEbAH5R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJoJGOz9VU4GjTauCrWIli5NnNXUP9dGqt4zw9+3y4EcjULWBgdJYYvmiz2qhBt1SacazdvSmo1y01gMqAjwPxKkXpNfUBRWgBj4pkRjkusrEXLDvtHgHwi6vajQii+I5xWr/DYMVCQPjlETrH5WhY1wZI2/87gWSQJtFM45PmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAbg/Lkz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAbg/Lkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF9C1F000FF;
	Sat, 12 Sep 2026 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228342;
	bh=BNC7l5Q/8fAxpqTlo2jSI9ULpZdUJ1wmvvZNpDSQ9gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAbg/LkzH8ZeWc/dhaW62+7USbIAZ81Xjo66+XelSGrUHLqsM9iqZzEj0uCC06Npc
	 hjCNSCCKlU7WeZu+X2dbxUrNH12m/gxIYn+5FgiYugsvomgub0TZuf2+fKh2RoQgYw
	 2mXA2cJzlpPGHZQHaU5Q+w59febg3+PLzq0ZBUnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0365/1191] media: cobalt: Avoid freeing ALSA private data twice
Date: Sat, 12 Sep 2026 08:51:33 +0200
Message-ID: <20260912065556.426348062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


