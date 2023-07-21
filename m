Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B1A1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77651C433C7;
	Fri, 21 Jul 2023 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956327;
	bh=w155Hvn/2jsu48FrQ/tdj1LWsx9B19JPlxXZUhgNfIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpjH07u2Yfe1ouSDmBEnf0u/9sHkVv3w4K27VkR8Mq/jBNPd+MvQGAJsdZK+AC4z6
	 aSE7ywIvlW3CsNknAFnTxkaFNMoLhKWtvObULZhMRZBXQvbxPSA8GnnFrlmveoLiXq
	 frbYpWxhUzBj71AyN15CKZH5avkKO2fmvYPKygKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Uhlig <Frank.Uhlig1@ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.4 168/292] s390/zcrypt: do not retry administrative requests
Date: Fri, 21 Jul 2023 18:04:37 +0200
Message-ID: <20230721160536.127145559@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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

commit af40322e90d4e0093569eceb7d3a28ab635f3e75 upstream.

All kind of administrative requests should not been retried. Some card
firmware detects this and assumes a replay attack. This patch checks
on failure if the low level functions indicate a retry (EAGAIN) and
checks for the ADMIN flag set on the request message.  If this both
are true, the response code for this message is changed to EIO to make
sure the zcrypt API layer does not attempt to retry the request. As of
now the ADMIN flag is set for a request message when
- for EP11 the field 'flags' of the EP11 CPRB struct has the leftmost
  bit set.
- for CCA when the CPRB minor version is 'T3', 'T5', 'T6' or 'T7'.

Please note that the do-not-retry only applies to a request
which has been sent to the card (= has been successfully enqueued) but
the reply indicates some kind of failure and by default it would be
replied. It is totally fine to retry a request if a previous attempt
to enqueue the msg into the firmware queue had some kind of failure
and thus the card has never seen this request.

Reported-by: Frank Uhlig <Frank.Uhlig1@ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_msgtype6.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -1143,6 +1143,9 @@ static long zcrypt_msgtype6_send_cprb(bo
 		ap_cancel_message(zq->queue, ap_msg);
 	}
 
+	if (rc == -EAGAIN && ap_msg->flags & AP_MSG_FLAG_ADMIN)
+		rc = -EIO; /* do not retry administrative requests */
+
 out:
 	if (rc)
 		ZCRYPT_DBF_DBG("%s send cprb at dev=%02x.%04x rc=%d\n",
@@ -1263,6 +1266,9 @@ static long zcrypt_msgtype6_send_ep11_cp
 		ap_cancel_message(zq->queue, ap_msg);
 	}
 
+	if (rc == -EAGAIN && ap_msg->flags & AP_MSG_FLAG_ADMIN)
+		rc = -EIO; /* do not retry administrative requests */
+
 out:
 	if (rc)
 		ZCRYPT_DBF_DBG("%s send cprb at dev=%02x.%04x rc=%d\n",


