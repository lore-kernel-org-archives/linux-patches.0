Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6CB1F1306;
	Sat, 25 Oct 2025 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408719; cv=none; b=q0NTL3eJqi4ogAZ+Xl8Lcnf77TLwhC7LcUHUz9csnzH2zrGTacL6gxDtm69qdat5d3ITLuXnjtiEfN8y+3KsWlRwWK/EI1AgxhUGomYZVDFaIu3De9vKlgeWTMqywseHJp8A0XysRjyrqxboouBcK85h7Sgrqt2K+ZJ1gyRZ2js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408719; c=relaxed/simple;
	bh=Oy0Os0VdWscYIqculK0CLVXbkwMI20mYn1RKq8HF3Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvnHFf2G5frfWX4A82itFHC4TPvN30c9Lh3otB9s+r/6c5PwQFroujqmCtwbqSw8a4LGWBiS2CLcuyWrmyYAz+7XNhKYj8zRSiY5cbC7/hRPqAQU51GANjOLKCgc7STtBWYVZ0YCISPlqKKDKtGkHTCDawLQhwPs1S8j8PUpuJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7VFEkau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7VFEkau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C0AC4CEFB;
	Sat, 25 Oct 2025 16:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408719;
	bh=Oy0Os0VdWscYIqculK0CLVXbkwMI20mYn1RKq8HF3Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7VFEkauRxPYIQvVskKa1HMpkcEyejmZo+xSHpQWrpqu8TGxKpjGW4gJFtv+FXmH7
	 xCRdm1vftL00zkePdnCuxtNPw9upppjgLWd3OWBOAO0+4Xvkk7ZD+qLwh8eoepDp9P
	 jtl+0pNokQTjl0NsVeJfRMdayM+Urxe5J7WYbsYtNLRktHm3UCVWadSFmxkDAhS7pR
	 e0dWtXCpFyhKk4IDdoKiw3Y9gT6/0/qbwdt0eJcK1p0fI7ECjP3ilJ7CUT4mBbOyxo
	 q+m1T+/Bl9j41LhKM77juFl/xImODHhEThBQwO0wrifqLBwAYwxbp0/EGaJfDFiBbf
	 POyK48qjXdWnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vered Yavniely <vered.yavniely@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-6.6] accel/habanalabs/gaudi2: fix BMON disable configuration
Date: Sat, 25 Oct 2025 11:54:43 -0400
Message-ID: <20251025160905.3857885-52-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Vered Yavniely <vered.yavniely@intel.com>

[ Upstream commit b4fd8e56c9a3b614370fde2d45aec1032eb67ddd ]

Change the BMON_CR register value back to its original state before
enabling, so that BMON does not continue to collect information
after being disabled.

Signed-off-by: Vered Yavniely <vered.yavniely@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `gaudi2_config_bmon()` writes the user-supplied enable bits into
  `mmBMON_CR` when activating the monitor
  (`drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c:2409`). With the
  pre-fix code, the disable path overwrote the control register with
  `0x0F000077`, a value that leaves collection logic active, so the
  hardware kept sampling even after we told userspace the monitor was
  disabled (`drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c` history
  via `git blame`, original value added in de88aa67af94). The patch
  restores the register to the hardware reset value `0x41`
  (`drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c:2429`), matching
  the state observed before enablement and preventing post-disable bus
  sampling.
- This bug is user-visible: disabling a BMON instance via the debug
  ioctl leaves residual capture running, corrupting later measurements
  and wasting bandwidth/trace resources. No alternative workaround
  exists in older kernels because the driver unconditionally writes the
  wrong value.
- The fix is tiny, self-contained, and hardware-specific; it touches
  only the Gaudi2 BMON disable path and aligns with how the Gaudi
  (non-2) driver already restores the control register to its idle
  value. There are no functional dependencies beyond the longstanding
  code added with the original Gaudi2 profiler support, so the change
  backports cleanly even to older trees that still house the file under
  `drivers/misc/habanalabs/gaudi2`. Risk of regression is minimal
  because the new constant matches the documented idle state and only
  executes on the disable path.

Given the clear bug fix, minimal scope, and relevance to existing users
of the Gaudi2 debug interface, this commit meets the stable tree
backport criteria.

 drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c b/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c
index 2423620ff358f..bc3c57bda5cda 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c
@@ -2426,7 +2426,7 @@ static int gaudi2_config_bmon(struct hl_device *hdev, struct hl_debug_params *pa
 		WREG32(base_reg + mmBMON_ADDRH_E3_OFFSET, 0);
 		WREG32(base_reg + mmBMON_REDUCTION_OFFSET, 0);
 		WREG32(base_reg + mmBMON_STM_TRC_OFFSET, 0x7 | (0xA << 8));
-		WREG32(base_reg + mmBMON_CR_OFFSET, 0x77 | 0xf << 24);
+		WREG32(base_reg + mmBMON_CR_OFFSET, 0x41);
 	}
 
 	return 0;
-- 
2.51.0

