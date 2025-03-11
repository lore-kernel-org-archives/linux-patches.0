Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BB825DD08;
	Tue, 11 Mar 2025 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706632; cv=none; b=ocRR058IaTzCV4MEjQdroaSj/OFFpQMyrzM/heHccLhrXR/sR70pUTDRbYCW+KGEiuajRdSnbmp/GvqdFjmJI6bEVKTLohO26qdfJgnQZuAz+4tJL3fML5NVoeSHoTlSqGvjBw7aSnRLrklOJz1Ou3V0voSVjNhj80ETQC8PpgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706632; c=relaxed/simple;
	bh=jHF0Dk3x70kz4AuPHavXoDax0+xdVFpetc0bPNAdKYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QY8DCfQY19OSybUGdfjZvCK2AVb13mHQhSlofXuHd89Z3F/AckxSY7ahowMS6jK7vBFGws3GSuN+5Obak+GONzrdlgg0EViQ1kS39FcxfLhEr2fOsToyNiQTRWw4Vy6TSPDvUgc1YAYVSZg0E/7w1+UYLlwn5kVRE4xL3afy6tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMfS63ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMfS63ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48107C4CEED;
	Tue, 11 Mar 2025 15:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706631;
	bh=jHF0Dk3x70kz4AuPHavXoDax0+xdVFpetc0bPNAdKYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMfS63aeXIk1v/3BD4YBhPeZMG9VWOprqj//bpGGns6Xxw/cEP9yTWdEplLQi7bFq
	 ATCb31cxjG+2eA57J7zGrPKCvzZtG0ufq2va3spctZvhIvL0rJYYQ1ozSCHrInW2aQ
	 upeGLV0u+C+vwn0I3Y+FQvMzJ14NmsbFBaAy7OXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/462] media: marvell: Add check for clk_enable()
Date: Tue, 11 Mar 2025 15:55:49 +0100
Message-ID: <20250311145801.632094438@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 11f68d2ba2e1521a608af773bf788e8cfa260f68 ]

Add check for the return value of clk_enable() to guarantee the success.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
[Sakari Ailus: Fix spelling in commit message.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index e56c5e56e824a..2d7e68fa2b9af 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -935,7 +935,12 @@ static int mclk_enable(struct clk_hw *hw)
 	ret = pm_runtime_resume_and_get(cam->dev);
 	if (ret < 0)
 		return ret;
-	clk_enable(cam->clk[0]);
+	ret = clk_enable(cam->clk[0]);
+	if (ret) {
+		pm_runtime_put(cam->dev);
+		return ret;
+	}
+
 	mcam_reg_write(cam, REG_CLKCTRL, (mclk_src << 29) | mclk_div);
 	mcam_ctlr_power_up(cam);
 
-- 
2.39.5



