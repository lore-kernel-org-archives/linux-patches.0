Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621480;
	b=AwQiPKEL168ghcNTSkvdCH0rzPrUhCor0OMnHJzEKRDnVmoY8D3s57aSvZeVhJV7gsAk
	 mTXgWLkaI37xL2I5B9nqGwSU8aWlTT4Iqsc5vkh/h9wfNcafMmG6poQkPGCv9k9l3QsDb
	 tTRHPh7WW7gnHYvPEpdmGb68XFwU6KwIGO79XNMnwTy03qYeDzEjDiCGdCloBfO9aWIpm
	 6DY29RY06Xdt48/7C3qsDeXxHH+G3v8PhfjMU8tuwAEVZwDD2ytSV28y2ILB3HQZt93Ns
	 sww/ZpMwx3sj/2tlD9fRK67N4BOSgHktYdLc4r4UStEustmr6fEANbieGVbsWwG9WoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2iNxhVVgHfWC0FSvKymWJfEeEF/nDteYIwW1Fn4h07M=;
	b=fhVv0sUmtyeTOGkIkIpiPZvg8AIlfnNbUbeMwnu2/N+3QH/SoZErkMNgNYaXzBtplnQv
	 fGyC24H8iKSI7zSaFVammWWYKzodKhTMa991Y6aQyunCrG4/cZldFX3qMaCYeXR5eywAg
	 lBerNzEe/W6gb+w3PBFa9kKxGoQ+4xMnMClTgDOioMvjAxsbOwfO1PRHKLmReebmli3RS
	 7lbLbVdUUtFsw+jGRurfMcXqtRAzQAcn0mnJ9S4sZg7Ha9D6+mWxrjIbQyXzAvESn0RDu
	 vkgqiCEvdujXgey3Q/VUNZHj+uzFZvHnmq6zBs11TuCN0nWPU/NDI/hqrFvmpKXezbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0aOo6pjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723F6606A31E;
	Wed, 25 Nov 2026 15:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0aOo6pjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35B31F000C4;
	Wed, 25 Nov 2026 15:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621480;
	bh=2iNxhVVgHfWC0FSvKymWJfEeEF/nDteYIwW1Fn4h07M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0aOo6pjADvjPshzm5wgqE/bkkkb77Mu43rLVmzVL2gzLx1JFig7N+YSejJwuFeLUI
	 p5rIrdpUD50tu/2Mlh2BoL28ntMJAVfFNGxYErlliXWGXoKuFATckO5Ti4N5sf31Xc
	 c9SmQsoK9FBkAk4c2+f1yUGHekpy9bH0CWQbw/PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 237/990] nvmet-auth: keep the old keys if the new ones fail
Date: Wed, 25 Nov 2026 15:26:44 +0100
Message-ID: <20261125143827.642348098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 41ad4af45ac90259c652135b24539a08a92a7491 ]

AUTH_Negotiate on the admin queue has nvmet_setup_auth() reload the
host's keys, and it frees the old host key first. If decoding the new
secret fails, or an allocation does, the controller is left without a
host key, which means no authentication at all: nvmet_check_auth_status()
passes everything and I/O queue Connects no longer ask for it. configfs
accepts any string starting with "DHHC-1:" and a digit, so one typo
while changing a secret opens the namespaces to any connected admin
queue.

Decode the new keys first and only then replace the old ones.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c | 69 ++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 41 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 1cb821a18532f..1ad1754a95516 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -145,6 +145,7 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq, bool reset)
 	int ret = 0;
 	struct nvmet_host_link *p;
 	struct nvmet_host *host = NULL;
+	struct nvme_dhchap_key *host_key, *ctrl_key = NULL;
 
 	down_read(&nvmet_config_sem);
 	if (nvmet_is_disc_subsys(ctrl->subsys))
@@ -182,55 +183,41 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq, bool reset)
 		goto out_unlock;
 	}
 
-	if (host->dhchap_hash_id == ctrl->shash_id) {
-		pr_debug("Re-use existing hash ID %d\n",
-			 ctrl->shash_id);
-	} else {
-		ctrl->shash_id = host->dhchap_hash_id;
-	}
-
-	/* Skip the 'DHHC-1:XX:' prefix */
-	nvme_auth_free_key(ctrl->host_key);
-	ctrl->host_key = nvme_auth_extract_key(host->dhchap_secret + 10,
-					       host->dhchap_key_hash);
-	if (IS_ERR(ctrl->host_key)) {
+	/*
+	 * Skip the 'DHHC-1:XX:' prefix. Keep the old keys until the new ones
+	 * are there: a controller without a host key needs no authentication.
+	 */
+	host_key = nvme_auth_extract_key(host->dhchap_secret + 10,
+					 host->dhchap_key_hash);
+	if (IS_ERR(host_key)) {
 		ret = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
-		ctrl->host_key = NULL;
-		goto out_free_hash;
+		goto out_unlock;
 	}
+	if (host->dhchap_ctrl_secret) {
+		ctrl_key = nvme_auth_extract_key(host->dhchap_ctrl_secret + 10,
+						 host->dhchap_ctrl_key_hash);
+		if (IS_ERR(ctrl_key)) {
+			nvme_auth_free_key(host_key);
+			ret = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
+			goto out_unlock;
+		}
+	}
+	nvme_auth_free_key(ctrl->host_key);
+	ctrl->host_key = host_key;
+	nvme_auth_free_key(ctrl->ctrl_key);
+	ctrl->ctrl_key = ctrl_key;
+	ctrl->shash_id = host->dhchap_hash_id;
 #ifdef CONFIG_NVME_TARGET_AUTH_DEBUG
 	pr_debug("%s: using hash %s key %*ph\n", __func__,
 		 ctrl->host_key->hash > 0 ?
 		 nvme_auth_hmac_name(ctrl->host_key->hash) : "none",
 		 (int)ctrl->host_key->len, ctrl->host_key->key);
+	if (ctrl->ctrl_key)
+		pr_debug("%s: using ctrl hash %s key %*ph\n", __func__,
+			 ctrl->ctrl_key->hash > 0 ?
+			 nvme_auth_hmac_name(ctrl->ctrl_key->hash) : "none",
+			 (int)ctrl->ctrl_key->len, ctrl->ctrl_key->key);
 #endif
-	nvme_auth_free_key(ctrl->ctrl_key);
-	if (!host->dhchap_ctrl_secret) {
-		ctrl->ctrl_key = NULL;
-		goto out_unlock;
-	}
-
-	ctrl->ctrl_key = nvme_auth_extract_key(host->dhchap_ctrl_secret + 10,
-					       host->dhchap_ctrl_key_hash);
-	if (IS_ERR(ctrl->ctrl_key)) {
-		ret = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
-		ctrl->ctrl_key = NULL;
-		goto out_free_hash;
-	}
-#ifdef CONFIG_NVME_TARGET_AUTH_DEBUG
-	pr_debug("%s: using ctrl hash %s key %*ph\n", __func__,
-		 ctrl->ctrl_key->hash > 0 ?
-		 nvme_auth_hmac_name(ctrl->ctrl_key->hash) : "none",
-		 (int)ctrl->ctrl_key->len, ctrl->ctrl_key->key);
-#endif
-out_free_hash:
-	if (ret) {
-		if (ctrl->host_key) {
-			nvme_auth_free_key(ctrl->host_key);
-			ctrl->host_key = NULL;
-		}
-		ctrl->shash_id = 0;
-	}
 out_unlock:
 	up_read(&nvmet_config_sem);
 
-- 
2.53.0



