Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE489423788;
	Thu, 16 Jul 2026 14:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211287; cv=none; b=IrcNj6wto8lI+hldK7P+mf/jARX1E4pVUFaYHos7WsC7ICvDnvT0TSGuO7JgmSyHK2UdUOpxyaT0x+JQROrdWOE7fzpy4LG7HdEdR+4J1ekQF8rfUUVPwsjo0YxD3pva16IkybmNU1wSf52EtuQnaRw0B06AzDxqnJ3+NVEcNdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211287; c=relaxed/simple;
	bh=ynJefzAhfO5Hj16vJvaxs+DP4PR8CxhCVebP+7P664M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHc4JpFcxwtqtYhnEtd7POT7zO8g2BNh6qQpfLI+oDL3bMGTRNQSYXGM/MW+MDpxYd8Ug4TsXO8LQdblTaX8w2ZGRwrZ2x3IGfSV5oGD9jQwCzH7sLXMEmeXwaf7LFrteIyIvkWcamzdz9fHKriKZfgY8rzMsdJUOts8vC+vgxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWVCBf+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWVCBf+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6F01F000E9;
	Thu, 16 Jul 2026 14:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211285;
	bh=r64GzVUSgqQ4VUand99LT9NhHO6w+08rO/hDrt/q7Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWVCBf+Uz6Gu7l36/jyu0Alip0mxNEVX92XYVGLcLYVTc0dYBNahEQvoKGIBFVwQj
	 +vsHcWLW3OTw/qYqltsLgZunkRf5zSG21mjexBItegl/+LEN7CMTOCgc6Yl0UIT/aA
	 jQRyx6rQucAGO83imXFXgjj8YxQ8X/Z8jArnAll4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 368/480] crypto: qat - skip restart for down devices
Date: Thu, 16 Jul 2026 15:31:55 +0200
Message-ID: <20260716133052.766029955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -204,6 +207,9 @@ static pci_ers_result_t adf_slot_reset(s
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	if (!adf_devmgr_in_reset(accel_dev))
+		goto reset_complete;
+
 	pci_restore_state(pdev);
 	res = adf_dev_up(accel_dev, false);
 	if (res && res != -EALREADY)
@@ -213,6 +219,8 @@ static pci_ers_result_t adf_slot_reset(s
 	adf_pf2vf_notify_restarted(accel_dev);
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
+
+reset_complete:
 	return PCI_ERS_RESULT_RECOVERED;
 }
 


