Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2477994A;
	Mon,  4 Mar 2024 21:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587748; cv=none; b=jRDi1JLUH5BcV/AcqWUs9dxEm/UWibFz7MMufltwEfzOSOK/X7FSqTTGpzoISrr2eW9XWd5tH39pWR72oqbTGRQBaGrxqjiOYZw87vaTcSSzzO/YuQHBNR+Yu23O0BO2R251OSDccucZ/b0Q7KBHfDPfyOYcscilCFENSXICLaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587748; c=relaxed/simple;
	bh=5hk8XT5UaIttYubOVKig/OnBULtdmdNQOoc6KF8tJkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIJLrJcSLeeEBDv1iaEp4rYDeSBjOMEKH+wlTMA1HkrWsLmOTzbIuzzRqGkk8RjUfUoOfeWOxDjnQF1yyhLucOKRh3lHHtJPkXC7OVyWup+HbGimo5jl9PVVp8364Ss7BMFhRU4/doxAvb8Zyb8ZMoE11lKhQI3obPrUZaZ92W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHuA8OBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHuA8OBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0064BC433C7;
	Mon,  4 Mar 2024 21:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587748;
	bh=5hk8XT5UaIttYubOVKig/OnBULtdmdNQOoc6KF8tJkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHuA8OBpJvFWCwBtb+HCEFx5EpJfHxzPI46mFFmB3w64PvYMK4PBt2Qx2evpl6KEk
	 ktlNz55szN/wwb6GTMKcILODmkCXJri5yRkQylH4UOrL2SRWGS+QaoJ2Pn2T2p+Hp6
	 nTcH9ZtdS/RFnFT94KZ3ct3xiNepKuE65B7pF8/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 075/162] ALSA: ump: Fix the discard error code from snd_ump_legacy_open()
Date: Mon,  4 Mar 2024 21:22:20 +0000
Message-ID: <20240304211554.257150861@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 49cbb7b7d36ec3ba73ce1daf7ae1d71d435453b8 upstream.

snd_ump_legacy_open() didn't return the error code properly even if it
couldn't open.  Fix it.

Fixes: 0b5288f5fe63 ("ALSA: ump: Add legacy raw MIDI support")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240220150843.28630-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -985,7 +985,7 @@ static int snd_ump_legacy_open(struct sn
 	struct snd_ump_endpoint *ump = substream->rmidi->private_data;
 	int dir = substream->stream;
 	int group = ump->legacy_mapping[substream->number];
-	int err;
+	int err = 0;
 
 	mutex_lock(&ump->open_mutex);
 	if (ump->legacy_substreams[dir][group]) {
@@ -1009,7 +1009,7 @@ static int snd_ump_legacy_open(struct sn
 	spin_unlock_irq(&ump->legacy_locks[dir]);
  unlock:
 	mutex_unlock(&ump->open_mutex);
-	return 0;
+	return err;
 }
 
 static int snd_ump_legacy_close(struct snd_rawmidi_substream *substream)


