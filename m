Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D6C222580;
	Tue, 24 Jun 2025 04:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738338; cv=none; b=D68Vy/uOyOp9YJn99OiHwVt+2NiaUewQdlZZSppCqWS24S6UylO8Kq/mAyDeY1p+wMvmSd6DmqdG7e8TLBgHZMGYh2Yz6L5lrZON526YGzGKVfuJoaddbirO513dz0F8zBPskGXka4M+MO876p3oIfju9FZX1FxB5KSrNCTUNjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738338; c=relaxed/simple;
	bh=Sa1RNcVCjeFw1niI6sFM6ShZPoeKSMttqK24sFhyvQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rPqF56D/n335MEDf2KCoo9Bq+CLebDNzlLwXbgpON88ahaxUkSLjF7bM6NU3RD0ffmdHQ6pl832mvuOoH2OGD2kB7rXiWPi35D9hfug1suZ20YXBzdeoIRXm+MAhPazvsv41OPwSdvN2q2Zp+73ccYxqO9/TtIUgoxjJKWJitck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2PjlzRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2PjlzRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21963C4CEF0;
	Tue, 24 Jun 2025 04:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738338;
	bh=Sa1RNcVCjeFw1niI6sFM6ShZPoeKSMttqK24sFhyvQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2PjlzRWRrOyqd0u7QQEIUG8YYx/TqRQS8AwmJM23itRvy2UsyRB3uq/BZtQuFUPx
	 OPyrlGISBqrRbDwtcESzhRz4gpfyXyLiXftObzGNSIZIEvqsr9JwePIDBeSQpnU8AU
	 ikEynUr1fjVaa7RyCEU+r7+tKhFB88T2SLaRPSXkhsWnii4J32MPLDVFXunQemJa0i
	 dUXqox4Xvw+lYpV9G5HB8kX38prrXv5+3Q2rah+bBZ0Mt08QznvL8SKFDLP3n9duy+
	 AQbQJv1QMqrRFYOR4mHk3TaxHSSPR/3vZz5KBfhJ5Ch7ilPD7/aN9esAbD/xUEaFcT
	 SV6uzKK4NBulw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz
Subject: [PATCH AUTOSEL 6.6 03/18] ALSA: sb: Don't allow changing the DMA mode during operations
Date: Tue, 24 Jun 2025 00:11:59 -0400
Message-Id: <20250624041214.84135-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041214.84135-1-sashal@kernel.org>
References: <20250624041214.84135-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.94
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ed29e073ba93f2d52832804cabdd831d5d357d33 ]

When a PCM stream is already running, one shouldn't change the DMA
mode via kcontrol, which may screw up the hardware.  Return -EBUSY
instead.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218185
Link: https://patch.msgid.link/20250610064322.26787-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Key Reasons for Backporting:

1. **Critical Bug Fix for Race Condition**: The commit fixes a race
   condition where changing DMA mode via kcontrol while PCM streams are
   running can corrupt hardware state. Looking at the code:
   - The `chip->mode` field tracks active playback/capture operations
     using `SB_MODE_PLAYBACK` and `SB_MODE_CAPTURE` flags
   - The DMA mode control (`force_mode16`) affects how DMA transfers are
     configured
   - Changing this while streams are active can cause hardware
     inconsistencies

2. **Clear User-Visible Bug**: The commit references Bugzilla #218185,
   indicating this is a real user-reported issue that affects system
   stability and audio functionality.

3. **Minimal and Contained Fix**: The change is extremely small and
   focused:
  ```c
  +       if (chip->mode & (SB_MODE_PLAYBACK | SB_MODE_CAPTURE))
  +               return -EBUSY;
  ```
  It simply adds a check to prevent mode changes during active
  operations, returning -EBUSY to userspace.

4. **No Architectural Changes**: This is a straightforward defensive
   check that doesn't alter any core functionality or introduce new
   features. It only prevents an invalid operation.

5. **Low Risk of Regression**: The fix:
   - Only affects the SB16 sound driver
   - Only changes behavior when someone tries to modify DMA mode during
     active streaming
   - Returns a standard error code (-EBUSY) that applications should
     already handle
   - Doesn't affect normal audio operations

6. **Follows Stable Kernel Rules**: This perfectly matches stable kernel
   criteria:
   - Fixes a real bug that affects users
   - Obviously correct with no subtleties
   - Small change (2 lines of actual code)
   - Already tested in mainline
   - No new features added

## Technical Analysis:

From examining the code flow:
- During `snd_sb16_playback_open()` and `snd_sb16_capture_open()`, the
  driver sets `chip->mode` flags
- These flags remain set until `snd_sb16_playback_close()` and
  `snd_sb16_capture_close()` clear them
- The `force_mode16` setting affects DMA channel selection throughout
  the driver
- Without this fix, userspace can change `force_mode16` while DMA
  operations are active, potentially causing:
  - DMA channel mismatches
  - Audio corruption
  - System instability

This is similar to the first example commit that was backported, which
also prevented operations during inappropriate states (DMA
synchronization during PAUSE state).

 sound/isa/sb/sb16_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index a9b87e159b2d1..5efbd0a41312b 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -703,6 +703,9 @@ static int snd_sb16_dma_control_put(struct snd_kcontrol *kcontrol, struct snd_ct
 	unsigned char nval, oval;
 	int change;
 	
+	if (chip->mode & (SB_MODE_PLAYBACK | SB_MODE_CAPTURE))
+		return -EBUSY;
+
 	nval = ucontrol->value.enumerated.item[0];
 	if (nval > 2)
 		return -EINVAL;
-- 
2.39.5

