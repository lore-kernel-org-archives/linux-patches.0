Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85750168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC503C433D2;
	Mon,  8 May 2023 10:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541668;
	bh=deALM/LeI2/1e0uypqYqUuOeZENR5t6MAL43V+qFw0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xfn0jOJ+QXN6fns/RAhDVStJtYri/QnZTJlE5A9t0swGU9R2XX2Y2zzlbtdQ3tuw6
	 ZLus6gNnSdFZ3iye0dtD8BkCz09nTXv08Oi2SsbX52ZWrWIx0qU3A+7jij2JBHOwCP
	 6emwwWSHBIC2HRzuBRmjX9mylr0tq/QRlflYKg+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dionna Glaze <dionnaglaze@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 188/663] virt/coco/sev-guest: Double-buffer messages
Date: Mon,  8 May 2023 11:40:14 +0200
Message-Id: <20230508094434.520435294@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dionna Glaze <dionnaglaze@google.com>

[ Upstream commit 965006103a14703cc42043bbf9b5e0cdf7a468ad ]

The encryption algorithms read and write directly to shared unencrypted
memory, which may leak information as well as permit the host to tamper
with the message integrity. Instead, copy whole messages in or out as
needed before doing any computation on them.

Fixes: d5af44dde546 ("x86/sev: Provide support for SNP guest request NAEs")
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230214164638.1189804-3-dionnaglaze@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 27 +++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 46f1a8d558b0b..0c7b47acba2a8 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -46,7 +46,15 @@ struct snp_guest_dev {
 
 	void *certs_data;
 	struct snp_guest_crypto *crypto;
+	/* request and response are in unencrypted memory */
 	struct snp_guest_msg *request, *response;
+
+	/*
+	 * Avoid information leakage by double-buffering shared messages
+	 * in fields that are in regular encrypted memory.
+	 */
+	struct snp_guest_msg secret_request, secret_response;
+
 	struct snp_secrets_page_layout *layout;
 	struct snp_req_data input;
 	u32 *os_area_msg_seqno;
@@ -266,14 +274,17 @@ static int dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
 static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
 {
 	struct snp_guest_crypto *crypto = snp_dev->crypto;
-	struct snp_guest_msg *resp = snp_dev->response;
-	struct snp_guest_msg *req = snp_dev->request;
+	struct snp_guest_msg *resp = &snp_dev->secret_response;
+	struct snp_guest_msg *req = &snp_dev->secret_request;
 	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
 	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
 
 	dev_dbg(snp_dev->dev, "response [seqno %lld type %d version %d sz %d]\n",
 		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
 
+	/* Copy response from shared memory to encrypted memory. */
+	memcpy(resp, snp_dev->response, sizeof(*resp));
+
 	/* Verify that the sequence counter is incremented by 1 */
 	if (unlikely(resp_hdr->msg_seqno != (req_hdr->msg_seqno + 1)))
 		return -EBADMSG;
@@ -297,7 +308,7 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
 			void *payload, size_t sz)
 {
-	struct snp_guest_msg *req = snp_dev->request;
+	struct snp_guest_msg *req = &snp_dev->secret_request;
 	struct snp_guest_msg_hdr *hdr = &req->hdr;
 
 	memset(req, 0, sizeof(*req));
@@ -417,13 +428,21 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 	if (!seqno)
 		return -EIO;
 
+	/* Clear shared memory's response for the host to populate. */
 	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
 
-	/* Encrypt the userspace provided payload */
+	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
 	rc = enc_payload(snp_dev, seqno, msg_ver, type, req_buf, req_sz);
 	if (rc)
 		return rc;
 
+	/*
+	 * Write the fully encrypted request to the shared unencrypted
+	 * request page.
+	 */
+	memcpy(snp_dev->request, &snp_dev->secret_request,
+	       sizeof(snp_dev->secret_request));
+
 	rc = __handle_guest_request(snp_dev, exit_code, fw_err);
 	if (rc) {
 		if (rc == -EIO && *fw_err == SNP_GUEST_REQ_INVALID_LEN)
-- 
2.39.2



