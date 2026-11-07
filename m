Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062728;
	b=40ulbjfR+/3KTWmsO08RgJt/y8qZMSKbFVcu9WPXBpDpWnziApbbonQ0l3kmxcXoud0d
	 saXLSvfOaUUwcCT3LETSgZG98MPBAxOzEH4B7dAZt79HHxVJPeCKkUm9cfhnB88OP+Vq2
	 HTkQCyzt4G3QdXDgNvfzX6GIHtr+gF5hHM+QZ18zSBrWx9N/AOhJH3oc10EAy7t4ObrCg
	 v3pkXGHtJUvAgwDN3DrLc5UOisOaCpDzdbHRSiusVeYLUA6u8IGxJMQ4G3FSQmSuuqtwZ
	 /OEQsjaytxU+ORtiD6z70vwaIFPhvRF8uGk/1GaTEYIKDo+yfTmRHfxV/qy4lkuFGug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cwFupJAv3yCL0a2oPGTAvtF+jbuWUnPnvYCeH8rNumI=;
	b=rprtelF+VohX4QADUAqYllk6+dB4/7K5muMZfQ+teeXrM0DyVrAVRTJZOHXTGAd6E/Fv
	 3qYr5sDVeKJGRNf1hMs7Q6gKMEL2MVDQAMjiVUr3zIVJUbz7pgu4Eu37cCUhGQD17Hdwh
	 mQNfOYbCKa3zY4wFKeAaSLyKmvdzcxIApKv8QLzdunRtLTqyi4cMBIuaHggpIX/Nd70xr
	 syr50b7cvHOovF3286u5QKG8gZHlvjSrrJofD4PpI7JGel3C7PWypT5Y2gRiAb3JMR8Wz
	 tBfrtDP9vVukVG6qRZ0l2AtIADGRUJRJgA3A7p2GQiFOsZg+TlJHf1clChNK1n/eEUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUzD918Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBDA606A32C;
	Sat,  7 Nov 2026 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUzD918Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13B91F0089F;
	Sat,  7 Nov 2026 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062727;
	bh=cwFupJAv3yCL0a2oPGTAvtF+jbuWUnPnvYCeH8rNumI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUzD918Y1uU4E5vFpBPgmOzXDl35M/sM6wquRcfwvngIPBxp5OqN4KYo4VX/bBTGc
	 OrCy3C25VbMK2Fh36MmUBwTVWqDGJqs2JdrIib9aAcX94V1cpOi69AwZ4eulSY/poI
	 HPH+Q9O1Yb7ei1nqRiCYJwZ/b3Xka8WB5tGpc/Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/869] nvmet-auth: serialize access to DH-HMAC-CHAP state to fix UAF
Date: Sat,  7 Nov 2026 08:44:57 -0500
Message-ID: <20261107134852.508822586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 53f6efe00cea0c0cf7bd99debe3cdac8567170b5 ]

A REPLY AUTH_SEND command can derive a dhchap_skey key while a
concurrent AUTH_RECEIVE command observing this REPLY state executes
the failure path and frees that key. The REPLY command then continues
and writes into freed memory, causing a use-after-free. KASAN reports
it as:

  BUG: KASAN: slab-use-after-free in __sha256_final
  Write of size 4 at addr ffff88800359c540
  ...
  nvmet_auth_sq_free (drivers/nvme/target/auth.c:237)
  nvmet_execute_auth_receive (drivers/nvme/target/fabrics-cmd-auth.c:621)

Add a mutex to each submission queue to serialize authentication
commands and timeout handling. Unlock the mutex before completing
requests and ignore outdated timeout callbacks. Limit timeout delays
to prevent immediate expiry on 32-bit kernels.

