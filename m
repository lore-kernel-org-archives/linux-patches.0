Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7D94EF15A;
	Tue, 13 Oct 2026 12:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894604; cv=none; b=jI8IZT88CLH7EJ0pAg45+XPgMnwhJQZms0vSNwlQtlYZD6Xw9ViO2viZaqpvxFLm9e/iumiR+9pEpAlERM1SOCyHoFQKV1JrbS++7Rmxi1+kkAhGuKpYQLTOVgjEKmOTiSqQst7tVeiF+x2eStM/o2jUY95zNTYuu8+syUNBdSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894604; c=relaxed/simple;
	bh=MeT4p62Vg3W5rEOMLU5gGEQ/qWtpbUn23PWoxTiRh9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/XEsjAVbCkuDY1zq9eQOxrDT+t8ymUimiQpuEcoQfbWPuf3xifAcVlTxulVazat1CO0+jGlbKVd7ZcTt0uf1CNTq8cFuoDa6T5UgoFFQ6fr0rGL4DLXuNQM/7xBuK05bmPJ9e79QmuvvIaMsD0pspKkzCVCTYJh3LbGyjN/AXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL3PmDik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL3PmDik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B871F00893;
	Tue, 13 Oct 2026 12:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894603;
	bh=C86D0YeBf+bWlF8ovWGmDGxZVo9faZXFQYyj64qSZ6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KL3PmDikS/2s9m/RH0h+W6EMI42as2VccegFKpIgz0iFeqIfrwGs80HYafxmL6BEp
	 FHOWNwnTPNpAgb6/MXYy4OzVVHlcxvTFPIwWfhx6up2Sh8ZuNjNvqz1BahVF+c2A+I
	 Yw6KOZK0LM8OuPL4gLwZXQnRyN7UZVEOOIfq0qzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 615/621] s390/zcrypt: Pad trailing CCA or EP11 message with zeros
Date: Tue, 13 Oct 2026 13:40:10 +0200
Message-ID: <20261013112935.394530370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
 drivers/s390/crypto/zcrypt_msgtype6.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -399,6 +399,10 @@ static int xcrb_msg_to_type6cprb_msgx(bo
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
@@ -544,6 +548,10 @@ static int xcrb_msg_to_type6_ep11cprb_ms
 	if (z_copy_from_user(userspace, msg->userdata,
 			     (char __force __user *)xcrb->req, xcrb->req_len))
 		return -EFAULT;
+	/* pad tail with 0 up to req_len */
+	if (xcrb->req_len < req_len)
+		memset(msg->userdata + xcrb->req_len, 0,
+		       req_len - xcrb->req_len);
 
 	pld = msg->userdata + sizeof(struct ep11_cprb);
 	pld_len = msg->cprbx.payload_len;


