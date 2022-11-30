Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423AE79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2EFC433D7;
	Wed, 30 Nov 2022 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833786;
	bh=HPphypBY4uY1rIxKcDmNvQVVeBl6fF5vcgXCR0pBTHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7OfNoUVDWAPFKSMU+T9WQ9banrhrNCFkRVYYHnOdIEMUi8356tZGIbTX/VyR7Ds9
	 jQKlDrRGN92TAel7d8GIxdwY4JMByqZ/kCaQN4fFmi9qWPWUJ3UaeD/1Wl406xzdD4
	 QVnNIbUv0iFv/Nd49cry23nywV69uacZyNnAb8PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	=?UTF-8?q?J=C3=BCrgen=20Christ?= <jchrist@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 014/289] s390/zcrypt: fix warning about field-spanning write
Date: Wed, 30 Nov 2022 19:19:59 +0100
Message-Id: <20221130180544.457078125@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit b43088f30db1a7bff61c8486238c195c77788d6d ]

This patch fixes the warning

memcpy: detected field-spanning write (size 60) of single field "to" at drivers/s390/crypto/zcrypt_api.h:173 (size 2)
WARNING: CPU: 1 PID: 2114 at drivers/s390/crypto/zcrypt_api.h:173 prep_ep11_ap_msg+0x2c6/0x2e0 [zcrypt]

The code has been rewritten to use a union in combination
with a flex array to clearly state which part of the buffer
the payload is to be copied in via z_copy_from_user
function (which may call memcpy() in case of in-kernel calls).

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Suggested-by: Jürgen Christ <jchrist@linux.ibm.com>
Reviewed-by: Jürgen Christ <jchrist@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_msgtype6.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index 8fb34b8eeb18..5ad251477593 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -342,7 +342,10 @@ static int xcrb_msg_to_type6cprb_msgx(bool userspace, struct ap_message *ap_msg,
 	};
 	struct {
 		struct type6_hdr hdr;
-		struct CPRBX cprbx;
+		union {
+			struct CPRBX cprbx;
+			DECLARE_FLEX_ARRAY(u8, userdata);
+		};
 	} __packed * msg = ap_msg->msg;
 
 	int rcblen = CEIL4(xcrb->request_control_blk_length);
@@ -403,7 +406,8 @@ static int xcrb_msg_to_type6cprb_msgx(bool userspace, struct ap_message *ap_msg,
 	msg->hdr.fromcardlen2 = xcrb->reply_data_length;
 
 	/* prepare CPRB */
-	if (z_copy_from_user(userspace, &msg->cprbx, xcrb->request_control_blk_addr,
+	if (z_copy_from_user(userspace, msg->userdata,
+			     xcrb->request_control_blk_addr,
 			     xcrb->request_control_blk_length))
 		return -EFAULT;
 	if (msg->cprbx.cprb_len + sizeof(msg->hdr.function_code) >
@@ -469,9 +473,14 @@ static int xcrb_msg_to_type6_ep11cprb_msgx(bool userspace, struct ap_message *ap
 
 	struct {
 		struct type6_hdr hdr;
-		struct ep11_cprb cprbx;
-		unsigned char	pld_tag;	/* fixed value 0x30 */
-		unsigned char	pld_lenfmt;	/* payload length format */
+		union {
+			struct {
+				struct ep11_cprb cprbx;
+				unsigned char pld_tag;    /* fixed value 0x30 */
+				unsigned char pld_lenfmt; /* length format */
+			} __packed;
+			DECLARE_FLEX_ARRAY(u8, userdata);
+		};
 	} __packed * msg = ap_msg->msg;
 
 	struct pld_hdr {
@@ -500,7 +509,7 @@ static int xcrb_msg_to_type6_ep11cprb_msgx(bool userspace, struct ap_message *ap
 	msg->hdr.fromcardlen1 = xcrb->resp_len;
 
 	/* Import CPRB data from the ioctl input parameter */
-	if (z_copy_from_user(userspace, &msg->cprbx.cprb_len,
+	if (z_copy_from_user(userspace, msg->userdata,
 			     (char __force __user *)xcrb->req, xcrb->req_len)) {
 		return -EFAULT;
 	}
-- 
2.35.1



