Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC52B153800;
	Fri, 15 Nov 2024 06:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653350; cv=none; b=VdjrfCJgW/zetWfyZ0mU273Fh0pM9tLsRpML/bcyHFlV+1HB+jTn4FDg8US+Ye/Ev1a/TFVWvgumKYZIiZoOWPeJ4+DutyZz3R5Z2FBdswOcke6wYzfOxZRRduL6lW5laq2BYcw3p0LVnt6HnPAxtONA/j9SxGIwDsH6KG+ZcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653350; c=relaxed/simple;
	bh=tSxojuS+hq5s9tmmC6VF8ydSII+bS8l0tnAjzSdCMYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PArFwZQHfO3t4+5ZTXtYC8qDW4nKBaogJvrM1kAehrsAqiUjAYS1ZPN8Lgul2+OtXh3Iv4rYRQrCQku4d2dih+e0FbsgIP8rQn5po1Ed4Pq91n7kD0NXwlP6v9QnGDoEmyrgXZVmR8oUzEgGqFC6WbqbuaH1ndMDuj16IRvz1ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZncHDBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZncHDBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B35CC4CECF;
	Fri, 15 Nov 2024 06:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653349;
	bh=tSxojuS+hq5s9tmmC6VF8ydSII+bS8l0tnAjzSdCMYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZncHDBNehOM9LxK9TVaaHfz+fUAmyncEtoOIWh0GV2KD0HbO5Yif7lYOGCDnd6Hq
	 X6XgbAJa1iJHaro49Wg/Y6AdhqKjoTofkPF2gTViebY/oghwfJXEtb8c937OcYF5LD
	 btITJ9MFNp+yPBXc2qURBCG5RBOADyjM/7SNssM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zuo <alex.zuo@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 59/63] drm/xe: Handle unreliable MMIO reads during forcewake
Date: Fri, 15 Nov 2024 07:38:22 +0100
Message-ID: <20241115063728.037049902@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 69418db678567bdf9a4992c83d448da462ffa78c ]

In some cases, when the driver attempts to read an MMIO register,
the hardware may return 0xFFFFFFFF. The current force wake path
code treats this as a valid response, as it only checks the BIT.
However, 0xFFFFFFFF should be considered an invalid value, indicating
a potential issue. To address this, we should add a log entry to
highlight this condition and return failure.
The force wake failure log level is changed from notice to err
to match the failure return value.

v2 (Matt Brost):
  - set ret value (-EIO) to kick the error to upper layers
v3 (Rodrigo):
  - add commit message for the log level promotion from notice to err
v4:
  - update reviewed info

Suggested-by: Alex Zuo <alex.zuo@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Acked-by: Badal Nilawar <badal.nilawar@intel.com>
Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241017221547.1564029-1-shuicheng.lin@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit a9fbeabe7226a3bf90f82d0e28a02c18e3c67447)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_force_wake.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_force_wake.c b/drivers/gpu/drm/xe/xe_force_wake.c
index b263fff152737..7d9fc489dcb81 100644
--- a/drivers/gpu/drm/xe/xe_force_wake.c
+++ b/drivers/gpu/drm/xe/xe_force_wake.c
@@ -115,9 +115,15 @@ static int __domain_wait(struct xe_gt *gt, struct xe_force_wake_domain *domain,
 			     XE_FORCE_WAKE_ACK_TIMEOUT_MS * USEC_PER_MSEC,
 			     &value, true);
 	if (ret)
-		xe_gt_notice(gt, "Force wake domain %d failed to ack %s (%pe) reg[%#x] = %#x\n",
-			     domain->id, str_wake_sleep(wake), ERR_PTR(ret),
-			     domain->reg_ack.addr, value);
+		xe_gt_err(gt, "Force wake domain %d failed to ack %s (%pe) reg[%#x] = %#x\n",
+			  domain->id, str_wake_sleep(wake), ERR_PTR(ret),
+			  domain->reg_ack.addr, value);
+	if (value == ~0) {
+		xe_gt_err(gt,
+			  "Force wake domain %d: %s. MMIO unreliable (forcewake register returns 0xFFFFFFFF)!\n",
+			  domain->id, str_wake_sleep(wake));
+		ret = -EIO;
+	}
 
 	return ret;
 }
-- 
2.43.0



