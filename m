Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C793823DE;
	Wed,  7 Aug 2024 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043559; cv=none; b=gWc01D9DxGEn6HXUiWozI8VIr6rg4deMYznQhQQ8FTGC3Rtw/RT4AnFPrHwbo7hDOYFPUYf+3fgqrzzSUER+8IJMxIuF7IcdxAUz4/iwqcH4aqo3H4v0QUx/2UeN+yjpHQNsLQKh7NmvgU/1Womqp91IbkZsSxKNMXKcDL0SAnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043559; c=relaxed/simple;
	bh=5TlRtoZJqGzHnsSi3OlX12oIYwdZhH0bCHSbSr4og9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVEQbsTg/wjV/YlsycnVPyMf+XZGUIytM3/pkR0gkJzGLHUbuNaGh6ApOcJDEhCn97c04p/Qk9D66jFP4zPyNnPuE3zMUjA77BFxubP/fjj8OmipzH8tfj/dl9q0EMRDUrgdHS+IGygFxjCYzX50RE386IpCv7g5sF8iVDyE7dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7VX7IyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7VX7IyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AD7C32781;
	Wed,  7 Aug 2024 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043559;
	bh=5TlRtoZJqGzHnsSi3OlX12oIYwdZhH0bCHSbSr4og9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7VX7IyNgtgN4/SusFZNYpXl8EUympUTgGRELy02WzlmhAMnlHqyaU9DVmeJkmmKP
	 ltcEk+NY8XSEGPNHbDz1tUbow7lUrIjVej2fqHyvt9e8Eyr+clkQsYHDKhgEKs82wl
	 D5y7J0mYis73ZOgxelMVKk6uAZSCX9bHaYErYDek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/86] cpufreq: qcom-nvmem: fix memory leaks in probe error paths
Date: Wed,  7 Aug 2024 16:59:54 +0200
Message-ID: <20240807150039.745555408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d01c84b97f19f1137211e90b0a910289a560019e ]

The code refactoring added new error paths between the np device node
allocation and the call to of_node_put(), which leads to memory leaks if
any of those errors occur.

Add the missing of_node_put() in the error paths that require it.

Cc: stable@vger.kernel.org
Fixes: 57f2f8b4aa0c ("cpufreq: qcom: Refactor the driver to make it easier to extend")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-nvmem.c b/drivers/cpufreq/qcom-cpufreq-nvmem.c
index 983991c0afd5c..2edb66097cdb9 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -290,23 +290,30 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
 
 	drv = devm_kzalloc(&pdev->dev, struct_size(drv, cpus, num_possible_cpus()),
 		           GFP_KERNEL);
-	if (!drv)
+	if (!drv) {
+		of_node_put(np);
 		return -ENOMEM;
+	}
 
 	match = pdev->dev.platform_data;
 	drv->data = match->data;
-	if (!drv->data)
+	if (!drv->data) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	if (drv->data->get_version) {
 		speedbin_nvmem = of_nvmem_cell_get(np, NULL);
-		if (IS_ERR(speedbin_nvmem))
+		if (IS_ERR(speedbin_nvmem)) {
+			of_node_put(np);
 			return dev_err_probe(cpu_dev, PTR_ERR(speedbin_nvmem),
 					     "Could not get nvmem cell\n");
+		}
 
 		ret = drv->data->get_version(cpu_dev,
 							speedbin_nvmem, &pvs_name, drv);
 		if (ret) {
+			of_node_put(np);
 			nvmem_cell_put(speedbin_nvmem);
 			return ret;
 		}
-- 
2.43.0



