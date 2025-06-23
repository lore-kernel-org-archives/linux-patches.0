Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE3370838;
	Mon, 23 Jun 2025 21:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712820; cv=none; b=VIAM3jB22JENk+4iR441WV5/znamithLBUWdUcKxfDf+DT4JD5NyzRTOWIQR+2hTH1fzKL334+s08h5QOHIQv1tUEOLCOwtqE+CJl7lKhj9OEw3UZOdcT8ChUCKsrjxm2gx7BhV8wz9mr8XVocKy9sJUwnDD3GkAMGYaxjR5euo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712820; c=relaxed/simple;
	bh=kLq8MGQE4Ot/bzaHu2Z1p60X2Q/MWL31s3rsx/d1TyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRvj8QbVeFzt5TWCVJ4Khl9LfCQYVN3sLtZE3NUmZ8J4rkue8+RStstw3k0dVRgcRjnk6UetG5W1vpynLkpGf78txieSDWZhXWmaD5yvzG2ElatXa6GbztDV9Pn1uraQjSWo8df/z9SJ+Z8bp9ejbspCRp/s3T5LetSCdpPgsBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoqqzinF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoqqzinF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAF1C4CEEA;
	Mon, 23 Jun 2025 21:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712819;
	bh=kLq8MGQE4Ot/bzaHu2Z1p60X2Q/MWL31s3rsx/d1TyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NoqqzinFgiqxwUO3X3iEQSnuw4QN8OY4hudh3Xj1Bkv8tYpVVTq+5uH5o0EMgrJZ6
	 L8XLAefimYl7+p2VASouafVSURN4MI0+L6/GkIU9md7l5Y+Am2Kiv6eSQxTeNVs386
	 f9ENksCApEGQ0Hr3VksqZLfpstlHwoFwLOihyDxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/355] pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()
Date: Mon, 23 Jun 2025 15:05:08 +0200
Message-ID: <20250623130629.989737267@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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
index f5a032b6b8d69..7a76f0c53f545 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2676,7 +2676,7 @@ struct device *genpd_dev_pm_attach_by_id(struct device *dev,
 	/* Verify that the index is within a valid range. */
 	num_domains = of_count_phandle_with_args(dev->of_node, "power-domains",
 						 "#power-domain-cells");
-	if (index >= num_domains)
+	if (num_domains < 0 || index >= num_domains)
 		return NULL;
 
 	/* Allocate and register device on the genpd bus. */
-- 
2.39.5



