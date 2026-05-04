Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7303AA4F8;
	Mon,  4 May 2026 14:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903837; cv=none; b=N/spcWnKTOCnJ4xWApkUWwk2ThuqOUCCX73yUvcAtbhIQ99xP7ipFU8cjNsHZl/pw82oRcB63IJHDkkFVnkd9ToqrrSaChDyssZmb63YacPHvQVFvTdL4HaAzsUGWdoDpm1gGJ9IQbYiC5+1y6OgGelqGPuykglazoLDmykznus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903837; c=relaxed/simple;
	bh=w4TPF1ATkOoCsxPs5Iau7MWQq3fI+0LP836k7IxlU1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0xcyXOrbFAi2lVZ6gBPDTrSB9wt1gy6KdlBK25iH+tKFRA8EZY04ZjcRSxNDGEgHa6fD67hULYA27e3AfGgIBytHH8d5SJ6aPHdot4k4Zuae5Liq/HS7JkPpGHWyniWDcT2XyYqB+z1XJg4I6IVUbaDRQfrDC71hGT/B7+ZckQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPMc+Uby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPMc+Uby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736EAC2BCB8;
	Mon,  4 May 2026 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903837;
	bh=w4TPF1ATkOoCsxPs5Iau7MWQq3fI+0LP836k7IxlU1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPMc+Ubyotierbhc9Le56SaW49ssR8kpX7l79B8lTLTbK2WRa1JR5uWq+OJTI7gzS
	 10f8WbODMWvBITT8WQ2GzlmKjThlWRFf/DRPFqca4KLkGBBMuQjK5wvPuT9El9E4V2
	 tUjkoYOOIMw2Gd8zL6dHNtBLJdkzlfLxgG0iYSmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Arun Raghavan <arunr@valvesoftware.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 054/275] Revert "ALSA: usb: Increase volume range that triggers a warning"
Date: Mon,  4 May 2026 15:49:54 +0200
Message-ID: <20260504135144.941923426@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

commit 41d78cb724f4b40b7548af420ccfe524b14023bb upstream.

UAC uses 2 bytes to store volume values, so the maximum volume range is
0xFFFF (65535, val = -32768/32767/1).

The reverted commit bumpped the range of triggering the warning to >
65535, effectively making the range check a no-op. It didn't fix
anything but covered any potential problems and deviated from the
original intention of the range check.

This reverts commit 6b971191fcfc9e3c2c0143eea22534f1f48dbb62.

Fixes: 6b971191fcfc ("ALSA: usb: Increase volume range that triggers a warning")
Cc: stable@vger.kernel.org
Signed-off-by: Rong Zhang <i@rong.moe>
Acked-by: Arun Raghavan <arunr@valvesoftware.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260303194805.266158-2-i@rong.moe
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1820,10 +1820,11 @@ static void __build_feature_ctl(struct u
 
 	range = (cval->max - cval->min) / cval->res;
 	/*
-	 * There are definitely devices with a range of ~20,000, so let's be
-	 * conservative and allow for a bit more.
+	 * Are there devices with volume range more than 255? I use a bit more
+	 * to be sure. 384 is a resolution magic number found on Logitech
+	 * devices. It will definitively catch all buggy Logitech devices.
 	 */
-	if (range > 65535) {
+	if (range > 384) {
 		usb_audio_warn(mixer->chip,
 			       "Warning! Unlikely big volume range (=%u), cval->res is probably wrong.",
 			       range);


