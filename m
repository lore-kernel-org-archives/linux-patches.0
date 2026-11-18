Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061397;
	b=pa3ADFUGdANPB1hDUXQ1f52bBYAPiIKGDlSC1cuGkTxKO7k/teZk8iIPfDb6RsckfnjD
	 KvdYrsCEA7BMSU5HK6U3MXgs8OFWcqcLv5T3O8E7TBH7Fz07+RAMaxztAitsM6er3KPFM
	 5gvj5Df+8u3RonbO7xvZZWo7Yr/4FDP2J/2fGivsDDeqG//h25lvPtlB44R4WIcyOydP1
	 zRz7Po2M9534kowtb47wlXAheL5kvuUTtCEvATTkpENdDdqJXF6tPm5duKXLkEXg6Noot
	 1qQMadouZ7x5jrhMJjT/f64X29btw9dtVCr8m6z+LgdUE+YIz6JDASyxl/j7zYPPlBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0++fV7mEyZ8PspPljAJH1lRP84C1Ut4pk8kCsPv3UI=;
	b=klPB4rRSx8Tmfaij1OlU+4JW64j02rZEui13Id20ZvIlOYnHc7vpuan8OobetVn4soNI
	 0syyq360v2/hFCjDYfSop59jJgrw2wWzJ1SWuzzBtN5fiKItPhoJKDVazwmmPw5aLxV9Y
	 P52Sxmy5WNy9CskE/jr8ne1l1+hQS3FaxgCzCKcJOzvynNM/rTXlXAyLIgJgenZOVlbtw
	 1lEhx3RV90ANIbCNtLt8H/6rqTUXxM/uU6+aKHXMkfIEhBx0Vu8yOarMmQ5yu/CTJCSmD
	 zkKWmF7oIq4017Fcs0+QmpwMVqLPr6pi9E9zZIA4T43h1q0r/7QjjjB+pKxNcxeav8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mgCpAI6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F70606A320;
	Thu, 19 Nov 2026 04:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mgCpAI6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FCB1F000C4;
	Thu, 19 Nov 2026 04:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061397;
	bh=r0++fV7mEyZ8PspPljAJH1lRP84C1Ut4pk8kCsPv3UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1mgCpAI63YjCOd1bc8uwfm6G/EaXEpgPYFAoEHdc9YTfdWi4R2V9/P14IJ2/LoFB1
	 WfTlaI1DOG/0i5OZEJz5vsE2ExyvURFt8iUaBJs8ErnkFQGPCu8OjoVbqXRpn8wIvt
	 2nZlkS3ysZtw/bjwL0N+Rx8rDvlLDsX19uOLvv4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1537/1848] ALSA: hda: Fix potential UAF for gating jack
Date: Wed, 18 Nov 2026 15:59:35 +0100
Message-ID: <20261118150023.855718958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 588059428d8f5..b0dab87de234f 100644
--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -372,12 +372,15 @@ EXPORT_SYMBOL_GPL(snd_hda_jack_detect_enable);
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



