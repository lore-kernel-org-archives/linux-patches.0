Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215247;
	b=Ja3TTN1MJD09Hldi2ikCCFsLEfRmyfLMbO4hwSwMDyI+VaIMel+99KpQLIEOqdLHmyNF
	 h7aOPxsSflDCckr6NlA6zc+H9P8caouu3pO9TiClp4hQBQrbUCa0kDCOHCAhAQwxK5oUR
	 il3HJfgGPAynWGzOX3tg3HumWmpGe1aZel3Mcn5fkGUWPnLr7GIFTXoZZf3zJBydD/XgL
	 viNRURxQZ/MZyTEXst1POIvCeutzuJs0jCaBVQWLHkXt/Ici0/ZPsgUAXhDx5D6jABEP0
	 aZ3MfLC4cXV6WkxlQTzPpip5hjG7vf+saT2FQ9ZlF9+oO4On3xTsEyhhgtyoF8e3vJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gp2vWdl3Y5yE+IqESOcSQP7VdzAu/NuFig33lbYQAls=;
	b=MpP6ykbIqax+ebv/GjMY8ZQSHtwJOuX3Z8OC2vQziDn3d5Ly2Rn6rCvXJluxJcprvDw+
	 Ezhj2irnPDQxFKgrTJ5ualo99HR/xNw0EpYePB3GQsORiRS3x/VRVblcloSpbU0QLXfif
	 zJh/uYMzDIP4QE5WKnlFDqUhkG7MYUgRWLBYqh95SDoCJmHE10QkN1fh4Avg37nVSu5hZ
	 SX8XlesaoSc59VVo3V3YGfS4V0QTR/UUTvOLgl/Z143COEJONtHO83mroi9B8p6hlX9yY
	 I5dMerFSGHPhUmGFb1XDfAh6Y8G5hHZjg3LocV4Asaxiu6ucLt+GKhs7BR6OPZtnWAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=outszQFB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE63606A31C;
	Wed, 28 Oct 2026 19:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=outszQFB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5A61F01825;
	Wed, 28 Oct 2026 19:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215247;
	bh=gp2vWdl3Y5yE+IqESOcSQP7VdzAu/NuFig33lbYQAls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=outszQFBrauPLiUr3KSSmIAvZ/wrihrPgYyRtazQAzlDgV4pUU8gIHiMtJvKMZv5I
	 +aIO44JdlfM9JPKd3Z5mblB9+an4Dspi/jPI+7Bahzuq3NCzctQv/8TKy8E/lWf7cO
	 yL3be8zL9hs3TYeyQM8e1w5zVpiWEtuk3rzF0tAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Tianchu Chen <flynnnchen@tencent.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1145/1887] nvmet-auth: validate reply message payload bounds against transfer length
Date: Wed, 28 Oct 2026 17:54:01 +0100
Message-ID: <20261028170525.462124486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchu Chen <flynnnchen@tencent.com>

[ Upstream commit 3a413ece2504c70aa34a20be4dafec04e8c741f9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 401874351f639..e87fef24fed56 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -109,13 +109,22 @@ static u8 nvmet_auth_negotiate(struct nvmet_req *req, void *d)
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
@@ -287,7 +296,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 
 	switch (data->auth_id) {
 	case NVME_AUTH_DHCHAP_MESSAGE_REPLY:
-		dhchap_status = nvmet_auth_reply(req, d);
+		dhchap_status = nvmet_auth_reply(req, d, tl);
 		if (dhchap_status == 0)
 			req->sq->dhchap_step =
 				NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1;
-- 
2.53.0



