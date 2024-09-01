Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF8517B50B;
	Sun,  1 Sep 2024 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208567; cv=none; b=CQlVZ8jz3OMK7xx8PJsvlpMr+f9/2ERDIHgCFVMjD8w1xejxZkL/p3evj/S4N5L1jXy8nb/RFGspn3KXSDn/L5QuLd8C1JRfRZLhXsIumT8Dq8YR7PotxU/kBhAjc/ZWw1uMRARi2NPg6B20PevGtPPzo5/AcDBW7Y+/iyjQZJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208567; c=relaxed/simple;
	bh=rdhjF2nEqR7BmRMsqpVE4+yqGD2VvCNyavsUKGyOmWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPuqwN+SXvaaWnCaa9HbXTg/14+go8rOC+y8mJA4NXVEa4LDEkYx6z7F3OlkYD5ooM9m7fX1mspdmwyxoCMCBJYfF5IqQpu8Fx+i8ZKdqe1RG1/HKMerKv8E4VJRw4qM/NVy/nGoztSnZOqJUCPBxzKGLCRVpmhJhsL2T3TuSGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rCdeaz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rCdeaz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAF1C4CEC3;
	Sun,  1 Sep 2024 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208567;
	bh=rdhjF2nEqR7BmRMsqpVE4+yqGD2VvCNyavsUKGyOmWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rCdeaz4suAUP4ZAVt8+JxkrX+hGnXNzQDhgimELqFx2ppE+j6Rrunnjdhp8all6J
	 wQrLNsXb0z39D+ekhScTu3xIGTHaGycGhXqmnB1bD8nwRi56Sx5gtTfLqEx0hLPv8f
	 H8hJxH1HoqPuiOm72l3ibrrsyep0FV5f5VG2G8+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murali Nalajala <quic_mnalajal@quicinc.com>,
	Unnathi Chalicheemala <quic_uchalich@quicinc.com>,
	Elliot Berman <quic_eberman@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 120/149] firmware: qcom: scm: Mark get_wq_ctx() as atomic call
Date: Sun,  1 Sep 2024 18:17:11 +0200
Message-ID: <20240901160821.967113754@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Murali Nalajala <quic_mnalajal@quicinc.com>

commit 9960085a3a82c58d3323c1c20b991db6045063b0 upstream.

Currently get_wq_ctx() is wrongly configured as a standard call. When two
SMC calls are in sleep and one SMC wakes up, it calls get_wq_ctx() to
resume the corresponding sleeping thread. But if get_wq_ctx() is
interrupted, goes to sleep and another SMC call is waiting to be allocated
a waitq context, it leads to a deadlock.

To avoid this get_wq_ctx() must be an atomic call and can't be a standard
SMC call. Hence mark get_wq_ctx() as a fast call.

Fixes: 6bf325992236 ("firmware: qcom: scm: Add wait-queue handling logic")
Cc: stable@vger.kernel.org
Signed-off-by: Murali Nalajala <quic_mnalajal@quicinc.com>
Signed-off-by: Unnathi Chalicheemala <quic_uchalich@quicinc.com>
Reviewed-by: Elliot Berman <quic_eberman@quicinc.com>
Link: https://lore.kernel.org/r/20240814223244.40081-1-quic_uchalich@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qcom/qcom_scm-smc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/qcom/qcom_scm-smc.c
+++ b/drivers/firmware/qcom/qcom_scm-smc.c
@@ -71,7 +71,7 @@ int scm_get_wq_ctx(u32 *wq_ctx, u32 *fla
 	struct arm_smccc_res get_wq_res;
 	struct arm_smccc_args get_wq_ctx = {0};
 
-	get_wq_ctx.args[0] = ARM_SMCCC_CALL_VAL(ARM_SMCCC_STD_CALL,
+	get_wq_ctx.args[0] = ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
 				ARM_SMCCC_SMC_64, ARM_SMCCC_OWNER_SIP,
 				SCM_SMC_FNID(QCOM_SCM_SVC_WAITQ, QCOM_SCM_WAITQ_GET_WQ_CTX));
 


