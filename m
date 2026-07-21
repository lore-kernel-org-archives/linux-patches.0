Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA81336888;
	Tue, 21 Jul 2026 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653942; cv=none; b=js3FCQRGS349E54cPdZ9EZVzflM0L5m8uS/Utzul8OtS4d8bNFv4nj3ROdAZRKO1sdogsFtdnrtOS1edqEcFGAxqKnZK5Y1Tnev7cJ/zLybjHUKKUMPLcvaQURipGTzOCvzRWG7wp/et5x9XhZa0qM+ErTJQUnF/BOyqvT9bJfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653942; c=relaxed/simple;
	bh=9duz80IUDjY3WjE/neXfcXx61Nf5mQarorxxkewRQ7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyvyy2aDKLav8cYEMhMKIbZZ42HN7fp/YKyVdSIBfNFmN5pGOtjfpiAmmmTfWYDv+t0dyaw9ZWvE0Ou3DKLNffVSW63THWQoYIwPVym8K6kG/PxOjHEFHTgdGBoK8V9vN/XHiCXFSAD50sM07WaEN5VMnm/U/Dl6ng4QOP3ieEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tl7DdEiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tl7DdEiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825081F000E9;
	Tue, 21 Jul 2026 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653941;
	bh=4s85C9qcGQPCLphuC1csleLgiwY1+SvShiRUIFa2B90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tl7DdEiT4rYYyM0MtamGh6sFsh+XrDNbp542zV8PsvAJe0tXEAFhgp5nbPBV6ByLf
	 BGsBE7w+zTeebMaFSO80ePOGZ31sYxV/HIf371TAkEOx7I0zqerNvSvoK2StmPO1YT
	 z3lRHrSOsJfH9Xn+lEnas9PiSxgHiXTTV4DmvhAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Przemyslaw Korba <przemyslaw.korba@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 7.1 1515/2077] idpf: add padding to PTP virtchnl structures
Date: Tue, 21 Jul 2026 17:19:48 +0200
Message-ID: <20260721152628.515986671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
 drivers/net/ethernet/intel/idpf/virtchnl2.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/idpf/virtchnl2.h
+++ b/drivers/net/ethernet/intel/idpf/virtchnl2.h
@@ -1572,13 +1572,15 @@ VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2
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
@@ -1586,26 +1588,30 @@ VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_
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


