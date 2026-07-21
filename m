Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE75D19049B;
	Tue, 21 Jul 2026 17:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654723; cv=none; b=qleyWjCoirX2d8b8JBipYhw5Smb55trn8TNIK18bqaqB/+ReCVfvTqQxNB03tgQtRCIRmJKBtqqGvA9eVDiR/LieKgGesw4S+t5vnw3vXRXFggPCvuXgsvbdP3AC7FkHmuFFVpFAbqtwWyWuQ/98w3aLvJgxXLdk0DFS2UlHkJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654723; c=relaxed/simple;
	bh=kjIMYDcK3veXt1SMcmD40oPxVdKA8TZwYqUgUUqqDyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMFXsvToudTkJWBcK5Wg/sTweIO6Y4lwK2tyc+qqDHjTZEjFE+PhjE1Z2tjrj+04+92/evE/Hr2aQMu2U5mqH6YHjjRzfQERI+MWJwsLVYtu8Jk8cAix0vlSdPdRB9frbjhJ4tqbtald18uUqLGxSXbgQXSq/o6duFb0KzPxxuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhjoFZVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhjoFZVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C5B1F000E9;
	Tue, 21 Jul 2026 17:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654722;
	bh=+SzVabR8w4OAuprYzraNd12Krwv4qTHrVEH7udiH0Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhjoFZVWE5eX8sCGcbFCwnvWKQCsmBn0IbC5stTSFo1t/NnmLfElw9oDOvHX90Fvq
	 9NePIhAXYJJejJRbhY1FFQsnjRNb86QW8q+kEphu8suigAc3+CSv1FWpe/EsSX12CW
	 n2CPEBbUtUnaYNP7bozT8NQzWgSuamEHabDhHY2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.1 1814/2077] nvmet-auth: reject short AUTH_RECEIVE buffers
Date: Tue, 21 Jul 2026 17:24:47 +0200
Message-ID: <20260721152635.533007673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 779575bc35c687697ba69e904f2cd22e60112534 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -493,7 +493,31 @@ static void nvmet_auth_failure1(struct n
 
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


