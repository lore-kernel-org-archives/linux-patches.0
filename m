Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031248;
	b=My+C5a2g46I495VOPlDq33HpgOu8FmxgDWmW/XFhg1pKXwF1XmbNl+1zDOue+QZM/hPY
	 pUeqa58aeRxxw9k9lhllpTuNqukrosNQ7bZHwoNUO7XutzDkUzcSGmixMvtAeUrM++2LR
	 P390K8TD3qlMZ0LHal+2sUejyBN2V7nkz3AhIl4OiCwSWARPNgvwMh6UIXfuMHZCgU3X6
	 SxeojbGRQYNBtvJRBbpAPYpRl/DX+BX3f64XJhHS9znPQauuvZKYdtGHm37PY92FaTqM+
	 D8SMM9EjwqSQx9VCKojxlDXVV0gvBsUymbGJ+QjtAYVsDzYJQNHU5Fq/Ec4vYxfjErQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ajz1/dLrYBljHBxXjyLYknWBgMlJQq5aJcCqkoD/pi0=;
	b=Sah/dm7YDA/Gy3HjFg4kppINv1s7SLS58ANpTAzFq377OsOv1SsnuitGUbJqd9b2ruZj
	 xLGAhl8uC5ZMZZFGQE6bQHzR26fRfZUCaIJ6FxCShAoXK+YCXoL8n4xbYF7lJ7KWFchng
	 2RXfgFXpM9eTXV5vDR25GH3ksx2hjE2pRb1WjLK0wG4dhaIWBXkET10JgJF4cI01rzRHc
	 /m4W+T29AQrjvMLKCJCsoTEIWuyg/JyHRub4GRgqmAd4pmUNymcSWPNbHTyTExD2xDm3o
	 0xsSCZj6B3CRetifPENT2wTqDHEP6vzHM1DtxIO7HbyIg5eBq3Ec4rvpUtMxrmuDe/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XbOmc3/V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EA5606A31C;
	Wed, 18 Nov 2026 19:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XbOmc3/V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58551F000C4;
	Wed, 18 Nov 2026 19:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031248;
	bh=ajz1/dLrYBljHBxXjyLYknWBgMlJQq5aJcCqkoD/pi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbOmc3/VTSlhRB5/52lFfa9T5vVRPtphlfwKc4Y2CTd7D978jxlH7q8h8VYrBA7Oi
	 Dr7Hjvp8MwtG4xfzNg/LiUOFvHZADigts/8YmdjxGuxSaWBZKbHry0KFBWEo899Qar
	 EAFmRi/xp4P6rRRt+Q2vLJ7EdfPzYYMoqvC6uXf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0991/1756] ALSA: hda: Fix potential UAF for gating jack
Date: Wed, 18 Nov 2026 15:51:58 +0100
Message-ID: <20261118150049.627976535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



