Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91EA4E9C3D;
	Tue, 13 Oct 2026 11:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892591; cv=none; b=UqRcL4mr9FSgRiaGtha51mYzrQ3goKtC8bWOcKI7Q4umE/9PNXlb1Xk50SQpc7eemYyrtZbmfzsvKI8jMatJznA3SRAX2A7gyHKb1Z7q9+jBAHAaVIZhrMtu5SetC15LLVPB2KSwf7MS4tk1ZYSzOGHDHWsuzRBf86nRN4idQ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892591; c=relaxed/simple;
	bh=t8Gme8QPNDLSaL2RMPxtcipwqV03bK8/ZTri2lOnUf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYUZPtJDhpHpgLGAsYUFlrNxdZzf1AdFGLe+QG99szXEDjmEl4So6w9IOv8fIHleTfgAW2aXsmdrTtBHeMCxRV+lRg1iVVR6auvk0ngmDH9lDUS0K9ulOxtjF63DFql7KUcf4peO2tNQCBi6jIypIKLZ2VjxtvOr/vyL+wrLYaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uk50sApH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uk50sApH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDDA1F000FF;
	Tue, 13 Oct 2026 11:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892590;
	bh=s2ecw0G228AjQzL7pVZesHMaKTnGeBNx6G30yU+Sd4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uk50sApH50JKnr3IDFyU60vFnaOUxKO/Alv92iLqvtVANi0NX6jgwWjj2AnBPl/ZB
	 2dmPTHimfN5gwTavnWAAUUeoAzu7gC5kFi7PoEaeY/j0BOu4hiY0g/xFQffEuSMlL0
	 IivzfpoxwK/1Q0D01F3HvXCNxB5TpH/S7TEsDbdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 217/281] drm/xe/mmio: Fix xe_mmio_wait32() to honor delay/sleep maximums
Date: Tue, 13 Oct 2026 13:38:53 +0200
Message-ID: <20261013112900.427495489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Previn <alan.previn.teres.alexis@intel.com>

[ Upstream commit e7ed652b1312ffcb9ea2153946615856b5097c78 ]

Check for overflow in udelay use in __xe_mmio_wait32 and
avoid growing delays becoming intollerably large by capping the
in-loop wait time.

v7: - Change assisted-by to "LLM" (Rodrigo).
    - Move the max-wait macro to outside the function (Rodrigo).
v6: - Fix commit message to remove items dropped in v5. Fix the
      use of MAX_UDELAY_MS for microsecond unit. (Shasiko review).
v5: - Simplify: don't introduce additional redesign and
      use min_t with a backoff to cap wait. (Rodrigo).
v4: - Simplify using poll_timeout_us and poll_timeout_us_atomic and
      update all callers to never use a param for atomic (Jani)
v3: - Use div64_s64 kernel API for 32-bit vs 64-bit division.
v2: - Fixed checkpatch failure.
    - Added helper for 64-bit DIV_ROUND_UP on 32-bit CPU (Shasiko
      review). Fixed bug max range in usleep_range(Shasiko review)

Fixes: 5c09bd6ccd41 ("drm/xe/mmio: Move xe_mmio_wait32() to xe_mmio.c")
Signed-off-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Assisted-by: LLM
Link: https://patch.msgid.link/20260929192037.2233429-2-alan.previn.teres.alexis@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 70dab9ee7d620e6018a64798aed065d14e9baed1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_mmio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_mmio.c b/drivers/gpu/drm/xe/xe_mmio.c
index 78adb303b6630..6907c1127d326 100644
--- a/drivers/gpu/drm/xe/xe_mmio.c
+++ b/drivers/gpu/drm/xe/xe_mmio.c
@@ -288,6 +288,7 @@ u64 xe_mmio_read64_2x32(struct xe_mmio *mmio, struct xe_reg reg)
 	return (u64)udw << 32 | ldw;
 }
 
+#define __XE_MMIO_WAIT_MAX_BACKOFF_100MS (100 * USEC_PER_MSEC)
 static int __xe_mmio_wait32(struct xe_mmio *mmio, struct xe_reg reg, u32 mask, u32 val,
 			    u32 timeout_us, u32 *out_val, bool atomic, bool expect_match)
 {
@@ -318,10 +319,10 @@ static int __xe_mmio_wait32(struct xe_mmio *mmio, struct xe_reg reg, u32 mask, u
 			wait = ktime_us_delta(end, cur);
 
 		if (atomic)
-			udelay(wait);
+			udelay(min_t(s64, wait, (MAX_UDELAY_MS * 1000)));
 		else
 			usleep_range(wait, wait << 1);
-		wait <<= 1;
+		wait = min_t(s64, wait << 1, __XE_MMIO_WAIT_MAX_BACKOFF_100MS);
 	}
 
 	if (ret != 0) {
-- 
2.53.0



