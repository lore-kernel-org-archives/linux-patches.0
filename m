Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69FB29B79B;
	Tue, 16 Jun 2026 16:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627063; cv=none; b=IkKszaqxlLk5Twnhbzlrcg/dVp8l0OVoW3PtUQw5w/ValHnFWS0N27fOivEywOF75mV5+N2/c4HXJ6gksu8V0qHQtPuVutLJZukJm2NKE18bGbU0BPYhhS1a75kVJi+aenYCl6vECQYj/BHjFilLxBA/C1M/AKBtiTgVKhx20iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627063; c=relaxed/simple;
	bh=G3HuSios1BV7vv4W88wdJLowtZWc8weiNuwZnGlLhJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsdquQi2g4Ek4G2g3yH4xNOPc6Akmm5qgV6Ljq5c70ussn/2qeUwgV+iY7RPqH10GGRWTtv29QBbsI4rfyJDNCFkGrZJIFMvpyN/eMtxQ2axdv8vTzOaiNuxTcoyveGHNaqR5QUpT9Mq8UvSCOq6mXtVEX3LwIHdoaYge5dBI5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuqtWPDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuqtWPDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A592B1F000E9;
	Tue, 16 Jun 2026 16:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627062;
	bh=9vN4xEh6SfZZMxfotdVcz0p+jhEPzwQUobiRG1oOPdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuqtWPDMAgUjqaBK1DNO4oe/uF+MS8ti1je6yoITa9horXAH3NVtVVPVcLhoJBawh
	 yWMvpIyqlvddIpZnRFocCfZyx8HmpWCY2jX8beOvf6SHvvsaXJl96H8TzCDSvXbP9D
	 dgo7+PJVZNZtYZb2eyuS5uVv0OlBPdsnNlhLsu98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/261] clk: qcom: x1e80100-dispcc: Stop disp_cc_mdss_mdp_clk_src from getting parked
Date: Tue, 16 Jun 2026 20:29:12 +0530
Message-ID: <20260616145050.349477576@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit bc27dbefae6ed11376d991a2921eff806ffef67c ]

Parking disp_cc_mdss_mdp_clk_src at 19.2MHz causing the EFI GOP framebuffer
to stop functioning. The EFI GOP framebuffer should keep working until
the msm display driver loads, to help with boot debugging and to ensure
display output when the msm module is not in the initramfs.

Switch disp_cc_mdss_mdp_clk_src over to clk_rcg2_shared_no_init_park_ops
to keep the EFI GOP working after binding the x1e80100-dispcc driver.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
Link: https://lore.kernel.org/r/20260425123351.6292-1-johannes.goede@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-x1e80100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-x1e80100.c b/drivers/clk/qcom/dispcc-x1e80100.c
index 40069eba41f241..5c00a0f8448931 100644
--- a/drivers/clk/qcom/dispcc-x1e80100.c
+++ b/drivers/clk/qcom/dispcc-x1e80100.c
@@ -580,7 +580,7 @@ static struct clk_rcg2 disp_cc_mdss_mdp_clk_src = {
 		.parent_data = disp_cc_parent_data_6,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_6),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.53.0



