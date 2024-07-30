Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DA61A76D4;
	Tue, 30 Jul 2024 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360118; cv=none; b=kUlPIJyxmGBTNSt1AT+/S+ruE9Cuv9SswSi1R+xtl3L7KseTJubKy5kKkW/Fhkh+3qYwjK5gU+SOrUrbbhtEJSWe6kVIUk/oFBsZcV4CiiN+kI5yzxzZssLUj/AfIRGGxYoqW52LtprI7/7CtAqNQhzVZtM+BeOXbCw+FgPZD/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360118; c=relaxed/simple;
	bh=z69r6gbNvA3/m0fEm4vj4YNA+RDxjZo2jOhRST6Shrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqaqezHwJzukzmw7YghnzJNOrFc4Yq1OdhaE8kgPnF3fbtVd0clUriO+AuuiDEsKK4LyWyOe0PK+hjLXOsKkcyfIieFLU5WOY7/38yWxsfH7gWRq0wsucL5F8lkSlsauUKwubSsb7WyY25TlVvd9bDYphcliuXUYA2NdTLYaxLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQlHqRna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQlHqRna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35802C32782;
	Tue, 30 Jul 2024 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360118;
	bh=z69r6gbNvA3/m0fEm4vj4YNA+RDxjZo2jOhRST6Shrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQlHqRnaaBcKwSeFyQX7xdM+gljkUwDY8iNaTVEZa5H9j3ihyLhgZgiJm7X2hYQwV
	 6DCRdhD6bZRbRMmVxCZs93TC6aYODElmdVJewV3fKkjikManTajZ8SOMxUW3AmPLeO
	 XZt6DNhDMvY0j5Jl83k5OYlRMAzSgFRzvPT8V6Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.10 603/809] cpufreq: qcom-nvmem: fix memory leaks in probe error paths
Date: Tue, 30 Jul 2024 17:47:59 +0200
Message-ID: <20240730151748.649844064@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit d01c84b97f19f1137211e90b0a910289a560019e upstream.

The code refactoring added new error paths between the np device node
allocation and the call to of_node_put(), which leads to memory leaks if
any of those errors occur.

Add the missing of_node_put() in the error paths that require it.

Cc: stable@vger.kernel.org
Fixes: 57f2f8b4aa0c ("cpufreq: qcom: Refactor the driver to make it easier to extend")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -480,23 +480,30 @@ static int qcom_cpufreq_probe(struct pla
 
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


