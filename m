Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086E42BEB0;
	Thu, 16 Jul 2026 14:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212280; cv=none; b=h72r4U48kKI1RNN008Dn2NX9ubpTIau68mOQfbNwR4wtwcyAC+oUVSfQvH4Mye8WICN/1W7WoSbmQjeP8cQzC+p0msm3VF8g31QGIsuxD66Wz8rhk5G/Ep/b20kNP489sFgpgYRjX6OzrKYXIW0LW/ACuQZt3s5znVXp2iZnOSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212280; c=relaxed/simple;
	bh=qiLG/vxWHTwLstjg2qzmDV7KaTNi4uRGuHUfBp+9OGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxCyvII4e4Xkb63Ls+SyAhq+GjK+xFZPw8pvP6bam/rbgVbhMM2da+8XDPVx6O8NFaQL5iHmx6wosA79lCXh/seakTl4hRiA4gnYY7yARXgm7mzoS8fJkg2hEsutKUKByDu3W0//Vzz1zPULVVnYld34DMGpnfLNUsjZl2XhCAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmbpDwqm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmbpDwqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015D51F000E9;
	Thu, 16 Jul 2026 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212279;
	bh=lVUfwjb46H3xMnRgZ0aA1NpRSqXXD4pWgdOIq3X/F+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmbpDwqmjmAKzg6iO7k/KyrWhmtmmXOtDVaMQSN+LBiCsQU1mM/X0BgeR2jfw5uCZ
	 zqJ/7g7Gb05FVPg3H82TwVLwWpATn2UAU6Z762iyCDrH2mAtPiv2ofBOmQ0NPRFQrH
	 f/nZy4ORFaxWTlgFg/yZtXfX7xe71QTBf1rjVWY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Tianchu Chen <flynnnchen@tencent.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 266/349] nvmet-auth: validate reply message payload bounds against transfer length
Date: Thu, 16 Jul 2026 15:33:20 +0200
Message-ID: <20260716133039.297346614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -109,13 +109,22 @@ static u8 nvmet_auth_negotiate(struct nv
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
@@ -287,7 +296,7 @@ void nvmet_execute_auth_send(struct nvme
 
 	switch (data->auth_id) {
 	case NVME_AUTH_DHCHAP_MESSAGE_REPLY:
-		dhchap_status = nvmet_auth_reply(req, d);
+		dhchap_status = nvmet_auth_reply(req, d, tl);
 		if (dhchap_status == 0)
 			req->sq->dhchap_step =
 				NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1;


