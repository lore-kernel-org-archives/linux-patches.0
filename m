Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A8E1AB521;
	Mon, 14 Oct 2024 14:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916523; cv=none; b=Woxr/yZweVl3EzKAu65uqivKjcnVdDzLEngCtJupJpgl9Xv5WumGP+RkQ0r1K3p/UpnD0a3f2nPeirsfcAJZtu79tE00TP39kXcqzyzwRvu1pzay/Ij31HFsMAXiS7pxoBwb0cNWzzvrEaLgiuqF7mApPT0TPFYatPWYY1KdPMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916523; c=relaxed/simple;
	bh=Xw/qqwP1aQ0aGkmuMmvWt+UNtwW/Y5f+3aONLg4seSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8bl64/pagVC7fvGjRJNKo+AbcE24tIER1/pimBroPLqtVslUkFq9FrJj6VI1Vy4q6JwLM/Qnj+L1y27iyVHG4lS1v8UCkygBK9Qcv1RbHagCmMSyHace4hoqqLXZR5FlWEQMI4Ah/L+uB2INXP6U932NnYHGm3uYaXQnqaE3vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxGSDQfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxGSDQfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B69EC4CEC7;
	Mon, 14 Oct 2024 14:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916522;
	bh=Xw/qqwP1aQ0aGkmuMmvWt+UNtwW/Y5f+3aONLg4seSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxGSDQfPKUYDdD8NY8yynk9KvXFjWf4rbdPey/gPYcbASP26WQ0R/D5XHvM1ElgnA
	 ye2+4vfqa/6PD4xvkMNXXQABdDvKLETHdasKs1dN1mfQ1Di0ODNBIOV7k+c7TfW15h
	 l8fTxAUZN3ycTIFTWwPyLd05uvH+544NLv51LhGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hay <joshua.a.hay@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.11 209/214] idpf: use actual mbx receive payload length
Date: Mon, 14 Oct 2024 16:21:12 +0200
Message-ID: <20241014141053.133177429@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Joshua Hay <joshua.a.hay@intel.com>

commit 640f70063e6d3a76a63f57e130fba43ba8c7e980 upstream.

When a mailbox message is received, the driver is checking for a non 0
datalen in the controlq descriptor. If it is valid, the payload is
attached to the ctlq message to give to the upper layer.  However, the
payload response size given to the upper layer was taken from the buffer
metadata which is _always_ the max buffer size. This meant the API was
returning 4K as the payload size for all messages.  This went unnoticed
since the virtchnl exchange response logic was checking for a response
size less than 0 (error), not less than exact size, or not greater than
or equal to the max mailbox buffer size (4K). All of these checks will
pass in the success case since the size provided is always 4K. However,
this breaks anyone that wants to validate the exact response size.

Fetch the actual payload length from the value provided in the
descriptor data_len field (instead of the buffer metadata).

Unfortunately, this means we lose some extra error parsing for variable
sized virtchnl responses such as create vport and get ptypes.  However,
the original checks weren't really helping anyways since the size was
_always_ 4K.

Fixes: 34c21fa894a1 ("idpf: implement virtchnl transaction manager")
Cc: stable@vger.kernel.org # 6.9+
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -666,7 +666,7 @@ idpf_vc_xn_forward_reply(struct idpf_ada
 
 	if (ctlq_msg->data_len) {
 		payload = ctlq_msg->ctx.indirect.payload->va;
-		payload_size = ctlq_msg->ctx.indirect.payload->size;
+		payload_size = ctlq_msg->data_len;
 	}
 
 	xn->reply_sz = payload_size;
@@ -1295,10 +1295,6 @@ int idpf_send_create_vport_msg(struct id
 		err = reply_sz;
 		goto free_vport_params;
 	}
-	if (reply_sz < IDPF_CTLQ_MAX_BUF_LEN) {
-		err = -EIO;
-		goto free_vport_params;
-	}
 
 	return 0;
 
@@ -2602,9 +2598,6 @@ int idpf_send_get_rx_ptype_msg(struct id
 		if (reply_sz < 0)
 			return reply_sz;
 
-		if (reply_sz < IDPF_CTLQ_MAX_BUF_LEN)
-			return -EIO;
-
 		ptypes_recvd += le16_to_cpu(ptype_info->num_ptypes);
 		if (ptypes_recvd > max_ptype)
 			return -EINVAL;


