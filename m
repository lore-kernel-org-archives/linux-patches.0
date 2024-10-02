Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EA325771;
	Wed,  2 Oct 2024 13:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875179; cv=none; b=fWW/FhB0KEJm7QzZ8h+eFznac0I5fTHkPsTtgE+0a2hHwzPJHixYhsmWX8mBGD2jwpwbYZgQuvawJ0haBSsurJaPa3S967ZVmvS5J3dk7v0LUSwxh7nHGWfL0wWWNGmJ1SBzU1LHqIT1MSi2tJyiexxUOpVNScQky6JvcJYDFoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875179; c=relaxed/simple;
	bh=Q96vyJS33J4Sv3USQiJVbMCBnWS74VdgpObP61L6eZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reD68FeWGJrseBnIMGOEdwUlHcJOkMd6Lv7QeN4YuDxIuHSFHjFLv34vDtSd8KsP/RWqmjE9ulyfSlz4/BLlQocEhGRq4eb5T39OTqTmTO+fPE8hlWPHrwWsy+SrH/A3AT3Ma25ZgU1AiUi00Iv7P01KTuVk8yLBKLx5z+GPDiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VW3WDqbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VW3WDqbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0066C4CEC5;
	Wed,  2 Oct 2024 13:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875179;
	bh=Q96vyJS33J4Sv3USQiJVbMCBnWS74VdgpObP61L6eZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VW3WDqbq5zgv3aAj0xJKiHPi7vhTwJXFUwK/EtjkbBRyiJiGpSP20Oe78DCm6qzzv
	 qUm77UT58CvTai1f+R/6cieNDj0/w61QoJ1MRyz55Fle0vfcZkSQCxddUyMhxlC+44
	 l56/27mP/Fin9qlPgYSp012t9iWTa3ZfalHGHLig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Witwicki <michal.witwicki@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 006/695] crypto: qat - fix recovery flow for VFs
Date: Wed,  2 Oct 2024 14:50:04 +0200
Message-ID: <20241002125822.738595676@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Witwicki <michal.witwicki@intel.com>

[ Upstream commit 6f1b5236348fced7e7691a933327694b4106bc39 ]

When the PFVF protocol was updated to support version 5, i.e.
ADF_PFVF_COMPAT_FALLBACK, the compatibility version for the VF was
updated without supporting the message RESTARTING_COMPLETE required for
such version.

Add support for the ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE message in the
VF drivers. This message is sent by the VF driver to the PF to notify
the completion of the shutdown flow.

Fixes: ec26f8e6c784 ("crypto: qat - update PFVF protocol for recovery")
Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c  | 14 ++++++++++++++
 .../crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h  |  1 +
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c   |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c
index 1141258db4b65..10c91e56d6be3 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c
@@ -48,6 +48,20 @@ void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
 
+void adf_vf2pf_notify_restart_complete(struct adf_accel_dev *accel_dev)
+{
+	struct pfvf_message msg = { .type = ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE };
+
+	/* Check compatibility version */
+	if (accel_dev->vf.pf_compat_ver < ADF_PFVF_COMPAT_FALLBACK)
+		return;
+
+	if (adf_send_vf2pf_msg(accel_dev, msg))
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send Restarting complete event to PF\n");
+}
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_restart_complete);
+
 int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 {
 	u8 pf_version;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h
index 71bc0e3f1d933..d79340ab3134f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h
@@ -6,6 +6,7 @@
 #if defined(CONFIG_PCI_IOV)
 int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
 void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
+void adf_vf2pf_notify_restart_complete(struct adf_accel_dev *accel_dev);
 int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev);
 int adf_vf2pf_get_capabilities(struct adf_accel_dev *accel_dev);
 int adf_vf2pf_get_ring_to_svc(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
index cdbb2d687b1b0..4ab9ac3315195 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
@@ -13,6 +13,7 @@
 #include "adf_cfg.h"
 #include "adf_cfg_strings.h"
 #include "adf_cfg_common.h"
+#include "adf_pfvf_vf_msg.h"
 #include "adf_transport_access_macros.h"
 #include "adf_transport_internal.h"
 
@@ -75,6 +76,7 @@ static void adf_dev_stop_async(struct work_struct *work)
 
 	/* Re-enable PF2VF interrupts */
 	adf_enable_pf2vf_interrupts(accel_dev);
+	adf_vf2pf_notify_restart_complete(accel_dev);
 	kfree(stop_data);
 }
 
-- 
2.43.0



