Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049466;
	b=TWKQbxOj9Jaz6Sjyr4lBQG3tYgJlIHeCYeC6vnIiLt0i+GU4XYjt0aL5ozGFUJXkJwen
	 gEbrZR1rrOFuvXuunRDbtsr7fMfV/HwIKaAbQxEL9mFcWLG+o61b/YwH2mVYOqdZvf6ey
	 JD9GIHHkEQto8x4tWOV7nokn0PvwXd8n2Z2KklAJ9xy219AxuLjIN2pYBX7mB37GK6nqe
	 WbZP6pJ2UhYwSJyI1XbO5OUDRiRzrTClDVFGUc+z3tHORw7sEEbIrtWewozni4MAiEJoY
	 PmCTfFqRxfzQfqX3KBwa61ta2TC2Gq8dXXr1xJzKtfruU/zW4qVf1cTlu22a4m4JCDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zPLE41Im4ob9DkLqxRV3pd2m2r4yDXoOdg1MhmsUzos=;
	b=Zj9DUBqrDaJISE1sB+k6tiaICvvYZP05Fb3gFYtNKjiMEbN1wC6rWNA18hZe1XFXGgHN
	 pb5pGYOAND+JyY4UXsUe2wVTFDvGQnsfnyItUKj7E8LJg2q6F5YM3+k1SWHcwZvWDXjsa
	 TGvkOdQOHIVf2tG6/Ez9zvoFniTHWoICIF1ixfuAllvXKgavKWZhtydg7MT5cFV+AXeSK
	 uZLKu+WU7wUsor0j52J8edNgcpmf07BtSFMRnrbK36InOOBPll89mBBFVY2MgbOmiei6x
	 P680l8JKw9cKtn8NtiRwO3kBl+ZvHYxBZws7/L+jgRBcgy9m1TXRx6DS3KA9YP6Yn2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhPqTwve;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7395B606A31C;
	Thu, 19 Nov 2026 00:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhPqTwve
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9691F000C9;
	Thu, 19 Nov 2026 00:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049466;
	bh=zPLE41Im4ob9DkLqxRV3pd2m2r4yDXoOdg1MhmsUzos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhPqTwve6LTpB5qKNLI3gS3QdJgYU5/qjxOwWZxl1tndRCcdZgMC1k5RX2PNXwMwm
	 v/BG4qNwIsXy5X3TI0dAGa0d2y6tFrkCmgEkvThnqirBCrtQxwhrnrLeGtFy/yStXm
	 rCtCOXPzKdQV7/Tswt5fk0WW5MvMmFfVESxldjLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2320/2857] ALSA: hda: Fix potential UAF for gating jack
Date: Wed, 18 Nov 2026 15:55:54 +0100
Message-ID: <20261118150325.073132989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



