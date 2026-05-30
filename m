Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83F73546EA;
	Sat, 30 May 2026 17:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163357; cv=none; b=t90YwABn+j2bSV4vtt9MWZTnPokF0K2X93BPuihqO1aA3+Ijzm6/aVxHvVI2T6nI6B26zd6vlloD8QW3NZLq6kbrlifukcBrn9saL5SMtuSKu50wTkOqGQqZ3XAQbxyREZHBdE8B/D9bVNGtSFp9uZTsmf3ImPCsAFe3mK9i77M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163357; c=relaxed/simple;
	bh=L995lA1inwrfhYcPB+6DeNHyMo/hImpbKBLTsJUUtj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyfgNP3mhfHUQ7IoOa1fcjLIjcuTE9lF01cfOQnM/RwhTczqfgtYjCefGwxHV/h4YQQKhZQLyYf6C0lQ0IXPcWri9IX4B3dDjQiH2B0yKA6QbrajIS2vhNhBMUJx2DvmCGOVYC68X6VRYtrHm1PuaYPMXVWymixotLG26wW2RHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSnZocKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSnZocKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3591F00893;
	Sat, 30 May 2026 17:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163356;
	bh=ZH2KIsuymPeWyysODto6mEIFUtAzgQtdkI+XdxKfG3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSnZocKl7IVlT+qi19QuXB3/T/MRXNRNXnNz2GhqnVwCPrOuEzUPKG7zOyBYCmBB4
	 kN+TcOHpj923UfPGkHXPiKT8zP2iUPy9jZDSL34sIYkjoTfW0qkoSUgAr8rn6GlobZ
	 hf7fPGwJdzn/vhRovd3piXdiYtJgBI4yKMa0e5yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Arun Raghavan <arunr@valvesoftware.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 203/776] Revert "ALSA: usb: Increase volume range that triggers a warning"
Date: Sat, 30 May 2026 17:58:37 +0200
Message-ID: <20260530160245.756958182@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1804,10 +1804,11 @@ static void __build_feature_ctl(struct u
 
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