Fixes: 7a277c37d352 ("nvmet-auth: Diffie-Hellman key exchange support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c             |  1 +
 drivers/nvme/target/fabrics-cmd-auth.c | 32 ++++++++++++++++++++++----
 drivers/nvme/target/nvmet.h            |  2 ++
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 8230a0563616b..4c68225411be3 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -238,6 +238,7 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq, bool reset)
 
 void nvmet_auth_sq_free(struct nvmet_sq *sq)
 {
+	sq->auth_expiry_active = false;
 	cancel_delayed_work(&sq->auth_expired_work);
 #ifdef CONFIG_NVME_TARGET_TCP_TLS
 	sq->tls_key = NULL;
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index af712c6624b36..20a2dfcbbc57f 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -6,6 +6,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/blkdev.h>
+#include <linux/jiffies.h>
 #include <linux/random.h>
 #include <linux/nvme-auth.h>
 #include <crypto/hash.h>
@@ -18,16 +19,27 @@ static void nvmet_auth_expired_work(struct work_struct *work)
 	struct nvmet_sq *sq = container_of(to_delayed_work(work),
 			struct nvmet_sq, auth_expired_work);
 
+	mutex_lock(&sq->auth_lock);
+	/* A command may have cancelled or rearmed this timeout. */
+	if (!sq->auth_expiry_active ||
+	    delayed_work_pending(&sq->auth_expired_work))
+		goto out_unlock;
+	sq->auth_expiry_active = false;
+
 	pr_debug("%s: ctrl %d qid %d transaction %u expired, resetting\n",
 		 __func__, sq->ctrl->cntlid, sq->qid, sq->dhchap_tid);
 	sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
 	sq->dhchap_tid = -1;
+out_unlock:
+	mutex_unlock(&sq->auth_lock);
 }
 
 void nvmet_auth_sq_init(struct nvmet_sq *sq)
 {
 	/* Initialize in-band authentication */
+	mutex_init(&sq->auth_lock);
 	INIT_DELAYED_WORK(&sq->auth_expired_work, nvmet_auth_expired_work);
+	sq->auth_expiry_active = false;
 	sq->authenticated = false;
 	sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
 }
@@ -258,6 +270,8 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 	u16 status = 0;
 	u8 dhchap_status;
 
+	mutex_lock(&req->sq->auth_lock);
+
 	if (req->cmd->auth_send.secp != NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc =
@@ -283,8 +297,10 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			offsetof(struct nvmf_auth_send_command, tl);
 		goto done;
 	}
-	if (!nvmet_check_transfer_len(req, tl)) {
+	if (unlikely(tl != req->transfer_len)) {
 		pr_debug("%s: transfer length mismatch (%u)\n", __func__, tl);
+		mutex_unlock(&req->sq->auth_lock);
+		nvmet_check_transfer_len(req, tl);
 		return;
 	}
 
@@ -408,10 +424,12 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			 status, req->error_loc);
 	if (req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2 &&
 	    req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_FAILURE2) {
-		unsigned long auth_expire_secs = ctrl->kato ? ctrl->kato : 120;
+		unsigned long auth_expire = min_t(u64, MAX_JIFFY_OFFSET,
+			(u64)(ctrl->kato ? ctrl->kato : 120) * HZ);
 
+		req->sq->auth_expiry_active = true;
 		mod_delayed_work(system_percpu_wq, &req->sq->auth_expired_work,
-				 auth_expire_secs * HZ);
+				 auth_expire);
 		goto complete;
 	}
 	/* Final states, clear up variables */
@@ -420,6 +438,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 		nvmet_ctrl_fatal_error(ctrl);
 
 complete:
+	mutex_unlock(&req->sq->auth_lock);
 	nvmet_req_complete(req, status);
 }
 
@@ -538,6 +557,8 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 	u32 al;
 	u16 status = 0;
 
+	mutex_lock(&req->sq->auth_lock);
+
 	if (req->cmd->auth_receive.secp != NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc =
@@ -563,8 +584,10 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 			offsetof(struct nvmf_auth_receive_command, al);
 		goto done;
 	}
-	if (!nvmet_check_transfer_len(req, al)) {
+	if (unlikely(al != req->transfer_len)) {
 		pr_debug("%s: transfer length mismatch (%u)\n", __func__, al);
+		mutex_unlock(&req->sq->auth_lock);
+		nvmet_check_transfer_len(req, al);
 		return;
 	}
 
@@ -623,5 +646,6 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 		nvmet_auth_sq_free(req->sq);
 		nvmet_ctrl_fatal_error(ctrl);
 	}
+	mutex_unlock(&req->sq->auth_lock);
 	nvmet_req_complete(req, status);
 }
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 87e2fdbd18656..45fc188412d28 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -156,8 +156,10 @@ struct nvmet_sq {
 	u32			sqhd;
 	bool			sqhd_disabled;
 #ifdef CONFIG_NVME_TARGET_AUTH
+	struct mutex		auth_lock;
 	bool			authenticated;
 	struct delayed_work	auth_expired_work;
+	bool			auth_expiry_active;
 	u16			dhchap_tid;
 	u8			sc_c;
 	u8			dhchap_status;
-- 
2.53.0



