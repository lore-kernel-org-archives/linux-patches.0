Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A520342A9B;
	Tue, 27 May 2025 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367670; cv=none; b=C4v7S+zT9RmClr5xcQhrkE9qBxceXjUsdiq1HshmpttTCDqUIjiDR43Dt0d7rFdOrJ8SrwE/eFsyf36Gyu8JezmeUycOv/ULAqeZ8fwsfXh7AHVYr7l+ebYILZyVmIOS4KY6u0IGCk0aFl6Cl2Iu7RfBMZVJhAPpSfAD2dpF78E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367670; c=relaxed/simple;
	bh=Th0cK1P5Ri6vdDd1iTDshy7AwnwhwFAcn0sFzrfwCO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9acsmaIOkzkw7On2aSCcYVAJdTozcMalBU+6nlOluHzfpcaSnKw22WcS6n8EogM1pbmSt+BiOnQMHC4GOv5J2ZvHSfsn82H2mQiwH48qlDvmg/3KrzQ2alTcw0bMIRS63CjAAjTGWT+YYnqNaWwBeil1iIJlPthgHQp5d0Wqo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvG7eGQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvG7eGQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14333C4CEE9;
	Tue, 27 May 2025 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367670;
	bh=Th0cK1P5Ri6vdDd1iTDshy7AwnwhwFAcn0sFzrfwCO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvG7eGQtVL5Vnr8+E399T2j6siCq4QtQbVAYYT+sVd5l2H6KxytNsKU5rhJth7Ojb
	 2gW4Rdodco+2D1Y3As78vGx9RmyxI33S3KpGNm3Irs4HtVfUOWofHSSlemlP1QHJQA
	 eY9z90M+B/G4ra8ckoDxu9WMM7HY6ZsXnVRdcDhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 462/783] drm/xe/debugfs: Add missing xe_pm_runtime_put in wedge_mode_set
Date: Tue, 27 May 2025 18:24:19 +0200
Message-ID: <20250527162531.942869938@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit b31e668d3111b100d16fd7db8db335328ce8c6d5 ]

xe_pm_runtime_put is missed in the failure path.

Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213230322.1180621-1-shuicheng.lin@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_debugfs.c b/drivers/gpu/drm/xe/xe_debugfs.c
index 6bfdd3a9913fd..92e6fa8fe3a17 100644
--- a/drivers/gpu/drm/xe/xe_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_debugfs.c
@@ -175,6 +175,7 @@ static ssize_t wedged_mode_set(struct file *f, const char __user *ubuf,
 		ret = xe_guc_ads_scheduler_policy_toggle_reset(&gt->uc.guc.ads);
 		if (ret) {
 			xe_gt_err(gt, "Failed to update GuC ADS scheduler policy. GuC may still cause engine reset even with wedged_mode=2\n");
+			xe_pm_runtime_put(xe);
 			return -EIO;
 		}
 	}
-- 
2.39.5



