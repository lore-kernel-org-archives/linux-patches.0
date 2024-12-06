Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B2E18FDAA;
	Fri,  6 Dec 2024 15:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498039; cv=none; b=aULDslqGT/310je8J5kbLVUMDW8HVrar+a8wq01Ez0zfJrCG2z4JxP7kJrdMfrKDiDDp25zk35dK8u1r4OYU0iC3T+NU3AeiijKyTYrKBLDLVGiCMGOTfRwIktYOtsaUS8cBhwGI3q89Qhi8EOs5/nQXJq7Ptit8c++T8AT+Zos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498039; c=relaxed/simple;
	bh=ei3tbR2FBxnX9yQppU81m+XdKlTtZgUvvugTFUBfcbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEX7GyEx21hgd9ekoaabv6uwuCGTw61gUAS3L1jGXwL49srkq9jWuc5L/zwfvB58RtegY74yx/YOfYtVhNYlV1LYHtk6aj+mTu4s1czQqZzwE6zz5lq99O8zhnkxL8H+akRreLnp/9wTeuKETdIZCreJNYZtHeutbD4wXnYXNBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFZtdAI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFZtdAI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EE6C4CED1;
	Fri,  6 Dec 2024 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498039;
	bh=ei3tbR2FBxnX9yQppU81m+XdKlTtZgUvvugTFUBfcbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFZtdAI9O7HpUR5VYQx+PpeeNtSWVCJhCe4HZGhFf3TMdo1aHVYKWk8fhag1gvP0Q
	 dZSKyx+szeb10wiB6kV2gjVgHM/x3BSh1DTPdcNrb0Ouh4DlkPObe8yroDg9MAq27c
	 Io2FkjJMoetrumfopUiqVZv5AiZkgK5wGkVgo8+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 468/676] soc: qcom: socinfo: fix revision check in qcom_socinfo_probe()
Date: Fri,  6 Dec 2024 15:34:47 +0100
Message-ID: <20241206143711.649826617@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>

commit 128fdbf36cddc2a901c4889ba1c89fa9f2643f2c upstream.

In success case, the revision holds a non-null pointer. The current
logic incorrectly returns an error for a non-null pointer, whereas
it should return an error for a null pointer.

The socinfo driver for IPQ9574 and IPQ5332 is currently broken,
resulting in the following error message
qcom-socinfo qcom-socinfo: probe with driver qcom-socinfo failed with
error -12

Add a null check for the revision to ensure it returns an error only in
failure case (null pointer).

Fixes: e694d2b5c58b ("soc: qcom: Add check devm_kasprintf() returned value")
Signed-off-by: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241016144852.2888679-1-quic_mmanikan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/socinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -757,7 +757,7 @@ static int qcom_socinfo_probe(struct pla
 	qs->attr.revision = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%u.%u",
 					   SOCINFO_MAJOR(le32_to_cpu(info->ver)),
 					   SOCINFO_MINOR(le32_to_cpu(info->ver)));
-	if (!qs->attr.soc_id || qs->attr.revision)
+	if (!qs->attr.soc_id || !qs->attr.revision)
 		return -ENOMEM;
 
 	if (offsetof(struct socinfo, serial_num) <= item_size) {


