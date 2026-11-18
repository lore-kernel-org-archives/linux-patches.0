Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025936;
	b=tbS9xtXeto8gajkFzlg9QLvPhzt4BkGadDeWQ0ymj+755GfWd5TvzwIPYkUxP5ylZyJt
	 4TzXOiPGzbJ4N5rFbvj3OhjBpolYxtStJKBO86yh1igrpRREMQW9oHT874p6J65a8EGIM
	 IQ1zHqEARha0jAGKtotcdrNsza3JYi+Rci7d8lYJhESRcH+IKAmpadbLifl6Qs9ATYsBO
	 Wi98oJE0ZLoUHoP70FikmYeWBqFKx5XIkamKcd90Y5BmhYBgJVC6Uhj1+Ifg3NUFG/6xX
	 8f/leEF8SOfpfDEjOdESh0uiRYodjrRJktQmBSu/+2mN+UZ5zdrDTCq+0tUKJ/hX/2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GPTWyiLYPQ8MkdRGYHS/uy+96d4lh1ffHJGp4elD3hI=;
	b=FPgWzau54zbf5o3SREyARKk3z09pRBkBycHq1RtmHdR3MPdDnNi14o/x3PRoJKeRuzPt
	 Xj2gGlwJNWpnQQe5jRQbEn/MiBaMP/kgVifyQBx0TdRjJ4Hj2J369dZyT+DYn16GQDNg6
	 At5tI4XsycaZuU38g9+oJ604ZXLcKyqyI858L95Hp5iBVX5gOimXPIkm9mKNcLcnYjgyW
	 x2RhAZJWSeDPWKirTpe1gPo/LCVgBrcBKcNpBkQE59oAH1iWCoDjeAWXGvTP+pSBLqlLU
	 AmAOOdzEw2DlbdiFSPL1M2Akhx+6xAwgCNilhyy8uPzkTNMdz9ij04MAaU06AoGn86A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P02QEf/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4488160A2600;
	Wed, 18 Nov 2026 18:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P02QEf/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527321F000C4;
	Wed, 18 Nov 2026 18:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025935;
	bh=GPTWyiLYPQ8MkdRGYHS/uy+96d4lh1ffHJGp4elD3hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P02QEf/LQUqxI71mTHYECbsoZEInuD1qAOhETwcZDc7BaN0YASpsuGmTYSMPPyCT/
	 kT/oX7StzhgAUWWWvtolyu2IASTr0kE4kdtAhaTGdeO6bvTPRrYz5k8XcHGY8dwOEh
	 sSNZIMjfwXl+a+Zctkdj2EzYiSfYe4c7I1CmKNBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1257/2151] ALSA: hda: Fix potential UAF for gating jack
Date: Wed, 18 Nov 2026 15:49:52 +0100
Message-ID: <20261118150207.949749949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f921b10f39c93..bfbbfe0cbdb92 100644
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



