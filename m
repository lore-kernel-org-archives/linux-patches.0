Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE544C10F0;
	Thu, 17 Sep 2026 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660978; cv=none; b=BARVwCSj0g/OnH4+Ohq+ioP7AouXUxDSflm7DM1zcCludwgGjjw43QqmfYTtj4cMaK1Ito0ThCRsie5g3ljRbb/EVCeYySMsk5B2MS+meMR4JH/GY2GxlCoGkF2M3A3JEojnr/t7RUH79TDbS3r29z3bK8sZNiZapHjiahPHw0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660978; c=relaxed/simple;
	bh=OFCJ21ISHrAqLdkxxxeWwQ69VWWGn9gEKGJ92tktl6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZAd3WX1bSyPHTnKJJtz8+k/nPZUEaD2z2K3RZZPcxtSB7qmLYsHUc1zSMAtMbrPHBzGbJxiEIgVgoDMIh/refVU9/ENhHLSzZ03FYbjSjXNaxGZYCkp2ZRsrt24Jg2kw86iY3FMK3EZO1xaBI7FKEio1XfTN0sMeEkuUNK9R4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YF6m8+t0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YF6m8+t0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69461F000FF;
	Thu, 17 Sep 2026 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660977;
	bh=hu2Jqu3xurdNw033g76Ke/GWVxJOoYckAFFYvY5HYLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YF6m8+t0zZIRnBukxeK8zxRF88LaYJvpAG5RZqXrYAHLF8KjmEzL16/BNmYu9ftwY
	 nEYsoUqFI+pBNtKl2vRlYPjUyBd409EAFgi9oSH+Zy7u0ZYMsTnjm70qbqdJFnqRfY
	 OUrnLiwBWNHI0HuOAwbeHvI9zIQcX5oF4Q3sIX+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gong <richard.gong@intel.com>,
	Siew Chin Lim <elly.siew.chin.lim@intel.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0042/1250] firmware: stratix10-svc: change get provision data to async SMC call
Date: Thu, 17 Sep 2026 15:57:17 +0100
Message-ID: <20260917151553.075464826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ba715c6eb32bf..d2bce209d2179 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -340,6 +340,7 @@ static void svc_thread_recv_status_ok(struct stratix10_svc_data *p_data,
 	case COMMAND_FCS_SEND_CERTIFICATE:
 	case COMMAND_FCS_DATA_ENCRYPTION:
 	case COMMAND_FCS_DATA_DECRYPTION:
+	case COMMAND_FCS_GET_PROVISION_DATA:
 		cb_data->status = BIT(SVC_STATUS_OK);
 		break;
 	case COMMAND_RECONFIG_DATA_SUBMIT:
@@ -366,7 +367,6 @@ static void svc_thread_recv_status_ok(struct stratix10_svc_data *p_data,
 		cb_data->kaddr2 = &res.a2;
 		break;
 	case COMMAND_FCS_RANDOM_NUMBER_GEN:
-	case COMMAND_FCS_GET_PROVISION_DATA:
 	case COMMAND_POLL_SERVICE_STATUS:
 		cb_data->status = BIT(SVC_STATUS_OK);
 		cb_data->kaddr1 = &res.a1;
@@ -533,7 +533,7 @@ static int svc_normal_to_secure_thread(void *data)
 			break;
 		case COMMAND_FCS_GET_PROVISION_DATA:
 			a0 = INTEL_SIP_SMC_FCS_GET_PROVISION_DATA;
-			a1 = (unsigned long)pdata->paddr;
+			a1 = 0;
 			a2 = 0;
 			break;
 
diff --git a/include/linux/firmware/intel/stratix10-smc.h b/include/linux/firmware/intel/stratix10-smc.h
index ee80ca4bb0d0c..1e60fd6210c3b 100644
--- a/include/linux/firmware/intel/stratix10-smc.h
+++ b/include/linux/firmware/intel/stratix10-smc.h
@@ -600,24 +600,20 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
 
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



