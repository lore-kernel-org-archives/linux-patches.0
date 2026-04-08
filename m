Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24773D75AF;
	Wed,  8 Apr 2026 18:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673222; cv=none; b=TRs+g02pXNd0MxXesVnhAyDfw4j+0AdDw21W6L5jLdtZ8UX1kwtISmq9gtyAdWBl5HfVUHLjm2AXmJYMLfLtholLLNGRmTlQZJk+DFbhuMa3S01tsc3OaTX3+p8P/93h+0PQYPRtpU4HEC0XOu2iuDCjhS/RaiFiSfjOXZOCP8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673222; c=relaxed/simple;
	bh=MAbBNjQdhgSb1BqBHCxsdtT8vpGQ5UW2ItH+MPOLH7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYC7LKjuh/sRSzD9Ri3+so/HRpjmLbZiVoGtrN2xDWeWOHXovyCIQt0zKpS6/7/Gx5O4OoIVFM7gZi4se3MuxJyT0SC5PCzd8tx22KbNztbsD6EqSmMsHvc6vPBQNPpuabq1ZToGDDBgxnOUrIKv5eLANZMnlvS2vc8onLcwKIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXtsUHOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXtsUHOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B57BC19421;
	Wed,  8 Apr 2026 18:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673222;
	bh=MAbBNjQdhgSb1BqBHCxsdtT8vpGQ5UW2ItH+MPOLH7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXtsUHOBBWPX43+nAby7LOLJoALRBkd6wW9TYYn6y4Vk+ckCXvQj3ek73f09GSeHt
	 rHy/9OD0sFmrbiX6o2bmWCIC3YgirS0kXq7Fx/i6rv31hEKZjmC52+kaIOmOIecVc3
	 D1XC3w1QQ+g4k8YJhTZVOxlLKiOoaGS407A+rIDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn Teres Alexis <alan.previn.teres.alexis@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/277] drm/xe/pxp: Clean up termination status on failure
Date: Wed,  8 Apr 2026 20:01:40 +0200
Message-ID: <20260408175938.167160897@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit e2628e670bb0923fcdc00828bfcd67b26a7df020 ]

If the PXP HW termination fails during PXP start, the normal completion
code won't be called, so the termination will remain uncomplete. To avoid
unnecessary waits, mark the termination as completed from the error path.
Note that we already do this if the termination fails when handling a
termination irq from the HW.

Fixes: f8caa80154c4 ("drm/xe/pxp: Add PXP queue tracking and session start")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn Teres Alexis <alan.previn.teres.alexis@intel.com>
Cc: Julia Filipchuk <julia.filipchuk@intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://patch.msgid.link/20260324153718.3155504-7-daniele.ceraolospurio@intel.com
(cherry picked from commit 5d9e708d2a69ab1f64a17aec810cd7c70c5b9fab)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pxp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_pxp.c b/drivers/gpu/drm/xe/xe_pxp.c
index bdbdbbf6a6781..ba4d52001b853 100644
--- a/drivers/gpu/drm/xe/xe_pxp.c
+++ b/drivers/gpu/drm/xe/xe_pxp.c
@@ -603,6 +603,7 @@ static int pxp_start(struct xe_pxp *pxp, u8 type)
 			drm_err(&pxp->xe->drm, "PXP termination failed before start\n");
 			mutex_lock(&pxp->mutex);
 			pxp->status = XE_PXP_ERROR;
+			complete_all(&pxp->termination);
 
 			goto out_unlock;
 		}
-- 
2.53.0



