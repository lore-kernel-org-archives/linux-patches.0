Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155234E4C43;
	Fri,  9 Oct 2026 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557163; cv=none; b=AocjhXg5/Fs2MjiayoirPLJOKrd4mATGqv4vw+EV6e6jnX3HAYCxmumH/P+FR0JAsgAGiBwNYgjWj5Ob85hrutIw0nQiwQvDhK3NYhpAqmr+Nx1Y9PIAjm7h1Kbgi0a9K0GmDyua+GSVb3or370pyeAx8D4opWQOUQ9KbrFIhDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557163; c=relaxed/simple;
	bh=PesA1c9/aJRSPm8nM9ln5siKdN6mDhB1gAbdVF8zW44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHLG6LCqjaZEvpqZyLW29ihBIvcoYM8uJ0VLmkX5rFquBFwCtcDYnytKYH/KVfimanh18gFjXEE38Q367Zpp6GpbuKu17jUIIOeR6PzpCCoqL8dSKhbAZ+pq1lphZJcdKI41WHboz0Ulwy4nDcaforGv8WhVuXYEI4Uuzi3A9kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIsPNn4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIsPNn4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253DF1F000FF;
	Fri,  9 Oct 2026 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557161;
	bh=SiMOwIKt63dEOxQr5fSdVG8LhLz05SmXJs0ppxROPdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIsPNn4o7cQO6EYW5meqQIWcwwdcqG3pSK1tB1UnWKrK6JqqO9PtVhupZC2ONtDe5
	 BL2qHGORcso16YYCfrYUw1EWnUksldNfpxCQBWqIETQi1n7GKyu8rCNdk9cdQWG+dA
	 L0snU92A34lTAzkH4JCJipb88mEjIHlaWMfTzd5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair.francis@wdc.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/403] nvmet-tcp: Dont error if TLS is enabed on a reset
Date: Fri,  9 Oct 2026 16:11:57 +0200
Message-ID: <20261009141000.607589966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit ecf4d2d883515850ba838df2537ff1c32d0c4217 ]

If the host sends a AUTH_Negotiate Message on the admin queue with
REPLACETLSPSK set then we expect and require a TLS connection and
shouldn't report an error if TLS is enabled.

This change only enforces the nvmet_queue_tls_keyid() check if we aren't
resetting the negotiation.

Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 5211fed41d7e ("nvmet: copy the hostid into the ctrl before creating PR pc_refs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/auth.c             |    4 ++--
 drivers/nvme/target/core.c             |    2 +-
 drivers/nvme/target/fabrics-cmd-auth.c |    3 ++-
 drivers/nvme/target/nvmet.h            |    4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -140,7 +140,7 @@ int nvmet_setup_dhgroup(struct nvmet_ctr
 	return ret;
 }
 
-u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq)
+u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq, bool reset)
 {
 	int ret = 0;
 	struct nvmet_host_link *p;
@@ -166,7 +166,7 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *c
 		goto out_unlock;
 	}
 
-	if (nvmet_queue_tls_keyid(sq)) {
+	if (!reset && nvmet_queue_tls_keyid(sq)) {
 		pr_debug("host %s tls enabled\n", ctrl->hostnqn);
 		goto out_unlock;
 	}
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1692,7 +1692,7 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(stru
 	if (args->hostid)
 		uuid_copy(&ctrl->hostid, args->hostid);
 
-	dhchap_status = nvmet_setup_auth(ctrl, args->sq);
+	dhchap_status = nvmet_setup_auth(ctrl, args->sq, false);
 	if (dhchap_status) {
 		pr_err("Failed to setup authentication, dhchap status %u\n",
 		       dhchap_status);
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -310,7 +310,8 @@ void nvmet_execute_auth_send(struct nvme
 			pr_debug("%s: ctrl %d qid %d reset negotiation\n",
 				 __func__, ctrl->cntlid, req->sq->qid);
 			if (!req->sq->qid) {
-				dhchap_status = nvmet_setup_auth(ctrl, req->sq);
+				dhchap_status = nvmet_setup_auth(ctrl, req->sq,
+								 true);
 				if (dhchap_status) {
 					pr_err("ctrl %d qid 0 failed to setup re-authentication\n",
 					       ctrl->cntlid);
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -897,7 +897,7 @@ void nvmet_execute_auth_receive(struct n
 int nvmet_auth_set_key(struct nvmet_host *host, const char *secret,
 		       bool set_ctrl);
 int nvmet_auth_set_host_hash(struct nvmet_host *host, const char *hash);
-u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq);
+u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq, bool reset);
 void nvmet_auth_sq_init(struct nvmet_sq *sq);
 void nvmet_destroy_auth(struct nvmet_ctrl *ctrl);
 void nvmet_auth_sq_free(struct nvmet_sq *sq);
@@ -919,7 +919,7 @@ int nvmet_auth_ctrl_sesskey(struct nvmet
 void nvmet_auth_insert_psk(struct nvmet_sq *sq);
 #else
 static inline u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl,
-				  struct nvmet_sq *sq)
+				  struct nvmet_sq *sq, bool reset)
 {
 	return 0;
 }


