Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EF4198837;
	Wed,  2 Oct 2024 13:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877294; cv=none; b=Y+xsLNQwVYO4VTlrsk9+AgwAB+LgLZBzEotNJlBXKRpFC0a1+nqS1j8Q506laLIZyzLqNJJRyN1nyGk9iG83DXzkwRwnK2K1jBxJhs17cKHXC7Rv6xmYa4Gl2BrLToNMLNnDA7xiC1WwYa1j3iDkUD/qydkKKok7oxt4m+Pn+bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877294; c=relaxed/simple;
	bh=V78L07ICWDgBdIWxMGj/4X3Tj6tuIReOBlWewhtCcWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwwsYlzkRSAM2IdZvzeWXW0C/ibw6+4C9u4Sr8BCgCELNUQk/7MqvVZRCxyDOSM99pQUNA/8l//WUcGBle6RNWwtxOorExrMtNLSZ61/3oMV3T88VZkQsrcGspFLDLryfgcOCTR/l1h+yw0T329wYnILwjmrqinPHjCNJQ26dNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEyAvYJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEyAvYJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4B7C4CED2;
	Wed,  2 Oct 2024 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877294;
	bh=V78L07ICWDgBdIWxMGj/4X3Tj6tuIReOBlWewhtCcWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEyAvYJ5GfWrtVIY18FUZ87RXohtsh2eJM++QjwU52C/jX1esm7Wd6pK8S63XDiH5
	 OweXL9v1NsL5fTs5vIMQFbx5xb3K3Yme65p3jeP5Zi8PCqFKywYb+LTQKND2ejTv+M
	 pf/icDU9vEFjo7bmjE3bg90vlOXgbptR0zj2vr74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Witwicki <michal.witwicki@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 006/634] crypto: qat - fix recovery flow for VFs
Date: Wed,  2 Oct 2024 14:51:46 +0200
Message-ID: <20241002125811.339538274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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



