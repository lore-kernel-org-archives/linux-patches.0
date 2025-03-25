Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592F1265CC3;
	Tue, 25 Mar 2025 12:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905595; cv=none; b=JJdZ1Dcd9qlf52/g96SSMIq/jonuFkcCUE6XtAUhDVbW5kFVSErjl14+mFW8+duZ6tkbvYa0UpGiB9SM7QqTPTv1Y6JDYlYJ9IkEVJdo04CnsQFhAMwhNGSKrku9O1uA/d1XBkbsGexakE702vHcPgpIzJXVzhqpKowj906Mdsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905595; c=relaxed/simple;
	bh=whJkrhJ7oHEHSN0lbYOah3I6RCNuid9MBOeGrXKG2vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCCNL+6isf7BxnnE4jLetdrkHrXsXzxOT8tz/mN01IFjE51n9fOzYPcPpVRwwMefCkn5+d2pHSs29L77zOizMl5qfF11dXe2mm38AUxjYFGcaDrRr9i9GRpUg93I75NvSP52h9VoB4r9yK0/11tN0NwEA91O8mT2JVv29+0ozBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0myUCvpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0myUCvpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E397C4CEF2;
	Tue, 25 Mar 2025 12:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905594;
	bh=whJkrhJ7oHEHSN0lbYOah3I6RCNuid9MBOeGrXKG2vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0myUCvpSrAYJJEck3Gn9uZbiEjIsH/VYOASmdZEsh8AQlFkcwUW19Ik+rkmEBgn1f
	 EYjVwmsb22jMqu8ix0yHeU2QsPyY4Jv6XD7YOUoQyUO6oIWJq9EsDlpcJ4d9sRbCiG
	 fOC4MaENNI8tPmLE1xqxASDNCWfhKSvBGJq9Gd04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/198] nvme-tcp: add basic support for the C2HTermReq PDU
Date: Tue, 25 Mar 2025 08:20:21 -0400
Message-ID: <20250325122158.183446945@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 84e009042d0f3dfe91bec60bcd208ee3f866cbcd ]

Previously, the NVMe/TCP host driver did not handle the C2HTermReq PDU,
instead printing "unsupported pdu type (3)" when received. This patch adds
support for processing the C2HTermReq PDU, allowing the driver
to print the Fatal Error Status field.

Example of output:
nvme nvme4: Received C2HTermReq (FES = Invalid PDU Header Field)

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c  | 43 ++++++++++++++++++++++++++++++++++++++++
 include/linux/nvme-tcp.h |  2 ++
 2 files changed, 45 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 29489c2c52fb9..f7ef727ee44e3 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -694,6 +694,40 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 	return 0;
 }
 
+static void nvme_tcp_handle_c2h_term(struct nvme_tcp_queue *queue,
+		struct nvme_tcp_term_pdu *pdu)
+{
+	u16 fes;
+	const char *msg;
+	u32 plen = le32_to_cpu(pdu->hdr.plen);
+
+	static const char * const msg_table[] = {
+		[NVME_TCP_FES_INVALID_PDU_HDR] = "Invalid PDU Header Field",
+		[NVME_TCP_FES_PDU_SEQ_ERR] = "PDU Sequence Error",
+		[NVME_TCP_FES_HDR_DIGEST_ERR] = "Header Digest Error",
+		[NVME_TCP_FES_DATA_OUT_OF_RANGE] = "Data Transfer Out Of Range",
+		[NVME_TCP_FES_R2T_LIMIT_EXCEEDED] = "R2T Limit Exceeded",
+		[NVME_TCP_FES_UNSUPPORTED_PARAM] = "Unsupported Parameter",
+	};
+
+	if (plen < NVME_TCP_MIN_C2HTERM_PLEN ||
+	    plen > NVME_TCP_MAX_C2HTERM_PLEN) {
+		dev_err(queue->ctrl->ctrl.device,
+			"Received a malformed C2HTermReq PDU (plen = %u)\n",
+			plen);
+		return;
+	}
+
+	fes = le16_to_cpu(pdu->fes);
+	if (fes && fes < ARRAY_SIZE(msg_table))
+		msg = msg_table[fes];
+	else
+		msg = "Unknown";
+
+	dev_err(queue->ctrl->ctrl.device,
+		"Received C2HTermReq (FES = %s)\n", msg);
+}
+
 static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		unsigned int *offset, size_t *len)
 {
@@ -715,6 +749,15 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		return 0;
 
 	hdr = queue->pdu;
+	if (unlikely(hdr->type == nvme_tcp_c2h_term)) {
+		/*
+		 * C2HTermReq never includes Header or Data digests.
+		 * Skip the checks.
+		 */
+		nvme_tcp_handle_c2h_term(queue, (void *)queue->pdu);
+		return -EINVAL;
+	}
+
 	if (queue->hdr_digest) {
 		ret = nvme_tcp_verify_hdgst(queue, queue->pdu, hdr->hlen);
 		if (unlikely(ret))
diff --git a/include/linux/nvme-tcp.h b/include/linux/nvme-tcp.h
index 57ebe1267f7fb..0278ce3ad1fbd 100644
--- a/include/linux/nvme-tcp.h
+++ b/include/linux/nvme-tcp.h
@@ -13,6 +13,8 @@
 #define NVME_TCP_ADMIN_CCSZ	SZ_8K
 #define NVME_TCP_DIGEST_LENGTH	4
 #define NVME_TCP_MIN_MAXH2CDATA 4096
+#define NVME_TCP_MIN_C2HTERM_PLEN	24
+#define NVME_TCP_MAX_C2HTERM_PLEN	152
 
 enum nvme_tcp_pfv {
 	NVME_TCP_PFV_1_0 = 0x0,
-- 
2.39.5



