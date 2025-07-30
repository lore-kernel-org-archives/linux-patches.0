Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2319255F5C;
	Wed, 30 Jul 2025 09:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868992; cv=none; b=S82mRPkqtVp/YtbHDXlzPCuOSpd7DyTdF/eIYl9JScNNpRDSilowj7l7TzvEDk7X0+pKJkXsLqrqS+UBZOuIk8c51QYx9lJBnxHVccv/BUhzCWJgZ/CxBp2yyk+QiLM5R7yYDFhbaZwo5m0yZVu2xFO/aziFwz0+OSa4n+xSHiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868992; c=relaxed/simple;
	bh=vnrs8ipr+rCrFb/REY8WMKIXsYIoZy45EuO4Jdyi914=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWCsxeN6r+o2CM2VU6P3tprXDCI+8cfLhv7olqPYeH9itVXQ/6kuJXxvSdbTJg+1XUG8svpXjdjXeOFnolzBIPdW0j1d6lP1OT/4rXGqcOy0rXmQe63mCtRsHZCvWb9iwT7QAbwymY7l2ATMElwbNObP/6+z4xj9cf4Ue7gRa0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPG+Ku0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPG+Ku0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1ADC4CEF5;
	Wed, 30 Jul 2025 09:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868992;
	bh=vnrs8ipr+rCrFb/REY8WMKIXsYIoZy45EuO4Jdyi914=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPG+Ku0ef9a/y3+YmZ958pp8tQAaDtNwTWW69VTK6pfQ9ez7m9hbkR33VT6elG6rZ
	 NFLHAVT0Kvj3MfG9pBIkIKYSnB23gEiDROplIgcipC09vdBIFDCGdZJxJWgqDjlpys
	 IiWDjvZzcVGqI8qV+cayYTypNOxCXunOmMu5JFrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 10/92] interconnect: icc-clk: destroy nodes in case of memory allocation failures
Date: Wed, 30 Jul 2025 11:35:18 +0200
Message-ID: <20250730093231.024899522@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 618c810a7b2163517ab1875bd56b633ca3cb3328 ]

When memory allocation fails during creating the name of the nodes in
icc_clk_register(), the code continues on the error path and it calls
icc_nodes_remove() to destroy the already created nodes. However that
function only destroys the nodes which were already added to the provider
and the newly created nodes are never destroyed in case of error.

In order to avoid a memory leaks, change the code to destroy the newly
created nodes explicitly in case of memory allocation failures.

Fixes: 44c5aa73ccd1 ("interconnect: icc-clk: check return values of devm_kasprintf()")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20250625-icc-clk-memleak-fix-v1-1-4151484cd24f@gmail.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/icc-clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/interconnect/icc-clk.c b/drivers/interconnect/icc-clk.c
index 88f311c110207..93c030608d3e0 100644
--- a/drivers/interconnect/icc-clk.c
+++ b/drivers/interconnect/icc-clk.c
@@ -117,6 +117,7 @@ struct icc_provider *icc_clk_register(struct device *dev,
 
 		node->name = devm_kasprintf(dev, GFP_KERNEL, "%s_master", data[i].name);
 		if (!node->name) {
+			icc_node_destroy(node->id);
 			ret = -ENOMEM;
 			goto err;
 		}
@@ -135,6 +136,7 @@ struct icc_provider *icc_clk_register(struct device *dev,
 
 		node->name = devm_kasprintf(dev, GFP_KERNEL, "%s_slave", data[i].name);
 		if (!node->name) {
+			icc_node_destroy(node->id);
 			ret = -ENOMEM;
 			goto err;
 		}
-- 
2.39.5



