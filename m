Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64372221DB3;
	Tue, 24 Jun 2025 04:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738292; cv=none; b=G7YK5eYsLK3boUK7qZBXDYVbQLRxOLThyR91v/5IY7paWkr45JrqMHHdMIbaC9HC/dNo8baB9NXUcO3fKeRf2IbU+S56hQrp2Wy6j1WiifGpUwBmB2+S6H8fKsXsbix+5zkOPdqYhYC0dGZIokLQcF5fx47HNhXBvP333jNV5ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738292; c=relaxed/simple;
	bh=+Kr265pi3w9ZUSnUJR/X3Zb4fz71x8OqV06OA7g1Ut4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtFZzSba8L1J+hQkGldzPSz5fqETkOmDF6fSuUfdjLZ4V2jHzxgBJ4eO4YKynI5Uyn59okdmEGZFRVFjqa3249GwoOeDC2sip4hrR2DYieeiBrR4n5EpZV6+h0Sdt/irag/JxlePk6Ldl2N7PiDHKa+nUdKaFV3eQ/AK9ED1XwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avTbXxay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avTbXxay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F74C4CEF0;
	Tue, 24 Jun 2025 04:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738292;
	bh=+Kr265pi3w9ZUSnUJR/X3Zb4fz71x8OqV06OA7g1Ut4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avTbXxayClGubt5FVMFjeBiCi3qOUqN5VhIxV8KzQ7bXuWQP02/h8P5PE96cB287y
	 LLDpJ7Nm06hR5FYikIEYy/VTSrc89tywSTGqeLdpz7/0CnYUVkH4tFLiyBTrki4TX/
	 FNFfehoX33T7WMo/dgdc+5KgGAhTC+qoe8bQswiY5pXeMuYGr7jVyJoIMsvEWJP9lt
	 IKDJvWKigm+Rn/O5creYmmMSDBNjLWQ4GYJgZCNI+SHXRGl25bY1J2I/fceRsLPRmL
	 wtdGbh7cLhJYUumhsVuGsGcodaCYloSMwX9kjfjoYMQSG87keyiKqPFExRI6r99zwJ
	 WKUrKQWzAu0jw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gabriel Santese <santesegabriel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	tiwai@suse.de,
	venkataprasad.potturu@amd.com,
	talhah.peerbhai@gmail.com
Subject: [PATCH AUTOSEL 6.15 08/20] ASoC: amd: yc: Add quirk for MSI Bravo 17 D7VF internal mic
Date: Tue, 24 Jun 2025 00:11:07 -0400
Message-Id: <20250624041120.83191-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041120.83191-1-sashal@kernel.org>
References: <20250624041120.83191-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gabriel Santese <santesegabriel@gmail.com>

[ Upstream commit ba06528ad5a31923efc24324706116ccd17e12d8 ]

MSI Bravo 17 (D7VF), like other laptops from the family,
has broken ACPI tables and needs a quirk for internal mic
to work properly.

Signed-off-by: Gabriel Santese <santesegabriel@gmail.com>
Link: https://patch.msgid.link/20250530005444.23398-1-santesegabriel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Commit

### 1. **Nature of the Fix**
This commit adds a DMI quirk entry for the MSI Bravo 17 D7VF laptop to
enable its internal microphone. The code change is minimal and follows
an established pattern:

```c
+       {
+               .driver_data = &acp6x_card,
+               .matches = {
+                       DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star
International Co., Ltd."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VF"),
+               }
+       },
```

### 2. **Bug Being Fixed**
The commit message explicitly states "has broken ACPI tables and needs a
quirk for internal mic to work properly." This is fixing a real hardware
functionality issue where the internal microphone doesn't work without
this quirk.

### 3. **User Impact**
Without this fix, users of the MSI Bravo 17 D7VF laptop cannot use their
internal microphone, which is a significant functionality loss for:
- Video conferencing
- Voice recording
- Voice commands
- Any application requiring microphone input

### 4. **Code Analysis**
Looking at the probe function in `acp6x_probe()`:
- The driver first tries to detect DMIC support via ACPI methods
  (`AcpDmicConnected` and `_WOV`)
- If ACPI detection fails or returns incorrect values (as mentioned in
  commit - "broken ACPI tables"), it falls back to DMI quirk table
  matching
- Without the quirk entry, `dmi_first_match(yc_acp_quirk_table)` returns
  NULL, and the card won't be set up properly, resulting in no
  microphone support

### 5. **Consistency with Similar Commits**
All similar commits provided as reference were marked with "Backport
Status: YES":
- "ASoC: amd: yc: Add a quirk for MSI Bravo 17 (D7VEK)" - YES
- "ASoC: amd: yc: Add DMI quirk for MSI Bravo 15 C7VF" - YES (includes
  Cc: stable)
- "ASoC: amd: yc: fix internal mic on Redmi G 2022" - YES
- "ASoC: amd: yc: Add DMI quirk for Lenovo Ideapad Pro 5 16ARP8" - YES
  (includes Cc: stable)
- "ASoC: amd: yc: Fix non-functional mic on ASUS E1404FA" - YES

### 6. **Risk Assessment**
- **Minimal risk**: The change only adds a new DMI match entry
- **No architectural changes**: Pure data addition to existing quirk
  table
- **No behavioral changes**: Only affects the specific laptop model
- **Well-tested pattern**: Follows exact same pattern as dozens of other
  entries in the table

### 7. **Stable Tree Criteria**
This commit meets all stable tree criteria:
- ✓ Fixes a real bug affecting users (non-functional microphone)
- ✓ Small and contained change (7 lines addition)
- ✓ No side effects beyond fixing the specific issue
- ✓ No new features or architectural changes
- ✓ Hardware enablement fix for specific model

### 8. **Pattern Recognition**
This is part of the MSI Bravo laptop family fixes:
- Bravo 15 B7ED already has quirk
- Bravo 15 C7VF already has quirk (with Cc: stable)
- Bravo 17 D7VEK already has quirk
- This adds Bravo 17 D7VF to complete the family

The commit follows the exact same pattern and reasoning as previous MSI
Bravo laptop quirks that were successfully backported to stable trees,
indicating this should also be backported for consistency and user
benefit.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index e632f16c91025..9ce4339680e35 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -437,6 +437,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VEK"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VF"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5

