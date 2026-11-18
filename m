Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055928;
	b=b6PtPiGbm3JEBsZamHMKWT+9Uevc3bBTaSX9p50XK3BWzZvshDfZmLnuIIikhn3cfjQP
	 7Q2AmSUSpJ5hvTh4psMFec8SUF6xPS/e9QiLKEFXj4izLnN/HZrDBTR/SMcJxIBO5xhs7
	 7y+xp5pnM5mRRnuxD5NHcC5ATmM/wHSUWJYFPGLUzd5cm9fDpHLPGMD+j2e4/fD8+QCxB
	 WQ1lTA1vWw+azFi9+0DtqlGhqri2SvVjiJeIKU9kVBs+SGgIwLi5Vgr3wQb5sJH8Lu6Eo
	 Xj23Mta2Ivk077MqGk7xR/ceZOYXYdvEAhEkraLqkOcWbAeweszAEE8Dp7JYifvYOjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QWa0M9DnOnrm8S6Fh0M4fteX1gzCIV7gcwQqHJaxRQk=;
	b=MwUf70FAkd6UhdMEQ1BKWZrtqdubbJow5EkjS+MOkjyGq9fhSuwT0Kwhaj1SB4dZSAR5
	 jgtuyeN/kbVCUceIYkgcpqF/VNmQOqrOdkivJC2HNjoSFDQRIbyGJt7/jLm8KeDJHYdt9
	 cHV4NBKdv0i7bnDcAR6qawYYw1ach1rj3TZqaqxEGAhmgVr5LHmCD/zL3Hyog8NnEe8vB
	 bYHoq4aJq1e+DtkN1CTJhfwoyQOE+jB1P1I68Vbkcflvj068vx5Ba6CPU/GXFJX5dMRYF
	 MI3gH2K5YN/TBvQHoxAvx8+/gjMKTh6Ji8eJxftGk817PjsXJrTRWC6mzoQGS6qqDVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTz9JA+F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8866606A325;
	Thu, 19 Nov 2026 02:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTz9JA+F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2ED1F000C4;
	Thu, 19 Nov 2026 02:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055928;
	bh=QWa0M9DnOnrm8S6Fh0M4fteX1gzCIV7gcwQqHJaxRQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTz9JA+F6totY9FSqMFNOgg+Coj3/ZA5Kwh2CFJWlO7zVK6PdPWp1EkDQwj0Ufrk9
	 BuLWxFn6Wenw/MBFtdGcuVzmKGhj4d45u3ug4rZZabKynPIhYWnr8ioOjalTyedvIe
	 plcdcr8t4CqInN7dzB95MeN3ytfNay4xuRbypBZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1805/2214] ALSA: hda: Fix potential UAF for gating jack
Date: Wed, 18 Nov 2026 15:58:01 +0100
Message-ID: <20261118150123.703143137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 27cee4141c8de82cf051104ca830c3a209816033 ]

snd_hda_jack_set_gating_jack() assigns gated and gating variables from
the succeeding calls of snd_hda_jack_tbl_get().  This works normally,
but the second call might kick off the reallocation of the jack table,
hence the first pointer might become invalid, which leads to a UAF.

For avoiding that pitfall, this patch changes the code to two phases:
the first to only create two entries, and the second phase to get the
pointers from the table, so that no relocation can happen any longer.

Fixes: 0619ba8c17b1 ("ALSA: hda - Allow jack state to depend on another jack")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-4-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_jack.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_jack.c b/sound/pci/hda/hda_jack.c
index 7d7786df60ea7..8c25c7d81128b 100644
--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -383,12 +383,15 @@ EXPORT_SYMBOL_GPL(snd_hda_jack_detect_enable);
 int snd_hda_jack_set_gating_jack(struct hda_codec *codec, hda_nid_t gated_nid,
 				 hda_nid_t gating_nid)
 {
-	struct hda_jack_tbl *gated = snd_hda_jack_tbl_new(codec, gated_nid, 0);
-	struct hda_jack_tbl *gating =
-		snd_hda_jack_tbl_new(codec, gating_nid, 0);
+	struct hda_jack_tbl *gated, *gating;
 
 	WARN_ON(codec->dp_mst);
+	if (!snd_hda_jack_tbl_new(codec, gated_nid, 0) ||
+	    !snd_hda_jack_tbl_new(codec, gating_nid, 0))
+		return -ENOMEM;
 
+	gated = snd_hda_jack_tbl_get_mst(codec, gated_nid, 0);
+	gating = snd_hda_jack_tbl_get_mst(codec, gating_nid, 0);
 	if (!gated || !gating)
 		return -EINVAL;
 
-- 
2.53.0



