Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E911B1519A0;
	Mon,  4 Aug 2025 00:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267215; cv=none; b=dNkveUHNhtea8i/rZVWFxvToAlxc+WaY1tlSGEoijpMAON+aaPQRLWwoGcz6Lbbxmq56I/B0m9kJcGsFO4MAhiKmN71viXaaiiry4jd0MGcVfXDX5JJZnHmVGaq/Etq5QdknpR3KQ/Xhav6y6SAhaLU8X8NuYqiqsnhXCB5qDn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267215; c=relaxed/simple;
	bh=HqDtZX8ldgAzhWYl5/uuFqQ+2M9ghObmrdWvsPiZOe4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n61O5W96PPC+JUcUhyM9ZR8lkpTqz9gnT/1vCNkPe/Pp56LFLm+2NNd+6OO1WcydR4G4JrXQCQDQhzThDkTo+ZFIBgayfO5ghdxFb/qBuof85iExnJDpKTsuy2jNlYvvrYxkVJzJ+JEcOk3jH3MU4xybl6xeyfJAfBJ6dBmwEeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FS/G1ZAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FS/G1ZAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69383C4CEF0;
	Mon,  4 Aug 2025 00:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267214;
	bh=HqDtZX8ldgAzhWYl5/uuFqQ+2M9ghObmrdWvsPiZOe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FS/G1ZAFciFYmwBlE9andxXXiOcPM7bMuuJ152JOd6rcw61Ixqfl9J6bFsQVA00BJ
	 fiWQgMXirNp0wK5UB0HrdU8D323+xRrS+HEAw9wf+OprSOcHtzss0Xgk09md+XcAkV
	 XQdjeedfmhqtrXreMitWSzjYFi4oRhwyMWYBzsy59NOJyw0lvH238/JVmxLfdNNXiW
	 DZikGVM4XEq1ch5RRhMD9fITmRgW4yBQFMcaL9w/NCfoCjWQlX8/r/elqUA4jzOeDj
	 A2FEe7hov4ZQAaiIRCRwFEQLntE0MnI7D3ICAIYVOubnSrV/XL/6pxDMeZaRvoFO0S
	 200eMBlrJ8wdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	andriy.shevchenko@linux.intel.com,
	perex@perex.cz,
	phasta@kernel.org
Subject: [PATCH AUTOSEL 6.16 66/85] ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4
Date: Sun,  3 Aug 2025 20:23:15 -0400
Message-Id: <20250804002335.3613254-66-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 87aafc8580acf87fcaf1a7e30ed858d8c8d37d81 ]

code mistakenly used a hardcoded index (codec[1]) instead of
iterating, over the codec array using the loop variable i.
Use codec[i] instead of codec[1] to match the loop iteration.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250621185233.4081094-1-alok.a.tiwari@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's the
extensive explanation:

## Bug Analysis

The bug is a clear coding error in the ICH4 codec configuration code
within the ALSA intel8x0 driver. Looking at the code change:

```c
- tmp |= chip->ac97_sdin[pcm->r[0].codec[1]->num] << ICH_DI2L_SHIFT;
+ tmp |= chip->ac97_sdin[pcm->r[0].codec[i]->num] << ICH_DI2L_SHIFT;
```

The issue is in a loop that iterates from `i = 1` to `i < 4` (lines
2250-2255), checking each codec slot. However, the original code
hardcoded `codec[1]` instead of using the loop variable `codec[i]`. This
means:

1. **The loop was pointless** - it would always use codec[1] regardless
   of which iteration found a valid codec
2. **Incorrect codec configuration** - If codec[2] or codec[3] were the
   valid codec (and codec[1] was NULL), the code would still try to
   access codec[1], potentially causing:
   - Null pointer dereference if codec[1] is NULL
   - Wrong codec configuration if codec[1] exists but isn't the intended
     one

## Impact Assessment

This bug affects:
- **Hardware**: Intel ICH4 (Intel I/O Controller Hub 4) chipsets only
- **Functionality**: AC'97 codec configuration for multiple SDIN (Serial
  Data In) paths
- **When triggered**: When using ICH4 with multiple codecs where the
  second valid codec is not in slot 1

## Backport Suitability

This commit meets all criteria for stable backporting:

1. **Fixes a real bug**: Clear array indexing error that can cause
   incorrect hardware configuration or crashes
2. **Small and contained**: Single line change, exactly 1 insertion and
   1 deletion
3. **No side effects**: The fix simply corrects the loop to work as
   originally intended
4. **No architectural changes**: Pure bug fix with no API/ABI changes
5. **Critical subsystem**: ALSA sound drivers are important for user
   experience
6. **Long-standing bug**: The code has been incorrect since the initial
   git import (2005), making it important to fix in all maintained
   kernels
7. **Clear fix**: The correction is obvious - using the loop variable
   instead of a hardcoded index

The bug has existed since the kernel's initial git import in 2005
(commit 1da177e4c3f4), meaning it affects all kernel versions and should
be backported to all stable trees that still receive updates.

 sound/pci/intel8x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 51e7f1f1a48e..b521cec20333 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2249,7 +2249,7 @@ static int snd_intel8x0_mixer(struct intel8x0 *chip, int ac97_clock,
 			tmp |= chip->ac97_sdin[0] << ICH_DI1L_SHIFT;
 			for (i = 1; i < 4; i++) {
 				if (pcm->r[0].codec[i]) {
-					tmp |= chip->ac97_sdin[pcm->r[0].codec[1]->num] << ICH_DI2L_SHIFT;
+					tmp |= chip->ac97_sdin[pcm->r[0].codec[i]->num] << ICH_DI2L_SHIFT;
 					break;
 				}
 			}
-- 
2.39.5

