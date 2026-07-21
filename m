Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F3D38399A;
	Tue, 21 Jul 2026 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658313; cv=none; b=RbKWLAo10dnyTou7E2+am1+Qu9+5y6cwVgDAF17FyAvlPMAbODBrWozT2/iGUPxnISKj76BBZezjYfvkQi/SkE0ffVFdOWSesjAIE3reGJ1BFHIzyvHYVvtwJegz/2cgE+2NAqL64t/dreIhDb46bD4VXtXoEkznExWhXlySL34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658313; c=relaxed/simple;
	bh=j/gU4i2rF0oemecDcrO1dGh+aAq+uU+RRZcjzc2iR3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/lAv/s8sErlk4VlD0QznoNu/RrTHCxFJLd+0NHnkrIxnpHXs9mnJpON6PXM8AHZATL+pS3Gk7Y73E54eko64D6hB25LMOxzVlHpv3i3ca+YleUDDNsiwuJ+VtAGZnCzHbnBmhZhrsmtWsGlKZ+7O2jmVaXf/I7MRLWzN5OFcx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiuX6+EI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiuX6+EI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766FB1F000E9;
	Tue, 21 Jul 2026 18:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658312;
	bh=AaiZPqCUXHLW7WY/Ptim5JuO7doNOn9EWJROWMcz1PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiuX6+EIIDGmVzJXnKRKUC5SgxRaWp5U3Lqx1MaAwUcWSlizpMNXMJ/J6fAICA4VX
	 hnNdUUXSWvDW5EZp3L0FJ6NE8r4vhwD5DwrGC9Q42bD5dk/iBhxVvO3bq3zgtK8pPj
	 H80/8CRCGCW2qbj1jiqps7/pftOKjUdZBvaocN/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Przemyslaw Korba <przemyslaw.korba@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.18 1095/1611] idpf: add padding to PTP virtchnl structures
Date: Tue, 21 Jul 2026 17:20:11 +0200
Message-ID: <20260721152540.047475901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Przemyslaw Korba <przemyslaw.korba@intel.com>

commit d1e8f9fd6b98307bc8d2863c7baa465d8a5a43be upstream.

Add padding to virtchnl2 PTP structures to match the Control Plane
expected message sizes:
* virtchnl2_ptp_get_dev_clk_time: 8 -> 16 bytes
* virtchnl2_ptp_set_dev_clk_time: 8 -> 16 bytes
* virtchnl2_ptp_get_cross_time: 16 -> 24 bytes

The FW expects the above sizes and PTP negotiation fails due to the
mismatch. Previously neither the FW nor the driver checked message/reply
sizes strictly, so the problem appeared only after recent validation
improvements.

reproduction steps:
ptp4l -i <pf> -m
Observe: failed to open /dev/ptp0: Permission denied

Fixes: bf27283ba594 ("virtchnl: add PTP virtchnl definitions")
Cc: stable@vger.kernel.org
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Przemyslaw Korba <przemyslaw.korba@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/virtchnl2.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/virtchnl2.h b/drivers/net/ethernet/intel/idpf/virtchnl2.h
index 02ae447cc24a..39fea65c075c 100644
--- a/drivers/net/ethernet/intel/idpf/virtchnl2.h
+++ b/drivers/net/ethernet/intel/idpf/virtchnl2.h
@@ -1572,13 +1572,15 @@ VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_ptp_get_vport_tx_tstamp_latches);
  * struct virtchnl2_ptp_get_dev_clk_time - Associated with message
  *					   VIRTCHNL2_OP_PTP_GET_DEV_CLK_TIME.
  * @dev_time_ns: Device clock time value in nanoseconds
+ * @pad: Padding for future extensions
  *
  * PF/VF sends this message to receive the time from the main timer.
  */
 struct virtchnl2_ptp_get_dev_clk_time {
 	__le64 dev_time_ns;
+	u8 pad[8];
 };
-VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_ptp_get_dev_clk_time);
+VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_ptp_get_dev_clk_time);
 
 /**
  * struct virtchnl2_ptp_get_cross_time: Associated with message
@@ -1586,26 +1588,30 @@ VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_ptp_get_dev_clk_time);
  * @sys_time_ns: System counter value expressed in nanoseconds, read
  *		 synchronously with device time
  * @dev_time_ns: Device clock time value expressed in nanoseconds
+ * @pad: Padding for future extensions
  *
  * PF/VF sends this message to receive the cross time.
  */
 struct virtchnl2_ptp_get_cross_time {
 	__le64 sys_time_ns;
 	__le64 dev_time_ns;
+	u8 pad[8];
 };
-VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_ptp_get_cross_time);
+VIRTCHNL2_CHECK_STRUCT_LEN(24, virtchnl2_ptp_get_cross_time);
 
 /**
  * struct virtchnl2_ptp_set_dev_clk_time: Associated with message
  *					  VIRTCHNL2_OP_PTP_SET_DEV_CLK_TIME.
  * @dev_time_ns: Device time value expressed in nanoseconds to set
+ * @pad: Padding for future extensions
  *
  * PF/VF sends this message to set the time of the main timer.
  */
 struct virtchnl2_ptp_set_dev_clk_time {
 	__le64 dev_time_ns;
+	u8 pad[8];
 };
-VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_ptp_set_dev_clk_time);
+VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_ptp_set_dev_clk_time);
 
 /**
  * struct virtchnl2_ptp_adj_dev_clk_fine: Associated with message
-- 
2.55.0



