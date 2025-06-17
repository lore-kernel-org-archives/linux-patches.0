Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753552F2352;
	Tue, 17 Jun 2025 16:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176453; cv=none; b=DkcAbrAHR7zJEBETLxWTlnc/tmFTF6PZkDBa57Hss1xIAkMTpvTgD5iq5hlffx9W1/gQ6HG0J2uYY8FZstTlEcbKuQsSMpdWyqTJGA0QPQYuGCg3PBzhQ0PtJ/i45kr2ONZuCJGp2pwh6vYEhpbQeK4qGAzAbga0/2FlV66E+PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176453; c=relaxed/simple;
	bh=0wYzuGcVpMImKBJeBp3ZsMOQjFVK2dCf0IJOgRfl59c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7fe8Os4VkFPksBiR3/fZHWeJwj8sxQluEO40q+O8OWsDkdX8ffzoEHJCCTKCdLGOX/5ZLQMTdf2eW5Q0AGk18rUXO+9jxkvu9PLESWA36GW16gFwI3nWsWYuetAYaFuEQS813ZJr3KERLeOxHnwfOtWLbfuZAzuc4ahAmay2mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/xFzVMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/xFzVMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41B8C4CEE3;
	Tue, 17 Jun 2025 16:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176453;
	bh=0wYzuGcVpMImKBJeBp3ZsMOQjFVK2dCf0IJOgRfl59c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/xFzVMJ91ZrQ4Z7tWY1Ht1voc1slbnEIq7+DyvBZ17gOCgxsR5Or3uLF4ml3M+hI
	 X/v6OYRdeGxLuk8UajsnzyAmHXUz504ytmNlNqPx9BdweJvKZ1qoHtg+NMB9s5hjJp
	 GCoIsxLuhM38AcufqIBiSXnfVBchxYctOW1BZ1mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/356] pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()
Date: Tue, 17 Jun 2025 17:26:34 +0200
Message-ID: <20250617152349.423427176@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 0f5757667ec0aaf2456c3b76fcf0c6c3ea3591fe ]

The error checking for of_count_phandle_with_args() does not handle
negative error codes correctly.  The problem is that "index" is a u32 so
in the condition "if (index >= num_domains)" negative error codes stored
in "num_domains" are type promoted to very high positive values and
"index" is always going to be valid.

Test for negative error codes first and then test if "index" is valid.

Fixes: 3ccf3f0cd197 ("PM / Domains: Enable genpd_dev_pm_attach_by_id|name() for single PM domain")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/aBxPQ8AI8N5v-7rL@stanley.mountain
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index d9d339b8b5710..d1dae47f3534b 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2856,7 +2856,7 @@ struct device *genpd_dev_pm_attach_by_id(struct device *dev,
 	/* Verify that the index is within a valid range. */
 	num_domains = of_count_phandle_with_args(dev->of_node, "power-domains",
 						 "#power-domain-cells");
-	if (index >= num_domains)
+	if (num_domains < 0 || index >= num_domains)
 		return NULL;
 
 	/* Allocate and register device on the genpd bus. */
-- 
2.39.5



