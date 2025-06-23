Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0BD1ACEDA;
	Mon, 23 Jun 2025 21:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713729; cv=none; b=OFSzLrDpXaMaHj6FIMRUYymHYYuBEXHMx6LH3tVI7IBViW707M324m13iaml0TC4AzvFjCnX6paGk0foIp5Q9NRm5miB3b8SmKl848WhT3pX5qsoYBOuk1OPYJ2zUmTqggsIKjxY8pwswmN7Dgw5hOeZJbf5hBvNT5A0L2o65Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713729; c=relaxed/simple;
	bh=OgYjDORQxV1llXdfrZ4ofmli5S5njiTSYl05idCJrtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6siMvlmmiqMIhHfeyFCoAt4Hz/WcC1wtNPubEJBegqgTmyelp6cGxepV+C8PZ/ZF6dt8eWKOKVYE85lomUHTU4wTiW3Nnt/fgfSG4UNjMGF6ypIkOmrjLSfmKjGOl2P+Cus7Dc4ZYGV3NdJS21T0ghmaQV/ef3M20eBJhHr8Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIqPn+nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIqPn+nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C57C4CEEA;
	Mon, 23 Jun 2025 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713729;
	bh=OgYjDORQxV1llXdfrZ4ofmli5S5njiTSYl05idCJrtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIqPn+nZ769LFkoIS7IT8WyqkdlYxaSEup43Ew8fEgF5uig7JJlaRH6xHKHdF9Tls
	 CUcjPACFBkGVCtpsj7umNV+heMaNBW7GaCyNTm+7auAazpqhFnKctE/kHYuVvoW+bV
	 BziraUdOMBZdOgumr3nR9ttRYWqhiSyrGIH/rncA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/411] pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()
Date: Mon, 23 Jun 2025 15:04:34 +0200
Message-ID: <20250623130636.842468519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fda0a5e50a2d9..005ece1a658e5 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2773,7 +2773,7 @@ struct device *genpd_dev_pm_attach_by_id(struct device *dev,
 	/* Verify that the index is within a valid range. */
 	num_domains = of_count_phandle_with_args(dev->of_node, "power-domains",
 						 "#power-domain-cells");
-	if (index >= num_domains)
+	if (num_domains < 0 || index >= num_domains)
 		return NULL;
 
 	/* Allocate and register device on the genpd bus. */
-- 
2.39.5



