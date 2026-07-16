Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280AD3DB62F;
	Thu, 16 Jul 2026 13:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209979; cv=none; b=Lb2UOkLgFKVv5ixFQ+iMIqU/KBzqVR+J24J6jgjgAkuhaQK0BfaHTDyrCfkbCggeV/zYhhem/nPx9Rfd77+Hm+N9cVLJdOYkVxUlEgrEebKVzMoXoaVYMcmvycJZRedzOwaPivuMPsB4CLtV68kbB/iuoOC8S0nwRYNcSp5/+x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209979; c=relaxed/simple;
	bh=zoLcJL7mS2eyBjPanrQHGWOrfzDFI4Jw2zJijo3HlcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsnB15jQPsJXxQOEMIgg3sMl63pr0UYYMuhZ49yTUaR9kRV9LAo3RjsF3AjRtFNINi/oWHXjwuacDOIGUsWEQQoSGXDPRIymCjU4hTqGCIdSeQVCoqUkDN3taUMBAlx1n+bCpcnK+6C/aowP33lJ64cg9FBadRSQrR0QtlJB6+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rov8iAgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rov8iAgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4BE1F000E9;
	Thu, 16 Jul 2026 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209978;
	bh=kOxL7Q9QNw8t9x7JOUT0F1mnbShSlOy+Z35c4tMyagE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rov8iAgc4/CyIQJVt9nXv+uizLObmgF5UH8uSlbyZmpnwu9H+NQdSZyb3iZm+/lsK
	 1xV+lTDz+vWuPSS5uSWCim7KGVE4SphUrXX17KtXn322YPhFTu2EzzQV2XSPCzNMKL
	 qPbhjVHD46G8wvsMOETNAltewY1y5lS2GTyR5ZpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Tianchu Chen <flynnnchen@tencent.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.1 354/518] nvmet-auth: validate reply message payload bounds against transfer length
Date: Thu, 16 Jul 2026 15:30:22 +0200
Message-ID: <20260716133055.572009463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

commit 3a413ece2504c70aa34a20be4dafec04e8c741f9 upstream.

nvmet_auth_reply() accesses the variable-length rval[] array using
attacker-controlled hl (hash length) and dhvlen (DH value length) fields
without verifying they fit within the allocated buffer of tl bytes.

A malicious NVMe-oF initiator can craft a DHCHAP_REPLY message with a
small transfer length but large hl/dhvlen values, causing out-of-bounds
heap reads when the target processes the DH public key (rval + 2*hl) or
performs the host response memcmp.

With DH authentication configured, the OOB pointer is passed directly to
sg_init_one() and read by crypto_kpp_compute_shared_secret(), reaching
up to 526 bytes past the buffer. This is exploitable pre-authentication.

Add bounds validation ensuring sizeof(*data) + 2*hl + dhvlen <= tl before
any access to the variable-length fields.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -132,13 +132,22 @@ static u8 nvmet_auth_negotiate(struct nv
 	return 0;
 }
 
-static u8 nvmet_auth_reply(struct nvmet_req *req, void *d)
+static u8 nvmet_auth_reply(struct nvmet_req *req, void *d, u32 tl)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 	struct nvmf_auth_dhchap_reply_data *data = d;
-	u16 dhvlen = le16_to_cpu(data->dhvlen);
+	u16 dhvlen;
 	u8 *response;
 
+	if (tl < sizeof(*data))
+		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+
+	dhvlen = le16_to_cpu(data->dhvlen);
+
+	/* Validate that hl and dhvlen fit within the transfer length */
+	if (sizeof(*data) + 2 * (size_t)data->hl + dhvlen > tl)
+		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+
 	pr_debug("%s: ctrl %d qid %d: data hl %d cvalid %d dhvlen %u\n",
 		 __func__, ctrl->cntlid, req->sq->qid,
 		 data->hl, data->cvalid, dhvlen);
@@ -338,7 +347,7 @@ void nvmet_execute_auth_send(struct nvme
 
 	switch (data->auth_id) {
 	case NVME_AUTH_DHCHAP_MESSAGE_REPLY:
-		dhchap_status = nvmet_auth_reply(req, d);
+		dhchap_status = nvmet_auth_reply(req, d, tl);
 		if (dhchap_status == 0)
 			req->sq->dhchap_step =
 				NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1;


