Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A848111C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26785C433C7;
	Mon, 28 Aug 2023 10:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218684;
	bh=BaMMbEUDgztlG+X22YwN4s87hAmE63YSRAP2NjbIEcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oa3KPFVvYjijDtFEYS6ENkW30LrzMEFtRHFOkY1Hm/OBAgNks1Bte6kreIM0Y/p8u
	 +GQ2Mi9NQ5V4CZgvwqlHH1iQLFVgnwRFfMdQYlZ1eTYzQ3fMDkR8tnkaPfMF0Iqb7s
	 bShp3Svk0Ac3N0APb5Ceux6PvrVXntqeD9egUHjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/122] s390/zcrypt: fix reply buffer calculations for CCA replies
Date: Mon, 28 Aug 2023 12:12:14 +0200
Message-ID: <20230828101157.081213172@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 4cfca532ddc3474b3fc42592d0e4237544344b1a ]

The length information for available buffer space for CCA
replies is covered with two fields in the T6 header prepended
on each CCA reply: fromcardlen1 and fromcardlen2. The sum of
these both values must not exceed the AP bus limit for this
card (24KB for CEX8, 12KB CEX7 and older) minus the always
present headers.

The current code adjusted the fromcardlen2 value in case
of exceeding the AP bus limit when there was a non-zero
value given from userspace. Some tests now showed that this
was the wrong assumption. Instead the userspace value given for
this field should always be trusted and if the sum of the
two fields exceeds the AP bus limit for this card the first
field fromcardlen1 should be adjusted instead.

So now the calculation is done with this new insight in mind.
Also some additional checks for overflow have been introduced
and some comments to provide some documentation for future
maintainers of this complicated calculation code.

Furthermore the 128 bytes of fix overhead which is used
in the current code is not correct. Investigations showed
that for a reply always the same two header structs are
prepended before a possible payload. So this is also fixed
with this patch.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_msgtype6.c | 35 ++++++++++++++++++---------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index 37c01aaa21a2b..84e3ad290f6ba 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -1154,23 +1154,36 @@ static long zcrypt_msgtype6_send_cprb(bool userspace, struct zcrypt_queue *zq,
 				      struct ica_xcRB *xcrb,
 				      struct ap_message *ap_msg)
 {
-	int rc;
 	struct response_type *rtype = ap_msg->private;
 	struct {
 		struct type6_hdr hdr;
 		struct CPRBX cprbx;
 		/* ... more data blocks ... */
 	} __packed * msg = ap_msg->msg;
-
-	/*
-	 * Set the queue's reply buffer length minus 128 byte padding
-	 * as reply limit for the card firmware.
-	 */
-	msg->hdr.fromcardlen1 = min_t(unsigned int, msg->hdr.fromcardlen1,
-				      zq->reply.bufsize - 128);
-	if (msg->hdr.fromcardlen2)
-		msg->hdr.fromcardlen2 =
-			zq->reply.bufsize - msg->hdr.fromcardlen1 - 128;
+	unsigned int max_payload_size;
+	int rc, delta;
+
+	/* calculate maximum payload for this card and msg type */
+	max_payload_size = zq->reply.bufsize - sizeof(struct type86_fmt2_msg);
+
+	/* limit each of the two from fields to the maximum payload size */
+	msg->hdr.fromcardlen1 = min(msg->hdr.fromcardlen1, max_payload_size);
+	msg->hdr.fromcardlen2 = min(msg->hdr.fromcardlen2, max_payload_size);
+
+	/* calculate delta if the sum of both exceeds max payload size */
+	delta = msg->hdr.fromcardlen1 + msg->hdr.fromcardlen2
+		- max_payload_size;
+	if (delta > 0) {
+		/*
+		 * Sum exceeds maximum payload size, prune fromcardlen1
+		 * (always trust fromcardlen2)
+		 */
+		if (delta > msg->hdr.fromcardlen1) {
+			rc = -EINVAL;
+			goto out;
+		}
+		msg->hdr.fromcardlen1 -= delta;
+	}
 
 	init_completion(&rtype->work);
 	rc = ap_queue_message(zq->queue, ap_msg);
-- 
2.40.1



