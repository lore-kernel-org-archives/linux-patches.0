Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC65425B2E1;
	Mon, 30 Jun 2025 20:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317130; cv=none; b=MQB9Stjg3KR1TGjwIapzuLj0OLGUyUMxlamMDlp1KkJv/X/N9k+Wec9t55M0pyVXidXA4a8rXimGAnr9692zoL9XBcxoYJ9lLy6JVsAzcuIDyBRkk2i8YTx9H1NKhbex2x149hehV6Fmc1sKoiMugOSqUiJaNy7vbrz/a1cpyE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317130; c=relaxed/simple;
	bh=yqAACpINiW/Qdhp2nT2YiGZJFqGIay8wIKXjktB0UdY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LLrevLYEB45BCzB61Oqv1YvmGbLSACCrrlPOVaISE7inKFIzWU18orXZgmiFXgHdj2CLKL+9HKxJ9RwjZ2ZtMmb5WJu4x0l/IkDunm+DcXKCEDFfRxR/XppR4b/paHM7v9KoH8XSsvtoEA084mHspYhFuhHXWwORAzEKMo5OnFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tQyYgt0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tQyYgt0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A601C4CEEB;
	Mon, 30 Jun 2025 20:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317129;
	bh=yqAACpINiW/Qdhp2nT2YiGZJFqGIay8wIKXjktB0UdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQyYgt0DWViUJjkAynPVY8uCRb2XMwPUUz+rg4dpg/wPaFj4AalPahGhVGXOX0Fl6
	 sV6eNWNROPcpjTWJBoQV6fg9y6tIAFnUR5C7YRZ4eGVp+S9+WsCviaQy9h0j9fanz+
	 G0FyieDZR3N1Sw3/h9RHMRp3k16hn1iwR7TTpEUWTt+r0iuHS73Yw20SNE4xoo+gaF
	 7XdEzvWy0YHQ54ht7jlnvpYD5RBLCR9ragThU6Jm2kM9G7gWPlRQBJ6twF1cYn7+Ln
	 182q+fEKyYyTE8ADZ0tIo37BKm3ExGi4sHgkvyxt99tE89TDVCF4O6cERXuc2mUCA3
	 6iCwT+w8uCRJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	simont@opensource.cirrus.com,
	josh@joshuagrisham.com
Subject: [PATCH AUTOSEL 6.15 08/23] ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook 6 G1a
Date: Mon, 30 Jun 2025 16:44:13 -0400
Message-Id: <20250630204429.1357695-8-sashal@kernel.org>
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

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit 9a07ca9a4015f8f71e2b594ee76ac55483babd89 ]

HP EliteBook 6 G1a laptops use ALC236 codec and need the fixup
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF to make the mic/micmute LEDs
work.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Link: https://patch.msgid.link/20250623063023.374920-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

YES

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Code Changes Analysis

The commit adds two simple PCI quirk entries to the existing quirk
table:
```c
+       SND_PCI_QUIRK(0x103c, 0x8dfb, "HP EliteBook 6 G1a 14",
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+       SND_PCI_QUIRK(0x103c, 0x8dfd, "HP EliteBook 6 G1a 16",
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
```

## Reasons for Backporting

1. **Bug Fix**: This fixes broken functionality (mute/micmute LEDs) on
   specific HP EliteBook 6 G1a models, which is a real user-facing issue
   that affects hardware functionality.

2. **Minimal Risk**: The change is extremely confined - it only adds PCI
   ID mappings (0x8dfb and 0x8dfd) that will only affect these specific
   HP laptop models. There's no risk of regression for other hardware.

3. **Small and Contained**: The patch adds just 2 lines to an existing
   quirk table. It doesn't modify any logic, algorithms, or introduce
   new features.

4. **Follows Established Pattern**: Examining the repository history
   shows numerous similar commits with stable tags:
   - commit 96409eeab8cd: "fix mute/micmute LEDs for a HP EliteBook 645
     G10" (Cc: stable)
   - commit 7ba81e4c3aa0: "fix mute/micmute LEDs don't work for
     EliteBook X G1i" (Cc: stable)
   - commit 3cd59d8ef8df: "fix mute/micmute LEDs don't work for
     EliteBook 645/665 G11" (Cc: stable)

5. **Uses Existing Fixup**: The commit uses
   `ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF`, which is an established
   fixup function already present in the kernel. This fixup combines two
   existing functions:
   - `alc236_fixup_hp_mute_led_coefbit()` - for mute LED control
   - `alc236_fixup_hp_micmute_led_vref()` - for micmute LED control

6. **Hardware Enablement**: This enables proper functionality for users
   who have already purchased these HP EliteBook models, improving their
   Linux experience on stable kernels.

## Similar Commits Analysis

All 5 provided similar commits were marked as suitable for backporting
(YES), and they follow the exact same pattern:
- Adding PCI quirk entries for HP laptops
- Fixing LED functionality issues
- Using established ALC codec fixups
- Minimal, hardware-specific changes

This commit is a textbook example of a stable-appropriate fix: it
restores expected hardware functionality with minimal code changes and
zero risk to other systems.

 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 16f361b2877a7..2ffdbe5e6a25d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10885,7 +10885,9 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8def, "HP EliteBook 660 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8df0, "HP EliteBook 630 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8df1, "HP EliteBook 630 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8dfb, "HP EliteBook 6 G1a 14", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8dfc, "HP EliteBook 645 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8dfd, "HP EliteBook 6 G1a 16", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8dfe, "HP EliteBook 665 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e11, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e12, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.39.5

