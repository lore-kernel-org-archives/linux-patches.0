Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111654FD796;
	Thu, 17 Sep 2026 17:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667239; cv=none; b=UMJMPP6VA8mm7+6+/yLyEXUFzd3Y5L7KN88rt2Lcp8RmThZ3v//z0I7frt7QfPAd25kzq8OeRpi+52LLB+L3dd9ZyY8CP7iHhITQW2kK96m3CjULAoFoAuz2DfawGCkv2To4oh8f8PLArEC/mde71aYCDBilcy+IPQwxt+X9b8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667239; c=relaxed/simple;
	bh=KptsYjfzuxqsG/KJ6ubWvBbwda7BIwnjMTBPyDD9AQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYoJs6UiJ+xE85YO0SVb5p1inPUppIdaUjPlEkXTYzgTv37DOf8+Y9A/KZHAZH3WTS8rclzSJWr/4MnAcYimX/KZ0L/D4nQNwU0RwYWDTyVCosRCKz3VUyJn2HAcVhZTUnKlCTo1HK12pRhCiunJzlauNfGT5NoDyGGOjk4mE74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dF4NAMq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dF4NAMq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A461F000FF;
	Thu, 17 Sep 2026 17:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667237;
	bh=1sYE1EuUtQigWNWHhNEhNyR2SxegjTxbcC/D+AuSxX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dF4NAMq3ahGPqgJrWa/JSapoQ4RxWXNvaBo5wSYebPsNkXTaKJYr3oocDMmVii50Q
	 eZLVjcmtULJlhrn6N/2UUw+lDaxV7b124+LLIMwkjPb3M+pBzHN0GcnVULejdj1oA7
	 Nxygbs84oscejtf1Humuo5hgOuni1iQss2aSDqjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gong <richard.gong@intel.com>,
	Siew Chin Lim <elly.siew.chin.lim@intel.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0026/1102] firmware: stratix10-svc: change get provision data to async SMC call
Date: Thu, 17 Sep 2026 15:59:29 +0100
Message-ID: <20260917151540.093107392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 2d02f3f0b9338..48379a4bb93ef 100644
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



