Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33AD1AC8A2;
	Mon, 14 Oct 2024 15:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918825; cv=none; b=q9pIhZW5QcdNWHJNRPFqFIY+HdVr2HChJo2gEQwEWpYNQCLU5wGljeHnanIccFZ2T0xUXQmz8ToaD/CYbBbG2l79Bc6Kc3c+cbo6fI8gkQRsEB83YmY4e3iwHqlQb1hxZ2SDlFKP4O5AuCAM4McTM+/vb0f9+z0COPKvb7TzE+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918825; c=relaxed/simple;
	bh=dI+FpOcF0G2v1uhIO3e77aDxdDAivSb0ktnSQKIbzHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1ph0CsskyZHaz/zsCMRzLAtR/N9QGhlgiCYVp2dAA08WjEw7qwhAm4dZValrl5Ni2T01Zop3XOuDBQh+CtH/S84pJXi3mvhokeN7FhO35NU11aR8Hv+XyLX2s9TNfuWA1S1OP+CXkmUSuUnMtKZ1fsWIyxc0VS2V7y18H9rry0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLKRHkf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLKRHkf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7FEC4CEC7;
	Mon, 14 Oct 2024 15:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918824;
	bh=dI+FpOcF0G2v1uhIO3e77aDxdDAivSb0ktnSQKIbzHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLKRHkf/buqSMVygid2tyYsPYMUMoT9YMrEb/RT/tbcj9w+VkPqk27aJAjtvGoSSj
	 O7WcjbK902CN1UJI7leC8bLYY7JrryxEaqli+1Q0ghKhpgP0Fp39v6flj6ICaTR6WT
	 z/IImk2YpsValMImRkwzMPKkiRwccREUCHSFvquk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 392/798] net: wwan: qcom_bam_dmux: Fix missing pm_runtime_disable()
Date: Mon, 14 Oct 2024 16:15:46 +0200
Message-ID: <20241014141233.344904369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit d505d3593b52b6c43507f119572409087416ba28 ]

It's important to undo pm_runtime_use_autosuspend() with
pm_runtime_dont_use_autosuspend() at driver exit time.

But the pm_runtime_disable() and pm_runtime_dont_use_autosuspend()
is missing in the error path for bam_dmux_probe(). So add it.

Found by code review. Compile-tested only.

Fixes: 21a0ffd9b38c ("net: wwan: Add Qualcomm BAM-DMUX WWAN network driver")
Suggested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/qcom_bam_dmux.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/qcom_bam_dmux.c b/drivers/net/wwan/qcom_bam_dmux.c
index 17d46f4d29139..174a9156b3233 100644
--- a/drivers/net/wwan/qcom_bam_dmux.c
+++ b/drivers/net/wwan/qcom_bam_dmux.c
@@ -823,17 +823,17 @@ static int bam_dmux_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(dev, pc_ack_irq, NULL, bam_dmux_pc_ack_irq,
 					IRQF_ONESHOT, NULL, dmux);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	ret = devm_request_threaded_irq(dev, dmux->pc_irq, NULL, bam_dmux_pc_irq,
 					IRQF_ONESHOT, NULL, dmux);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	ret = irq_get_irqchip_state(dmux->pc_irq, IRQCHIP_STATE_LINE_LEVEL,
 				    &dmux->pc_state);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	/* Check if remote finished initialization before us */
 	if (dmux->pc_state) {
@@ -844,6 +844,11 @@ static int bam_dmux_probe(struct platform_device *pdev)
 	}
 
 	return 0;
+
+err_disable_pm:
+	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+	return ret;
 }
 
 static int bam_dmux_remove(struct platform_device *pdev)
-- 
2.43.0



