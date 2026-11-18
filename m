Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041081;
	b=N13rpey515WwkZ92KnvljXhiMJnDZZSoAsziLu9EzzSxK+wZ65LQAUJ/3lQLt/bA3S7I
	 WUc4nZHPb5wFDH8bzPGIwhoSvW3kvP3ETLlDSo9Kqr6AV5AnxzfgsPp+Y3TkoiBVKOzUL
	 coyE30BiW+q6NVKNjoqAQacoQ7V3ScvC32/NaBg3A0WIRoQE2SkTqWsPwrBKm3sBzTmgN
	 K/q3975aiThvEtGpUjDNZF5OeBegZoDHm5yMGdGVHgAkQAgD8wX4/63D0Fe/awLoRveMD
	 6vrnSX2YHdwnI+PHWDYxP1grRalUpXeNJZscIWLeXASTdT0B+5bXsj+Z6pcwGgk5LNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOpAli3i3QlqQHq1+sb/Ic0RTR7Xq+2khb/qNyarR4E=;
	b=Ufyhn6ykctXEDm14baqkM/hiNPMTm5zCEtK8o4sv9YO5f0+0P/B2Vhg+zkjC2+VNMBaM
	 +F0eoN7q5GjTmHTqkh0KiMwAEbx1a+d5tFh3OI4mNkk2QN5jTyQ+apau6gN6WidCjywKp
	 RECSSjcaKtucbBRGeSVNUNQ+sbDD0eHX9Dr7AOiIZOl73+/TqWmrdeRWekscirfea1LSo
	 5VjgR5Bd9JoCYsokRXh4nh0xG/pqqofFodBfWFr818yBaITps5SFXxsJapjjIDAKMJ2yp
	 uxyWC4/3Al5uBtrNaQamhD7xh5aNGnq6vNeZ7ruAKjg7bHDaK8X3YxITmEILIC2L4Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erK7DrSW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4345B606A325;
	Wed, 18 Nov 2026 22:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erK7DrSW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD8F1F000C4;
	Wed, 18 Nov 2026 22:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041081;
	bh=vOpAli3i3QlqQHq1+sb/Ic0RTR7Xq+2khb/qNyarR4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erK7DrSWoFOjKMvaIOcHyOOhGyN1n6CMbjFmioAQq2YQFyVNEdb59ZEAI1rkntVSw
	 VrHRexEWvju4s6ednGgwYDluLdLHLJyAcWTA9WWCQsofeKuWFdP5gc1bI/kRy1F2nV
	 dK5P/xsnnjOa+e9Pik6YI9k4mgBASzICvN6UWdI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2687/3318] ALSA: hda: Fix potential UAF for gating jack
Date: Wed, 18 Nov 2026 15:55:09 +0100
Message-ID: <20261118150441.576132706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



