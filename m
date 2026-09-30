Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EDC4F402F;
	Wed, 30 Sep 2026 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784038; cv=none; b=EfZQcaI//1rpldaHKj8OuhTqH9iE2IJHK2Q6rp7pzKnfNocTb8R7o0PxBviodO2AptAeqN/flqrnwMtQwUj4iFh/7ZL+LrCUT0IYVy4WGArmrixKXDRxe7tE2SeiglJa7QtXRLhgQkjAxk+pGumLfIqsYbjb8IXRSiwprDE9hi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784038; c=relaxed/simple;
	bh=gfrPe8F/pbPoWcfu84d42WWLuesAmytAvFa7lJQpr9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpXKmx6NOiC3ujY/a69BGTFCfbW7iTac4z1fu2/ThgdEEuEl9lARHSOG4QmSH+6UBGNfY/wWOULKRmZGWE+9rUktQAIq/3MOF2Fygj2Mv4IdJpJOkON5wnFJR/ynb9nzTA/Lp61fdzo3E0LuYuJe3qXjIgExKfScchtpcijngqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HbDXO8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HbDXO8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D972A1F000FF;
	Wed, 30 Sep 2026 16:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784031;
	bh=hKM5/n7/l2NjynkTCapGFY9As9h3s/zrx2xx2NWWlIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1HbDXO8wExfSe1hBBTdiygMbbv6kxxQw6u3rVeJxr3Mt5CbCUW7CGC4SE6K6zGPd0
	 NE18kSg7WcOXkaYhKIzDjrZWif8IvQOUPQMzkNvXBVW6MIOsw/BFBC22WjLkPE+Yc/
	 RfROI95odO2bbeZGLUHtoLK8zb1KUSngwel8pQIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gong <richard.gong@intel.com>,
	Siew Chin Lim <elly.siew.chin.lim@intel.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/982] firmware: stratix10-svc: change get provision data to async SMC call
Date: Wed, 30 Sep 2026 17:12:29 +0200
Message-ID: <20260930152417.072451551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siew Chin Lim <elly.siew.chin.lim@intel.com>

[ Upstream commit 4b0a32016347bfd6ae9849f21b1b767905f68d14 ]

Change INTEL_SIP_SMC_FCS_GET_PROVISION_DATA's SMC call to async from sync
to avoid long runtime which may cause the watchdog timeout issue.

Signed-off-by: Richard Gong <richard.gong@intel.com>
Signed-off-by: Siew Chin Lim <elly.siew.chin.lim@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c             |  4 ++--
 include/linux/firmware/intel/stratix10-smc.h | 12 ++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index c4a709f2bbc7a..5966f09e73fc7 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -339,6 +339,7 @@ static void svc_thread_recv_status_ok(struct stratix10_svc_data *p_data,
 	case COMMAND_FCS_SEND_CERTIFICATE:
 	case COMMAND_FCS_DATA_ENCRYPTION:
 	case COMMAND_FCS_DATA_DECRYPTION:
+	case COMMAND_FCS_GET_PROVISION_DATA:
 		cb_data->status = BIT(SVC_STATUS_OK);
 		break;
 	case COMMAND_RECONFIG_DATA_SUBMIT:
@@ -365,7 +366,6 @@ static void svc_thread_recv_status_ok(struct stratix10_svc_data *p_data,
 		cb_data->kaddr2 = &res.a2;
 		break;
 	case COMMAND_FCS_RANDOM_NUMBER_GEN:
-	case COMMAND_FCS_GET_PROVISION_DATA:
 	case COMMAND_POLL_SERVICE_STATUS:
 		cb_data->status = BIT(SVC_STATUS_OK);
 		cb_data->kaddr1 = &res.a1;
@@ -525,7 +525,7 @@ static int svc_normal_to_secure_thread(void *data)
 			break;
 		case COMMAND_FCS_GET_PROVISION_DATA:
 			a0 = INTEL_SIP_SMC_FCS_GET_PROVISION_DATA;
-			a1 = (unsigned long)pdata->paddr;
+			a1 = 0;
 			a2 = 0;
 			break;
 
diff --git a/include/linux/firmware/intel/stratix10-smc.h b/include/linux/firmware/intel/stratix10-smc.h
index a718f853d4578..4ae295c4e9cc1 100644
--- a/include/linux/firmware/intel/stratix10-smc.h
+++ b/include/linux/firmware/intel/stratix10-smc.h
@@ -575,24 +575,20 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
 
 /**
  * Request INTEL_SIP_SMC_FCS_GET_PROVISION_DATA
- * Sync call to dump all the fuses and key hashes
+ * Async call to dump all the fuses and key hashes
  *
  * Call register usage:
  * a0 INTEL_SIP_SMC_FCS_GET_PROVISION_DATA
- * a1 the physical address for firmware to write structure of fuse and
- *    key hashes
- * a2-a7 not used
+ * a1-a7 not used
  *
  * Return status:
  * a0 INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_FCS_ERROR or
  *      INTEL_SIP_SMC_FCS_REJECTED
- * a1 mailbox error
- * a2 physical address for the structure of fuse and key hashes
- * a3 the size of structure
+ * a1-a3 not used
  *
  */
 #define INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA 94
 #define INTEL_SIP_SMC_FCS_GET_PROVISION_DATA \
-	INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA)
+	INTEL_SIP_SMC_STD_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA)
 
 #endif
-- 
2.53.0



