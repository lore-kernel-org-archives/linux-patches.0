Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7322E11D3;
	Tue, 15 Jul 2025 13:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585569; cv=none; b=Lx16JAdUgdk4KtE7+Fc9t2DnKyoXOKhrbETmAxaTxq21QstLwfWtg5eU6u83u2uc19pN7nZRpaU8SCyGcYLoLsjKLDSAdbZ0vlvV8BWDeEEaHq4cgOQgbI2ZhN+f0S08qrG/7Hkzp/UohzGWxRkHkQptcEmatDlppkqL/EthbsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585569; c=relaxed/simple;
	bh=uU+ZbTUetQ6UfAWdmpWK0nvfJowIDV0JaUhoiMJA+rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3FFV2tYI5dU9D4ljpMdAZk2D2l4lsFtDZX0Cbem7XsLEcIgaqOwWd03Vdvlr6YfONN+VpzT2nnYpZNbSQsmT8VElL2wMJxZp0rVytLqY5osEeqp/4xcCVoe9+u0vaf48pcqt3Uu76h1EIizQYDvVSHo77zqjvAlguj/h64jk0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UKCIFhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UKCIFhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566AEC4CEE3;
	Tue, 15 Jul 2025 13:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585569;
	bh=uU+ZbTUetQ6UfAWdmpWK0nvfJowIDV0JaUhoiMJA+rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UKCIFhvMBhvlgOmI/UkDE+XdkrBx0o5praWZ9G/TN8ne61EbgegUxOWV62YrGycM
	 o4KLJedfnYfa+qgA/GeKjUndyFamfwONxTCXJgwER1Ns+wBNXOXzWXr458VSeLVLKr
	 Ceb70UT6QwmFspN8On2P8Sb9obYElxWDJQtSek/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 058/163] ALSA: ad1816a: Fix potential NULL pointer deref in snd_card_ad1816a_pnp()
Date: Tue, 15 Jul 2025 15:12:06 +0200
Message-ID: <20250715130811.078634860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 043faef334a1f3d96ae88e1b7618bfa2b4946388 upstream.

Use pr_warn() instead of dev_warn() when 'pdev' is NULL to avoid a
potential NULL pointer dereference.

Cc: stable@vger.kernel.org
Fixes: 20869176d7a7 ("ALSA: ad1816a: Use standard print API")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20250703200616.304309-2-thorsten.blum@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/ad1816a/ad1816a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/isa/ad1816a/ad1816a.c b/sound/isa/ad1816a/ad1816a.c
index 99006dc4777e..5c9e2d41d900 100644
--- a/sound/isa/ad1816a/ad1816a.c
+++ b/sound/isa/ad1816a/ad1816a.c
@@ -98,7 +98,7 @@ static int snd_card_ad1816a_pnp(int dev, struct pnp_card_link *card,
 	pdev = pnp_request_card_device(card, id->devs[1].id, NULL);
 	if (pdev == NULL) {
 		mpu_port[dev] = -1;
-		dev_warn(&pdev->dev, "MPU401 device busy, skipping.\n");
+		pr_warn("MPU401 device busy, skipping.\n");
 		return 0;
 	}
 
-- 
2.50.1



