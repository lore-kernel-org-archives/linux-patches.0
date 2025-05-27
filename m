Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9BC2798E6;
	Tue, 27 May 2025 17:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365440; cv=none; b=dI48bQXAscU/k7M053kkrmaYcD4PJVPlo6wyeHKPBZwyAEdnnZtDFJFiXTo+XmeJQRzVbAOgmI8lO9LaEbJCzTE2WKQBfEXpM1yTWYt5WKAzjxAF0I6V+9Qe1so2GudEy5Fpn7CzDy3UiOaJuIjN9LaR3x/7738iMejwvxfKm80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365440; c=relaxed/simple;
	bh=y6W6bFA4DhBTrM3cRqpXpsvp3lm62kM6JobmRZZy0vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDDHsvosI1SB3rS6DOTD6DzeRnflPb1UI4ykuJntkQb0Q2UnQ62geVw2/VSfcAfDigLczPl+Oy4iTE4IzLJm6KmZA+93tFFINdCy+c7bYgcJhIpPtSv4RxYtIfxpcR/ej3jqys9YldHsJQVnv5gOynj87oFC0AUkRrhycrSzzF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxSeZPNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxSeZPNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A547FC4CEEB;
	Tue, 27 May 2025 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365440;
	bh=y6W6bFA4DhBTrM3cRqpXpsvp3lm62kM6JobmRZZy0vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxSeZPNAmXa2wzz9In47iIyaiGbjq5qsWThzToY7sbhCaxhZoCLTC+1AO8oDV+ppC
	 MVVWPZyG9ZKsjUtYH50vRoYjQYRX2jIm6/5oBuhQO4tRn5OqSyPhSddn6t8nucmbns
	 +qZ8gKUcREZDP87eLSruVr6SPL3ZvVhKnU/uXzPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/626] drm/xe/debugfs: Add missing xe_pm_runtime_put in wedge_mode_set
Date: Tue, 27 May 2025 18:24:28 +0200
Message-ID: <20250527162500.254927337@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 051a37e477f4c..278ce1c37b395 100644
--- a/drivers/gpu/drm/xe/xe_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_debugfs.c
@@ -156,6 +156,7 @@ static ssize_t wedged_mode_set(struct file *f, const char __user *ubuf,
 		ret = xe_guc_ads_scheduler_policy_toggle_reset(&gt->uc.guc.ads);
 		if (ret) {
 			xe_gt_err(gt, "Failed to update GuC ADS scheduler policy. GuC may still cause engine reset even with wedged_mode=2\n");
+			xe_pm_runtime_put(xe);
 			return -EIO;
 		}
 	}
-- 
2.39.5



