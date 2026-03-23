Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE523BADAC;
	Mon, 23 Mar 2026 14:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274464; cv=none; b=CfPumj7UzgMuhvKNA1tjlBzUmDwlZLBDI7bajdL+rOXSKFf/w+FHUhIyPW+nPanT26cWrE1axjngKTDGFa0bwvWdcyMFcEsqBkbJdo/V/BctceMLpygpkW4+tcBJhy4K/nCb1p61gD5gHgjATBthwZgrFlv971dzEjXSy0dK5oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274464; c=relaxed/simple;
	bh=Y7cNYwuCgIXiRJVc4twunvwbJP6jmBgrJGE20m5nejA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQKIA5rnnXG+ubiM3wipkRQjFIKJH4KBRncZngtHBte0Y049On7jy5FfFb4I7NWCeClZn2AbAvHbcOTuYdTvR+HQAYZbXWp5K0trajTwiJssucvPfzFssvvqOjxjrz/kbuvuZxRuAK8o05aPgqfaMnBLB0pbnoKNmkHhWwtl1nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQ7rFxQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQ7rFxQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218ADC2BC9E;
	Mon, 23 Mar 2026 14:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274464;
	bh=Y7cNYwuCgIXiRJVc4twunvwbJP6jmBgrJGE20m5nejA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQ7rFxQ6xi2vfeqxD6OegYpw2cHz5OkpQYFqKItLUKnhwDDzjiQ/MAS7z95JHE6fz
	 zOaqNB2KAaccBluW3ej/Yg265PUVeV6F5k1j9N6u4zBoVhK8NpG62EjEYBpqybXqpl
	 5Ytx1cD24rJmKORxPOnBHFk6J527mqAMl7DryEmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 219/220] drm/xe/guc: Fail immediately on GuC load error
Date: Mon, 23 Mar 2026 14:46:36 +0100
Message-ID: <20260323134511.423617505@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit 9b72283ec9b8685acdb3467de8fbc3352fdb70bb ]

By using the same variable for both the return of poll_timeout_us and
the return of the polled function guc_wait_ucode, the return value of
the latter is overwritten and lost after exiting the polling loop. Since
guc_wait_ucode returns -1 on GuC load failure, we lose that information
and always continue as if the GuC had been loaded correctly.

This is fixed by simply using 2 separate variables.

Fixes: a4916b4da448 ("drm/xe/guc: Refactor GuC load to use poll_timeout_us()")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20260303001732.2540493-2-daniele.ceraolospurio@intel.com
(cherry picked from commit c85ec5c5753a46b5c2aea1292536487be9470ffe)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index edb939f262685..2eaa009ba2d8d 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -1121,14 +1121,14 @@ static int guc_wait_ucode(struct xe_guc *guc)
 	struct xe_guc_pc *guc_pc = &gt->uc.guc.pc;
 	u32 before_freq, act_freq, cur_freq;
 	u32 status = 0, tries = 0;
+	int load_result, ret;
 	ktime_t before;
 	u64 delta_ms;
-	int ret;
 
 	before_freq = xe_guc_pc_get_act_freq(guc_pc);
 	before = ktime_get();
 
-	ret = poll_timeout_us(ret = guc_load_done(gt, &status, &tries), ret,
+	ret = poll_timeout_us(load_result = guc_load_done(gt, &status, &tries), load_result,
 			      10 * USEC_PER_MSEC,
 			      GUC_LOAD_TIMEOUT_SEC * USEC_PER_SEC, false);
 
@@ -1136,7 +1136,7 @@ static int guc_wait_ucode(struct xe_guc *guc)
 	act_freq = xe_guc_pc_get_act_freq(guc_pc);
 	cur_freq = xe_guc_pc_get_cur_freq_fw(guc_pc);
 
-	if (ret) {
+	if (ret || load_result <= 0) {
 		xe_gt_err(gt, "load failed: status = 0x%08X, time = %lldms, freq = %dMHz (req %dMHz)\n",
 			  status, delta_ms, xe_guc_pc_get_act_freq(guc_pc),
 			  xe_guc_pc_get_cur_freq_fw(guc_pc));
-- 
2.51.0



