Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A31F502D4D;
	Thu, 17 Sep 2026 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665027; cv=none; b=o0IKqQRT1pYC7PgFNX0p1TCGh39RyacUzma+UHHQAubsqAJJYKjWIejh1XrMeGB8chMOdqiTRk+gC4t9TWXHUEZBsWNb2Xq5Qyrb3FY5YQh9KvdLAnO+C9cFGRbkjZZsnBwnYX1IGIRvmJnlScmxdTaJ62OOblX6mRrJ4w7fvjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665027; c=relaxed/simple;
	bh=290nwblcXCVrAG/e0ADE1zq0Zsh3Z18VXBKeTAhQrtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5ZGPNH+PtsQF6Is9DVJ0eK+LP1ZPgGtJs6EoLpB6GSzCOg07QkMkUcM+vln6hBY86R7ME99UqQRd+ZNPRTaFVDgpF5yUXrIGX+z3ZLqwhAvXjYk90v/7Hi5MzOG7dxkr/4kjMiuGOARlbw85n4//gP6VTMcjUMrTWpMsdJNBns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgOxM9Sd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgOxM9Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EA11F000FF;
	Thu, 17 Sep 2026 17:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665026;
	bh=noohRZPDk3eHv5my15xXUlzV+3uApUB8UcmYrvvvZ0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgOxM9SdQwdIzyTP1ikn7WlkX+IX9jRd+Vo/6U7XUwPxxIWXH5yCj6OCJtEzCmHeO
	 Fcw5aCDNro7Gp6HEMAdeXdyTY8pnmRrVQPcwwJBA6kdJrsra7uoBW+ZsvvuN9dBYYN
	 RIL2UPMZloPCT7WFbIV77yFYEdF9lfGLgzkOKnLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0569/1250] iommu/arm-smmu-v3: Disable implementations during devm teardown
Date: Thu, 17 Sep 2026 16:06:04 +0100
Message-ID: <20260917151607.337598309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

The Tegra241 CMDQV teardown fix moved VINTF hardware deinitialization
into the implementation device_disable() callback. However, its stable
backport preceded the conversion to devm teardown and could only invoke
the callback from the shutdown path.

Now that arm_smmu_disable_action() manages normal teardown, invoke the
implementation callback there while the command queue is still alive.
This prevents the subsequent implementation remove action from releasing
resources while the CMDQV hardware remains active.

After ("iommu/arm-smmu-v3: Manage teardown with devm") merged in stable,
now keep the shutdown path consistent with mainline, where disabling
the base SMMU is sufficient.

It is a fix for stable tree commit to aligned with mainline, so no
upstream commit id here.

Fixes: 5994617e09ee ("iommu/tegra241-cmdqv: Fix CMD_SYNC use-after-free on teardown")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b677390e95bb9..3d796ff6c2c62 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4180,6 +4180,8 @@ static void arm_smmu_disable_action(void *data)
 {
 	struct arm_smmu_device *smmu = data;
 
+	if (smmu->impl_ops && smmu->impl_ops->device_disable)
+		smmu->impl_ops->device_disable(smmu);
 	arm_smmu_device_disable(smmu);
 }
 
@@ -4961,8 +4963,6 @@ static void arm_smmu_device_shutdown(struct platform_device *pdev)
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
-	if (smmu->impl_ops && smmu->impl_ops->device_disable)
-		smmu->impl_ops->device_disable(smmu);
 	arm_smmu_device_disable(smmu);
 }
 
-- 
2.53.0



