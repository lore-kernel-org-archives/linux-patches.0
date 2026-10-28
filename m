Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215431;
	b=zs1wT5i0LlJJJ3u2cgWBqVlBIBZhD6TAW4bJ+vjmhUqAEUZv/tMimE6jkSwCc5B80mU0
	 vqJxb/NBS7ZD8CsSGehBdNMqh2hOWfSOBGepxBfSkDH9RgPtGconwe825y1gHtmE2oZAz
	 m60yOo3RqbrScGsvuhAXsIVFVtAys66ddjJcyUZLm8/1ykojMxvToCjeFB38/302F9mCQ
	 4+xwxDjkeI6DKUSeUIen9DCnXzf55Bl278VYtXkaXiMULecaL85lc2/kknEo/4JjlNLoy
	 XW0VQFW6AVCpLYycTjPjRYgKrj0H3sPFO5MpxJgaUkvANoDNoqNywbFh4f3qlQkOpBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=asxGgXaZyWRVFxDWflK6xAaG98hbeB3+bnrlx/d/J6k=;
	b=Hw46sinsl+wSUX9Gt97ShnqDM0ReiVdIczubI3mJmGlhWHm/okelgHRqHRT7dtpEwoFd
	 kh9/J3xvZVJYKIgn40oHo+aeZXzQoQzngeSDak64/eW+Lv4iNJi1i7bFVrEkNbvpfzMDB
	 Zcl23sxNlygglEfxlzCPwc1Qf0bWf19Fr/4kxWmYyXrAK2jvyndQS+2aVkbiipVd3KksR
	 OYqZOwxQKP5+ET3/wDAjszPlsHrHe1GalN0eYxcSIuhoeuQPGe+Y05Rp16G2y9NZp7+RL
	 UsRq5PdGc8W2HCmRGl3o4NxstRvuCxpanlTz57/m31xr67hkeEx8wWB96q2bvkQBfEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfCwXZT2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0DD606A324;
	Wed, 28 Oct 2026 19:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfCwXZT2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B77F1F01825;
	Wed, 28 Oct 2026 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215430;
	bh=asxGgXaZyWRVFxDWflK6xAaG98hbeB3+bnrlx/d/J6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfCwXZT2G+UJFT86jcXYo6NtsgHpAvA45AsgZIEDpLYrl4ga/mrAZv9W86EmpRThy
	 qMg3gqiNJ7dXqlpeFUDTVhsZILcSx3UyJRzW4i9OxlROoQgSlF2vRZ4jGmKVENZjoi
	 vmmFZ2HwLHCx2Foej7mG+ZkM6Jv0If/mSTSsYatE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1208/1887] nvmet-auth: reject short AUTH_RECEIVE buffers
Date: Wed, 28 Oct 2026 17:55:04 +0100
Message-ID: <20261028170526.897191374@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 779575bc35c687697ba69e904f2cd22e60112534 ]

nvmet_execute_auth_receive() trusts the AUTH_RECEIVE allocation length
after checking only that it is nonzero and matches the transfer length.
In the SUCCESS1 and FAILURE1/default states, that lets a remote NVMe-oF
initiator reach the fixed-size DH-HMAC-CHAP response builders with a
kmalloc() buffer shorter than the response, so nvmet_auth_success1() and
nvmet_auth_failure1() write past the allocation; both only WARN_ON the
short length and then format the message anyway.

Impact: A remote NVMe-oF initiator with access to an auth-enabled target
can trigger a 16-byte heap out-of-bounds write via a one-byte
AUTH_RECEIVE allocation length.

Compute the minimum response length for the current DH-HMAC-CHAP step in
nvmet_auth_receive_data_len() and report a zero data length when the
host-supplied allocation length is shorter, so the existing zero-length
check in nvmet_execute_auth_receive() rejects the command before any
builder runs. The SUCCESS1 minimum is sizeof(struct
nvmf_auth_dhchap_success1_data) plus the HMAC hash length, because the
response hash is written into the rval[] flexible-array tail, so the
minimum is state dependent rather than a flat sizeof. CHALLENGE keeps its
existing variable-length guard in nvmet_auth_challenge().

This is reachable only when in-band DH-HMAC-CHAP authentication is
configured on the target.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5-5-xhigh
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 50eed28a7208c..990bb7af4dc8b 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -449,7 +449,31 @@ static void nvmet_auth_failure1(struct nvmet_req *req, void *d, int al)
 
 u32 nvmet_auth_receive_data_len(struct nvmet_req *req)
 {
-	return le32_to_cpu(req->cmd->auth_receive.al);
+	struct nvmet_ctrl *ctrl = req->sq->ctrl;
+	u32 al = le32_to_cpu(req->cmd->auth_receive.al);
+	u32 min_len;
+
+	/*
+	 * Reject too-short al before kmalloc(al), since the SUCCESS1 and
+	 * FAILURE1/default builders write fixed response headers into it.
+	 */
+	switch (req->sq->dhchap_step) {
+	case NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE:
+		return al;
+	case NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1:
+		min_len = sizeof(struct nvmf_auth_dhchap_success1_data);
+		if (req->sq->dhchap_c2)
+			min_len += nvme_auth_hmac_hash_len(ctrl->shash_id);
+		break;
+	default:
+		min_len = sizeof(struct nvmf_auth_dhchap_failure_data);
+		break;
+	}
+
+	if (al < min_len)
+		return 0;
+
+	return al;
 }
 
 void nvmet_execute_auth_receive(struct nvmet_req *req)
-- 
2.53.0



