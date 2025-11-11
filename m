Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21DF1DF258;
	Tue, 11 Nov 2025 00:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822703; cv=none; b=YW+PVCnO8wcGSQvWlOYLnTsHrMMrAkUq2GOSyk15Z/tqNHv2Fkw4R/DJu4HdcgkRcvCwUE+wtNDluxjTcfnQnYQ5i+eI6zwQKzbO2VKIvbqSCTBbEOedqErAGjdSkINBISe3F2T+4SouXaqYSQIb3Tw495TwBxo2FYjZaB8J+Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822703; c=relaxed/simple;
	bh=hQ2cYZThJ/ZRRipIttx8NPfq0XZzONHnYJ+iDwvHK40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLxUgGUbB8gwa4M2ZBk/q7OkG+53nEtKR8P/M+qhvmRm2Cxpete117D7PHmo/0Ec5Rx9JREGHji1+rKLUTki+syUkWpMJVc/13v8jZL126r4BVEJENvipAAi81L1MTwzq9duCzo4O+0/2Utm9a+8jpxf4bcaox84XJNGf1W+/9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2dJe8vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2dJe8vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4F6C19425;
	Tue, 11 Nov 2025 00:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822703;
	bh=hQ2cYZThJ/ZRRipIttx8NPfq0XZzONHnYJ+iDwvHK40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2dJe8vl5OwSAm6sLQqlz6Wl+BXeAeb/mNBL1LSShETmXJl9geJounR1ddj/Sls3t
	 HWoK6Mt+JxDBtIfRFEvHX5JNPzY9LX2+XoA8lO8K6mEZZV8KIfhald8MNip68qGbge
	 XcOhSzjSQwYNheH/GOiZ6ejOtKHyBsLZf2zerjCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/565] firmware: qcom: scm: preserve assign_mem() error return value
Date: Tue, 11 Nov 2025 09:39:05 +0900
Message-ID: <20251111004528.971363913@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 121fcf3c871181edce0708a49d2397cedd6ad21f ]

When qcom_scm_assign_mem() fails, the error value is currently being
overwritten after it is logged, resulting in the loss of the original
error code. Fix this by retaining and returning the original error value
as intended.

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250807124451.2623019-1-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 23aefbf6fca58..1da16bc79391c 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1093,7 +1093,7 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	if (ret) {
 		dev_err(__scm->dev,
 			"Assign memory protection call failed %d\n", ret);
-		return -EINVAL;
+		return ret;
 	}
 
 	*srcvm = next_vm;
-- 
2.51.0



