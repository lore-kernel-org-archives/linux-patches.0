Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68F625B2E1;
	Mon, 30 Jun 2025 20:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317125; cv=none; b=XngeKGCl5kfeqiGqtyYbbNNGPjIdl/fA/azMy+uvWeF2Hl30zh0ugHl6GR87y0uAZcuJvDcG1JEdBRPm1D8HTlfPF818H+nw3ZWrGTFHmdwhTWmnsFQCJFRsAPuqb06O7mvGhGVnh/EMByxqgPZfmeWBn0ZyKdMcgCTYGkqM+N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317125; c=relaxed/simple;
	bh=AvSoE114FlYGApNfu+jAnRmSYa8O/+8QFftL6IIdZ1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DV+//TJHDrC2/wIkEr+KvNBUvQu0vbiaAb0wVYROHBqJG0rkplN3094790TJpyivwdjxS49V/5Lqu1zOQwDXstv3gC1Fl9uwvwcR0lNb1fiAZ4rGpKU93Sf8WPMr8N/Msi0kqroWE2fuPCQdCFFQUjYPcWUo2C0alMvX0tH8+JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ys0joSII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ys0joSII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831A2C4CEEB;
	Mon, 30 Jun 2025 20:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317125;
	bh=AvSoE114FlYGApNfu+jAnRmSYa8O/+8QFftL6IIdZ1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ys0joSIIyZcWIzwp56gyHH+iuCjmpY6MgqYTKRUKTnlyO1X8f9nZ4Kf+xz7TFpU68
	 C1lR9FV9OAdgudHYaf6QHBUacpNF2zWYBGOnsM/6L0rz0o/iX4dmCm0Nl6aPl4xUfY
	 VApHgPKIg4hrIGQe5/t8/6SZwdJHVY88YAfLgMpvAUyfwwfiVCgutd33zkV0SXf1vw
	 XbD7x41NsPPx+B/+mpBT6cLqjqtw0HSAbp1PLVScOtp/yKSnCKhaVYWjBgIu0JQ87K
	 kXEvzfkiFsT6E3i3oDdCMVCvBfrrGgUyrLzF8DoqG8l1QVso3ks9l4ahQdmf1ZfUye
	 2zK6KzNgfmpBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	simont@opensource.cirrus.com,
	josh@joshuagrisham.com
Subject: [PATCH AUTOSEL 6.15 07/23] ALSA: hda/realtek: Add mic-mute LED setup for ASUS UM5606
Date: Mon, 30 Jun 2025 16:44:12 -0400
Message-Id: <20250630204429.1357695-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204429.1357695-1-sashal@kernel.org>
References: <20250630204429.1357695-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.4
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 41c66461cb2e8d3934a5395f27e572ebe63696b4 ]

ASUS UM5606* models use the quirk to set up the bass speakers, but it
missed the mic-mute LED configuration.  Other similar models have the
AMD ACP dmic, and the mic-mute is set up for that, but those models
don't have AMD ACP but rather built-in mics of Realtek codec, hence
the Realtek driver should set it up, instead.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220125
Link: https://patch.msgid.link/20250623151841.28810-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Code Change Analysis

The commit adds a single line to the `alc294_fixup_bass_speaker_15`
function:
```c
snd_hda_gen_add_micmute_led_cdev(codec, NULL);
```

This is a minimal, targeted fix that adds mic-mute LED support to an
existing quirk used by ASUS UM5606 models.

## Reasons for Backporting

1. **Fixes Missing Hardware Functionality**: The commit addresses a
   genuine bug where the mic-mute LED hardware exists on ASUS UM5606*
   models but wasn't being initialized by the driver. Users expect this
   LED to work as it does on other laptops.

2. **User-Reported Issue**: The commit references bug reports
   (bugzilla.kernel.org #220125), indicating real users are affected by
   this missing functionality.

3. **Small and Contained Fix**: The change is a single line addition
   that only affects the specific quirk for ASUS UM5606 models. It has
   zero impact on other hardware.

4. **Follows Established Patterns**: All five similar commits provided
   as reference (which were backported) fix similar hardware-specific
   audio/LED issues:
   - They add or fix quirks for specific laptop models
   - They address missing LED functionality
   - They are minimal, targeted fixes

5. **No Architectural Changes**: The fix uses existing infrastructure
   (`snd_hda_gen_add_micmute_led_cdev`) and doesn't introduce any new
   APIs or change existing behavior.

6. **Low Risk of Regression**: Since this only affects the
   `ALC294_FIXUP_BASS_SPEAKER_15` fixup (used exclusively by ASUS
   UM5606WA and UM5606KA models), there's virtually no risk of breaking
   other systems.

## Comparison to Similar Backported Commits

Looking at the reference commits marked "YES" for backporting:
- "ALSA: hda/realtek - Enable Speaker for ASUS UX563" - adds missing
  speaker functionality
- "ALSA: hda/realtek - add supported Mic Mute LED for Lenovo platform" -
  adds mic-mute LED support
- "ALSA: hda/realtek: Enable mute/micmute LEDs and speaker support for
  HP Laptops" - adds LED support

This commit follows the exact same pattern: fixing missing hardware
functionality (mic-mute LED) for specific laptop models.

## Note on Missing Cc: stable

While this commit doesn't include "Cc: <stable@vger.kernel.org>" in its
message (unlike the reference commits), this doesn't disqualify it from
backporting. The commit clearly meets the stable tree criteria as an
important bugfix with minimal risk.

The investigation confirms this is filling a genuine gap - ASUS UM5606
models currently have no LED support despite having the hardware, and
this one-line fix enables the mic-mute LED functionality users expect.

 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 02a424b7a9920..16f361b2877a7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6609,6 +6609,7 @@ static void alc294_fixup_bass_speaker_15(struct hda_codec *codec,
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		static const hda_nid_t conn[] = { 0x02, 0x03 };
 		snd_hda_override_conn_list(codec, 0x15, ARRAY_SIZE(conn), conn);
+		snd_hda_gen_add_micmute_led_cdev(codec, NULL);
 	}
 }
 
-- 
2.39.5

