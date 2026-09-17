Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05844C10EF;
	Thu, 17 Sep 2026 15:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658386; cv=none; b=B3Wapk2fAHZwKvKFfN2h+SKDKYXurRdL5lKvCEk1SwB/05M2NsG/f7YHmHy9E+TyFIiWSr6c53TOV8XPnQl0U661o9bA2I54Bx7CpJ6Id1nzMpRg5Qe97aIKUfje/WNXnj27gGT8X9sjtkmjp5FpIDfkgk6HmWjsaYaO+NYxwCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658386; c=relaxed/simple;
	bh=glmnUYkG6PxUirkDfSm6K32vHESo07vGAPpCec16S78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlkyOlEWT4liv13iKKJSjYjadBN98l3BEFvq4XIEfMn1pEl+/Bm7zxP6+Z57abNcSWTa6DRIucgHWlcbqmPQskUc/b9acZCm8WjlW0AWvMfwPaFZafbDQm1gT9O4VNSezT5dX1GawrqQSgxCR82dsBN8BMD5JDYdih3dfegpTFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bW/z2MhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bW/z2MhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ECD1F00898;
	Thu, 17 Sep 2026 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658377;
	bh=8V4Tt/552AbvYKTebedDxxwdAH6FZHwT+meB1MRVN4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bW/z2MhRx1WzKLdA9epN7Su6o0VWVeEimBm9NGsP/Km6/fNrH1i3RBY7ewlqgNchV
	 IUp9ezqGtd7G7SJQHh1bZv503t9OmNsCxwOlumpQ98a/e74CyezespR2PNxbUoeG3Z
	 KICW6cUHNLhX0iHLJbweTldfy07D3J0wlrN02ZYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 001/733] iommu/arm-smmu-v3: Disable implementations during devm teardown
Date: Thu, 17 Sep 2026 16:05:09 +0100
Message-ID: <20260917151350.650263991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 35b7b2fd4a122..b52dae11fbbef 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4741,6 +4741,8 @@ static void arm_smmu_disable_action(void *data)
 {
 	struct arm_smmu_device *smmu = data;
 
+	if (smmu->impl_ops && smmu->impl_ops->device_disable)
+		smmu->impl_ops->device_disable(smmu);
 	arm_smmu_device_disable(smmu);
 }
 
@@ -5555,8 +5557,6 @@ static void arm_smmu_device_shutdown(struct platform_device *pdev)
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
-	if (smmu->impl_ops && smmu->impl_ops->device_disable)
-		smmu->impl_ops->device_disable(smmu);
 	arm_smmu_device_disable(smmu);
 }
 
-- 
2.53.0



