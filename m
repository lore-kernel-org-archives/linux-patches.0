Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EEC3D9DA7;
	Thu, 16 Jul 2026 13:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209970; cv=none; b=ZXsUp4bvXeksWNOtPXaIQ6tl3Z4FnKosRBrkP4svkV+D3VYV7AX/7CpDUGgKSKSd+t23OiURZFIkPqqT+OOwU/ag2o9P5XZAAuuJ1WUB2mYWbW21QP7DJr5o+j2BPVSdAUV/GFT8eHJkvqFCQ/6fhg7L8IK29vOo3dnyQJbW23M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209970; c=relaxed/simple;
	bh=fztJeWAs6uLK6J3Ewwi0eimG2gm72mc7MKQiDzJhnxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/W5/Nd3gcBxZ5h5ss0u6CHl+io0HOt55kN/3JfcQSeTuZfM5l6ofRqh6wpNasmhYIf3YU0m04rnvOqiB/ZebqH0mJhYiQBd+Hd0fgSP/eamb6T8DSaFi91zVp6bRq90fKQTN0/KGmvqTUWYavVHffV1eDf+089SslLq39jkzIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ln7kiH09; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ln7kiH09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146AA1F00A3F;
	Thu, 16 Jul 2026 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209967;
	bh=jDAyfVdHhRKvDHoFZnaS5Hs9T8z+zLC1SwFDklEh07g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ln7kiH09EHCJ2aZvW8jeFJZwz/xcmlfFq0kYvhtbUt++yLSjkm91hyxbJOQr3HBJu
	 e746hqSwnpYHV6/vyZI/pH8e/4iA7+FQ5hVwG07ehfwonrpnzWeQ+STmTnjs0V9uHJ
	 NzNfoAWIFi88svVX/v76EuSVcse1MZEXAF9kGrXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 386/518] crypto: qat - skip restart for down devices
Date: Thu, 16 Jul 2026 15:30:54 +0200
Message-ID: <20260716133056.277444026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

commit 9676657117b79f88c22875680c36d7da84b75eca upstream.

Skip the shutdown and restart flow when adf_slot_reset() is entered
for a device that is already down. In that case, leave
ADF_STATUS_RESTARTING clear and let adf_slot_reset() restore PCI
function state without calling adf_dev_up(), re-enabling SR-IOV, or
sending restarted notifications.

This is in preparation for adding reset_prepare() and reset_done()
callbacks in adf_aer.c.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -33,6 +33,9 @@ static pci_ers_result_t adf_error_detect
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	if (!adf_dev_started(accel_dev))
+		return PCI_ERS_RESULT_CAN_RECOVER;
+
 	adf_error_notifier(accel_dev);
 	adf_pf2vf_notify_fatal_error(accel_dev);
 	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
@@ -205,6 +208,9 @@ static pci_ers_result_t adf_slot_reset(s
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	if (!adf_devmgr_in_reset(accel_dev))
+		goto reset_complete;
+
 	pci_restore_state(pdev);
 	res = adf_dev_up(accel_dev, false);
 	if (res && res != -EALREADY)
@@ -214,6 +220,8 @@ static pci_ers_result_t adf_slot_reset(s
 	adf_pf2vf_notify_restarted(accel_dev);
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
+
+reset_complete:
 	return PCI_ERS_RESULT_RECOVERED;
 }
 


