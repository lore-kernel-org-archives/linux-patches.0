Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63535341648;
	Tue, 16 Dec 2025 11:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884104; cv=none; b=VjtVSTywv28kbgQlP34F2u3XKRVxnops1hassaK/lsVQT2HILnSiJKoS8PU1g7Fbh4KM3VSWaz5ew3OR0BNJP6JGBLDFYOMwEh9XwlB+NbnQSdQt8z1B/j26tLCQUUNAe3DbbUCGxiKwGpStlkAJU9bfyNzsUhvWZIgLGJznMNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884104; c=relaxed/simple;
	bh=3Xu5QcOv9HT/bOG0soB9zjGw2zzwtYK+MTgYgsMG/eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlSkCWwcSMiFuzEPYWSvL3BoT9DTksob79vPln5Dor8idUCtJnwPsBi3nsLYQTz9zuXtYpe0MtV4nY3XJ3TWGNgpi2Kk624hRdpOBhV0K01PgoV7IdtCwvr/lCtb+7FVifAg2ZNGYFkYn3ux+7+GNQ9Uh+9A8N06TdY6cevdSBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnEmZI8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnEmZI8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD15FC4CEF1;
	Tue, 16 Dec 2025 11:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884104;
	bh=3Xu5QcOv9HT/bOG0soB9zjGw2zzwtYK+MTgYgsMG/eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnEmZI8aabTytx67qFJsI3t8F76TJkgmprkKSZb36Ac8a0Dj6hEWZ5arzpXhTGC/s
	 +GYrOh6kR1zSlzr1acuNjQ3KS7nUUDeug0koXpcy6nZO21FoSbBVEFJlwEtQHMV1FA
	 jICfn28GVLN3/yhB1e4oct5mvKb2BcNkqPb54NjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/354] soc: qcom: smem: fix hwspinlock resource leak in probe error paths
Date: Tue, 16 Dec 2025 12:10:59 +0100
Message-ID: <20251216111324.255576794@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit dc5db35073a19f6d3c30bea367b551c1a784ef8f ]

The hwspinlock acquired via hwspin_lock_request_specific() is not
released on several error paths. This results in resource leakage
when probe fails.

Switch to devm_hwspin_lock_request_specific() to automatically
handle cleanup on probe failure. Remove the manual hwspin_lock_free()
in qcom_smem_remove() as devm handles it automatically.

Fixes: 20bb6c9de1b7 ("soc: qcom: smem: map only partitions used by local HOST")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251029022733.255-1-vulab@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index 56eea77395bf2..170f88ce0e50e 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -1186,7 +1186,7 @@ static int qcom_smem_probe(struct platform_device *pdev)
 		return hwlock_id;
 	}
 
-	smem->hwlock = hwspin_lock_request_specific(hwlock_id);
+	smem->hwlock = devm_hwspin_lock_request_specific(&pdev->dev, hwlock_id);
 	if (!smem->hwlock)
 		return -ENXIO;
 
@@ -1239,7 +1239,6 @@ static void qcom_smem_remove(struct platform_device *pdev)
 {
 	platform_device_unregister(__smem->socinfo);
 
-	hwspin_lock_free(__smem->hwlock);
 	__smem = NULL;
 }
 
-- 
2.51.0



