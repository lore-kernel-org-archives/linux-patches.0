Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92838384223;
	Thu, 30 Jul 2026 15:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426779; cv=none; b=R57zYhjPNpRpOj8SOvcpKoq8hRxOsV7UgSSF3m4WJoxfrYowNADjZrAm936/erTiZXGkWittpYEPGk4E+CTc7hX4jurPnUfAocGTgp66YFzI+YGV5OQoaLJc/YBnfhISbNbM37TxU1W0GWOxz0i8CeFLU9MnKYEiI/VniyETChk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426779; c=relaxed/simple;
	bh=U+Yddm23v15Y+z8Y001VfkPq9obtQsnjItGht1AIOE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpAKmRt3ZWaQ/EX5My/9uQBh9Vh0BYeKhv1Enfj7KO3thuQwmGOq+Qj45htfySyg6PScn6ZVO6qMeWsjTNuwkaroKnO7fEBjL6ene788zA3bMXNMv2MsUriyJROQ54ZU9ppyq+87YjfZ0/O7MF3IelsLylIPk1Ud9WChaexnpqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oytBXYO7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oytBXYO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF1C1F000E9;
	Thu, 30 Jul 2026 15:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426778;
	bh=avpeRXmkFi09chvWHlKFWEZ5fZPaq8Ob93GDc6qq+5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oytBXYO74iBQp02sOjKURfrfD8QeBDqm051bEA32tjD3/+cmrINSrEUy08++Gklpm
	 8QmssFPFdL4pG94L0rDqXzbiDtPHOz3A8IbM7EMhqiQTcNejuP+wr/CIyg0Fc1BtV+
	 n7S9AUxvgAyqpywa13P7yYLOELrPbOspyR3t5oKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 539/602] nvmet-auth: reject short AUTH_RECEIVE buffers
Date: Thu, 30 Jul 2026 16:15:31 +0200
Message-ID: <20260730141447.351113320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -445,7 +445,31 @@ static void nvmet_auth_failure1(struct n
 
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


