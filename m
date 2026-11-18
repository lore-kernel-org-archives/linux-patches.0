Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019219;
	b=TclyFbCDbC5JLeLyxvX86p1f6XP8vFvUSzTSEvt3V9qiU8Zx1POvgtvRxs83SHqtx71X
	 Pm0xni1bNJ+tJ5+kPpygtoP2maalv4oji6sOLqjWkkTErEtwSEkgv7iz9KzBjLhmIMzP5
	 ztLCwudW+fhfDX5+fMm1fzcXChDki1X0RY4/hiGV/qQ1LobVvD5h4TvZXC16Pxgz9ibSV
	 UxrUyXHgFj/Ps8BItvp9mgVwqUgHnLHlY2Dvb+NP+Gjwm+OxUZpjGPLVRTnq5F+v8MQk7
	 m+sCkhuBtp3Ad9KZVsXITI7D3rI61eX/sjjyF4e0/l6cC2KoPfI1RXglsDdOdCm5RNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rYR1AZQfFtyj4ny9bDfMHxOTIL6/jNNo1xOfo0o1bnY=;
	b=x16guQkfoDCIM2BGUHeK/GbC7N5rl50GnMrEBDmkkoXL0bV+ojbjK9NvPJrPc5VVkP5y
	 R3SJ/nznfT5Afr+e+g7dcpOTNXksLQvLujbmAXRz9mUYnatrQZJ4sr6gaLKJsn62clDOm
	 XPgDWllDN+1mv2+18Nad/LIEWAB/RJHbBPmZB/WH85ga6nZozKS3l+qZW29/+Az/Z12bD
	 VcK7atIXyhuxK8CfMCdsdpq50fCQiRH9T0FrxypQjBAVmeklBYt73GAHuF9qrNO+yCzlR
	 4EuL9Ew6URnNv0kOcCLKfUBkamwbcjwfEwT0GYjnNel0tZN8KPfZaiNMYEj8wEiwJyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stve0K+9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E399E606A330;
	Wed, 18 Nov 2026 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stve0K+9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0191F000C4;
	Wed, 18 Nov 2026 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019218;
	bh=rYR1AZQfFtyj4ny9bDfMHxOTIL6/jNNo1xOfo0o1bnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stve0K+9ZESr/lNyd8baEJDHAsE/EvZ7RBfEIEREFeI2pYq2QGe4ojVK64ttpRYNv
	 cx3DvcB2EpXfNZciSK/2mjswEVCfK12HD9yUBsENxKPvgL0mUXdK28XNKRo8P1hRu0
	 c2CNQQZCM5CTbzyhOplkvXRHxA+oPl9OyhjYQ0zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1517/2651] ALSA: hda: Fix potential UAF for gating jack
Date: Wed, 18 Nov 2026 15:45:57 +0100
Message-ID: <20261118150342.612509999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/common/jack.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/hda/common/jack.c b/sound/hda/common/jack.c
index 1d6b0f0e6f27e..c3efab3b5bfee 100644
--- a/sound/hda/common/jack.c
+++ b/sound/hda/common/jack.c
@@ -389,12 +389,15 @@ EXPORT_SYMBOL_GPL(snd_hda_jack_detect_enable);
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



