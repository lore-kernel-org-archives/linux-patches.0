Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6847359F8C;
	Fri,  9 Jan 2026 11:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959581; cv=none; b=Dz6SxtDYnu4opOGdGO667s8i1D7nTli1IpXa7ggClMvGrgG9ox39rj4EieVA7HIRU0S28BdbwO+rbefEF0mWOzSFdlVUjIYmmIuoNc28MlqCZpHAWGg5AIDqSpKgbsioU+lPXDWnAN2PzdU8Tr5Zd/JOm4b9L2ZFRyf67pd/Fxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959581; c=relaxed/simple;
	bh=jrw6S8yLdzpoDhTao4bVpxEmY/aEWowvJK3qKYI+45g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyM7IxJ6d8MZW+6lOF2aRmQXbybIfKTPAKgbwKv3IPQQhxkteLSS4Oi+LCy4xUmQ9hrS1nl30rAPpxtR19Bi12/7z3oj+fWPwSetQb4I/JhJ7ogceS/J+N3and1KHQcaqclUKWOACBKoM19NBSegl26kKw6tAEzzAbxWD8c/Frw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHWIpQ7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHWIpQ7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52231C4CEF1;
	Fri,  9 Jan 2026 11:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959581;
	bh=jrw6S8yLdzpoDhTao4bVpxEmY/aEWowvJK3qKYI+45g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHWIpQ7ilAE8VU6slshW9szPJdCuOlrD3r1hWfmSZOpR7NS5wL5xA1bhQmXUELXVO
	 EZdwnvtomZCODpQMPuxLsQZGJ1xNgrP231JL0OMjdTS7XOm7kWdzyKVUYPqOe2g6+g
	 ngO5Fkw/1xOFf4YhXasCQsotcXTYqF8NtDWMUknE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/737] soc: qcom: smem: fix hwspinlock resource leak in probe error paths
Date: Fri,  9 Jan 2026 12:34:00 +0100
Message-ID: <20260109112137.801909224@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aead7dd482ea3..5217ff0a434f5 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -1164,7 +1164,7 @@ static int qcom_smem_probe(struct platform_device *pdev)
 		return hwlock_id;
 	}
 
-	smem->hwlock = hwspin_lock_request_specific(hwlock_id);
+	smem->hwlock = devm_hwspin_lock_request_specific(&pdev->dev, hwlock_id);
 	if (!smem->hwlock)
 		return -ENXIO;
 
@@ -1217,7 +1217,6 @@ static int qcom_smem_remove(struct platform_device *pdev)
 {
 	platform_device_unregister(__smem->socinfo);
 
-	hwspin_lock_free(__smem->hwlock);
 	__smem = NULL;
 
 	return 0;
-- 
2.51.0



