Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A57361963;
	Thu, 20 Aug 2026 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238326; cv=none; b=mQ46V8XmuxBJfLUHMrWMBSAD9YVFFp/NQ61ZWz2OV7bell4vCl/INsZll3WkRj+L6acPWbv/NcZ+hRkaK/RtRBdchlb2p3RTxIRxy+g7uRu9ci4fNG95gfaCwID/xX+feo/plJOaeZsAd/PsMfe1wuiVB8IAW4tJ5TZlJCl0lus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238326; c=relaxed/simple;
	bh=Hpl/IKHzZBoj9TXGKCLVKT98JRgeylftLEFT9yGPRGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk8wWK0Zwqli7cvtGtuBhqoRsO8scMg3PtFnXwdFUupj0HSyLSf/nw2iEg+ENOB4tBy29JpXLCsqdn/nk3vItSiRVmPC6BBEWQRSOs3z0lO06as7LEra6Ie5+nLS1YuS1yItJp0PrfcDRpDtKrLwh/rMdAI3t60/LDY2tTHWSwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1qFD+Sk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1qFD+Sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468321F00A3A;
	Thu, 20 Aug 2026 15:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238324;
	bh=uYgJC6IKTNm7DVFmn0ymMe/L0GarTVL5dmsA9tMg2Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1qFD+SkIJEybnrpWnIF/OEmPbsSDlORmb57KsGJHlR50TfDY++mv4oecaU2JC89t
	 Wl3b+ll704bf5k6HMEbTa/07wMt9r207ldcifiI2CH+/pI4Q+igqZ03ORbBdizZmVl
	 sJnnmFJzdX4d9ZNYzVd3llOQ5z2FmD6jLxxTYWLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 109/228] s390/zcrypt: Pad trailing CCA or EP11 message with zeros
Date: Thu, 20 Aug 2026 16:54:11 +0200
Message-ID: <20260820145247.951193979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

commit eb363254472493e3458156fc11fd56dca92f4333 upstream.

The both functions xcrb_msg_to_type6cprb_msgx() and
xcrb_msg_to_type6_ep11cprb_msgx() copy the user space message into a
kernel buffer based on the message length. But on further processing
the message is supposed to be 4 byte length adjusted. Thus up to 3
bytes of uninitialized kernel memory are forwarded to further
processing steps and may unwanted expose kernel memory to the crypto
card firmware.

This patch contains code to pad the gap between user space copied
message and message buffer length sent down to further processing of
the CCA or EP11 message to zeros.

Fixes: e2c6d91eb8b1 ("s390/zcrypt: Rework domain processing within zcrypt device driver")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 7.1+
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_msgtype6.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index e79e68b4dd41..3df1d676de5d 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -398,6 +398,10 @@ static int xcrb_msg_to_type6cprb_msgx(bool userspace, struct ap_message *ap_msg,
 			     xcrb->request_control_blk_addr,
 			     xcrb->request_control_blk_length))
 		return -EFAULT;
+	/* pad tail with 0 up to req_cblen */
+	if (xcrb->request_control_blk_length < req_cblen)
+		memset(msg->userdata + xcrb->request_control_blk_length,
+		       0, req_cblen - xcrb->request_control_blk_length);
 	/* copy subfunction code into AP msg type 6 function code field */
 	if (msg->cprbx.cprb_len > req_cblen - sizeof(msg->hdr.function_code))
 		return -EINVAL;
@@ -542,6 +546,10 @@ static int xcrb_msg_to_type6_ep11cprb_msgx(bool userspace, struct ap_message *ap
 	if (z_copy_from_user(userspace, msg->userdata,
 			     (char __force __user *)xcrb->req, xcrb->req_len))
 		return -EFAULT;
+	/* pad tail with 0 up to req_len */
+	if (xcrb->req_len < req_len)
+		memset(msg->userdata + xcrb->req_len, 0,
+		       req_len - xcrb->req_len);
 
 	pld = msg->userdata + sizeof(struct ep11_cprb);
 	pld_len = msg->cprbx.payload_len;
-- 
2.55.0



