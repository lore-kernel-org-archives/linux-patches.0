Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5665C2BD11;
	Mon,  4 Aug 2025 00:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267919; cv=none; b=rxt75DarzvUkZBcRDBqQ0mBriQ9toVXFOf8tJi8gHizJR6jY/ANET3DBeyHCfhihIVNdNVm0Aa8PoDVl+HNF/4UtfDZBGYMZxMDbNiHIddkG3utczUac0Hnnxl2IMsOuThrSorm6RtNzthpuISGUxg58fHHI8PiZpfrybF/OvCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267919; c=relaxed/simple;
	bh=iFgtk2Xrj1lWDVh0JzkNepjuZPl/B7ldfv5zaDiUKx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P4gKe3MBO6LeOOrMHevZIFBjk4KQkQ7SdHrpgJpPXPZkc17NSWZg9u0IH4Z4Sa138GpVQs4I2kjUBcDXp5ItEjjhbrCVrbhKoP0lCkp6hbyg70v5vCmZZfW5zcoVKl4jv0KgMtTLSFONF7P2Xile82l4c5f4o1cHkQ8g35GhvVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4PfsKE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4PfsKE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88957C4CEEB;
	Mon,  4 Aug 2025 00:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267916;
	bh=iFgtk2Xrj1lWDVh0JzkNepjuZPl/B7ldfv5zaDiUKx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4PfsKE1FSnZHG332U4uqp9tCpZIlIymjPDsCZ/5K3x0Q6kv282ywvHHcL/Bdo7aM
	 nteLm7xLosThs+OR/QPlBIM3QB0Rc9rubFjkY3G5ilMUNg/NJjcg6cWBiyP9CEAjJm
	 x69ne/NlOEpf8qF17kgGOTenx7dwW3Mjk9PLgveAlPqxW7OlVfSRSHgggzAwuekzxN
	 g8g0QE3DVVq8zaShOgyUsTyEVHNfRoFT1udld4LGJ4iWdniRJZxLY+hFX/79TJRPw3
	 2VPeptsjRGrmpXLYgJpgw2c995kCgTaM5Eg1zy+D6KU7UqYk3flj4OlWQpy059qQd9
	 8DlRVYg6KI46g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lucy Thrun <lucy.thrun@digital-rabbithole.de>,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	rf@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.1 47/51] ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control
Date: Sun,  3 Aug 2025 20:36:39 -0400
Message-Id: <20250804003643.3625204-47-sashal@kernel.org>
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

From: Lucy Thrun <lucy.thrun@digital-rabbithole.de>

[ Upstream commit a409c60111e6bb98fcabab2aeaa069daa9434ca0 ]

The 'sprintf' call in 'add_tuning_control' may exceed the 44-byte
buffer if either string argument is too long. This triggers a compiler
warning.
Replaced 'sprintf' with 'snprintf' to limit string lengths to prevent
overflow.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506100642.95jpuMY1-lkp@intel.com/
Signed-off-by: Lucy Thrun <lucy.thrun@digital-rabbithole.de>
Link: https://patch.msgid.link/20250610175012.918-3-lucy.thrun@digital-rabbithole.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real security vulnerability**: The commit fixes a buffer
   overflow vulnerability in the `add_tuning_control` function. The
   sprintf call could overflow the 44-byte `namestr` buffer (defined as
   `char namestr[SNDRV_CTL_ELEM_ID_NAME_MAXLEN]` where
   `SNDRV_CTL_ELEM_ID_NAME_MAXLEN` is 44).

2. **Long-standing bug**: The vulnerable code was introduced in 2012
   (commit 44f0c9782cc6a), meaning this buffer overflow has existed in
   the kernel for over a decade, affecting many stable kernel versions.

3. **Simple and contained fix**: The fix is minimal - it simply replaces
   `sprintf` with `snprintf` on a single line:
  ```c
   - sprintf(namestr, "%s %s Volume", name, dirstr[dir]);
   + snprintf(namestr, sizeof(namestr), "%s %s Volume", name,
dirstr[dir]);
   ```

4. **Low risk of regression**: The change is straightforward and only
   adds bounds checking. It doesn't change any logic or behavior when
   strings fit within the buffer.

5. **Detected by automated testing**: The issue was caught by the kernel
   test robot, indicating it's a real compiler warning that should be
   addressed.

6. **Potential for exploitation**: While the tuning control names like
   "Wedge Angle", "SVM Level", and "EQ Band0-9" are relatively short,
   combined with "Playback" or "Capture" and " Volume", they could
   theoretically overflow the 44-byte buffer. For example: "EQ Band9"
   (8) + " " (1) + "Playback" (8) + " Volume" (7) = 24 bytes, which is
   safe, but the vulnerability exists if longer names were added in the
   future.

7. **Affects user-facing functionality**: This is in the ALSA HD Audio
   driver for Creative CA0132 sound cards, which are used by end users,
   making it important to fix in stable kernels.

The fix follows stable kernel rules perfectly: it's a minimal change
that fixes an important bug without introducing new features or
architectural changes.

 sound/pci/hda/patch_ca0132.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 748a3c40966e..c19164089ae4 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4399,7 +4399,7 @@ static int add_tuning_control(struct hda_codec *codec,
 	}
 	knew.private_value =
 		HDA_COMPOSE_AMP_VAL(nid, 1, 0, type);
-	sprintf(namestr, "%s %s Volume", name, dirstr[dir]);
+	snprintf(namestr, sizeof(namestr), "%s %s Volume", name, dirstr[dir]);
 	return snd_hda_ctl_add(codec, nid, snd_ctl_new1(&knew, codec));
 }
 
-- 
2.39.5

