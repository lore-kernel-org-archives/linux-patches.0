Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F961B4236;
	Mon,  4 Aug 2025 00:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267896; cv=none; b=twDQ5T0S//s3Cmm/HGM1Iy17cgVu89/rAQtWvHjajJ2buiI5GuvZs0/gFQs/5RbY91uFcsmQHlYfdwlsg8le6gKu4/5tTCV0PoIpVjPbrNHMN6N+YlbtJFB4v5CD3j/NYB9OdrLc+8XVaogRx/6Gii4EWQyhzKPjlOFvkyp1sGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267896; c=relaxed/simple;
	bh=hM2El6kLeGG84eWywD5wv95MNabg9xjPSmTF3hzVyzI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fxu0nODr0Tf5pQxD5w9Dwic6SwW8O8zIR148+u6JohQxaXwEIOrB6q25IInhYU5DwEVdk1xnRw08koqO+3vgEbVux0zapyTCOtQ37XPcekXO2lHSpvwkPUcNHC4tMYFSPgnn03WLetl38i8W6sBKvOqMUqyNO08wIlZeAzDmH9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bja8SHHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bja8SHHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F30C4CEF0;
	Mon,  4 Aug 2025 00:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267896;
	bh=hM2El6kLeGG84eWywD5wv95MNabg9xjPSmTF3hzVyzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bja8SHHHePFt0D41nMQgVgumX+l1Mo8CVHihHpspvovBoOWPPkFaE/Ar9FvwWi7mK
	 8nAfnHd27PEv4OtTZhXo//AG6uoLsE0BP0s2edONievWcpK4AB4b5iqUTQ8tPRx0OB
	 cJFKIGqJgE+y76GR6V+Kaj15tkjBXgXfJ5UiAs+2FhAjM5nyROELGxNSINlDFoShA0
	 awgDecH7GiU7KxEPb9yAyMklXa4XEoGpOR2WeO3IkeC4DbGqyW0cP6mQ0RjFMiUkzS
	 Ggpr12QzBXmfiNLc3w4GxOKfH75EbBPuhRprmQWNPsbwlMSPOgL7sWmNKo1oiW98wX
	 p9J9r7OV2yAbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	phasta@kernel.org,
	andriy.shevchenko@linux.intel.com
Subject: [PATCH AUTOSEL 6.1 39/51] ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4
Date: Sun,  3 Aug 2025 20:36:31 -0400
Message-Id: <20250804003643.3625204-39-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003643.3625204-1-sashal@kernel.org>
References: <20250804003643.3625204-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.147
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
index ae285c0a629c..f3df6fe2b7f1 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2252,7 +2252,7 @@ static int snd_intel8x0_mixer(struct intel8x0 *chip, int ac97_clock,
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

