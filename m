Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5AA28934F;
	Tue, 27 May 2025 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368598; cv=none; b=c0zxVrmlXR4X5XqsmTAgG/lNymUZgcQwc/u3qgwlJQqUzKtVWugsooNxZ4wwsd5hEbavsgoEc8bVVU1eYTEeXCPEaYg7FBIJGqrwUq229+EqTGOdhN6uNNlfR14+bfptXmr4xJlDD2gkIL4EmAx0o9CiOSpBmkgQlhl8LCXfQYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368598; c=relaxed/simple;
	bh=KBHPnOpp+VJ9OxyN4NYrnX6qaBep0Qqo2V4nhxrHJtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBaAGODviAiZvWQ5K6dV9nfuyO6nhrhq5v6S4ybPpG8WtjsQbuzjXCfGbLpmsIbvHI43SU59DWyKsG2Uns93Z74oDXKdZ1FhrYSjMpTEOFm+k2PiGR+O9G+mbCIhODQbRr4jNgTEo60+HGN/IFGRYllufQ7IToZrnk2Lc16dNkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYXm70yO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYXm70yO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5DFC4CEE9;
	Tue, 27 May 2025 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368598;
	bh=KBHPnOpp+VJ9OxyN4NYrnX6qaBep0Qqo2V4nhxrHJtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYXm70yOHSORuUdOxvfI85J3EdkdFUGRYMsWB3zaYXKTebALEr8u/J645XC8hM7wa
	 CXUee4YtAXTkuaBP0+PnFtFMRcCLu7xXxqdt3qDjGidWRSFeGZlAWL0gKXQfLHWeFj
	 U8iBnNQUp6i1Vc0QOVdidI2WP84ys/f3gch0FNvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.14 741/783] pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()
Date: Tue, 27 May 2025 18:28:58 +0200
Message-ID: <20250527162543.302265960@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 0f5757667ec0aaf2456c3b76fcf0c6c3ea3591fe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -3091,7 +3091,7 @@ struct device *genpd_dev_pm_attach_by_id
 	/* Verify that the index is within a valid range. */
 	num_domains = of_count_phandle_with_args(dev->of_node, "power-domains",
 						 "#power-domain-cells");
-	if (index >= num_domains)
+	if (num_domains < 0 || index >= num_domains)
 		return NULL;
 
 	/* Allocate and register device on the genpd bus. */


