Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065592;
	b=WYrj1qj4rP4G9p8YMMu+7IVus+iB9c7nbFIFXbLJ7ASIukzHtn/h6bVopgmw/QOF7hOS
	 G2dtcDtYutJbX4/xf2RNjMRVwIatVDPaT8AUkCZxDSHi+VBUbdGznC9c/IoGbC2NORE7q
	 fK5G89Ty8Ndx01Mv360EHpjNQijWreNXYQ13lu9K+eKJfvLzH9fx5UCwrEVdyVWOVy3yU
	 Kw3D7xwer4WrphWhCS6Shrlk6L0zKbxmJNJnbOS0hbgVS3PLoUK0RkzL3mgc0yCedivOv
	 SOgZwhWqmITUFdlSPqWFL3p6OxZSHc4MUgg0XgUw2e9I1ytRl3j0HbCnKD61bqkBXZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hcsTkclqjKf5NbXO1So60HwTVzQ+yqLM6baRrpI+RKs=;
	b=wDdyBIZGRim78k0jSmQYK9I8IO/KfRxcgA6rS6HGZKW0Ci84xgRODBIDOQPzf9yKcdGG
	 bluBXvXtV+TxfN6GrczDHAu0oQdDnGUf6FXA4qLB1RQT1PPt/zOZGh+NNtYY7jhFe52TK
	 Rt1K6IlfPtKcxTqrGJndNzEoQ0XaVy1rtIW7QTgObitVkSHg9YpXOSbdiOVIEUkKFS0Iu
	 7ERMNRVWOOW7cEOquksps4YNeqXZ2tayVVqS5G1xNCjz4PAqdbN85e9tNGmmGNSsMvE/D
	 SNvrNwjRAsZGHEMBExd1UGCTsMsor+sxIoIEpYSj4wgvQukn3KHl8bdjVGQY47aO6mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5Ymnlaq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2781606A337;
	Sat,  7 Nov 2026 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5Ymnlaq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6109D1F0089F;
	Sat,  7 Nov 2026 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065591;
	bh=hcsTkclqjKf5NbXO1So60HwTVzQ+yqLM6baRrpI+RKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5YmnlaqQ5VIqSzh/A8w/+hUhDW5ZtGJLHlawnNgIy2za3EhjtzLGzHgpW3nkSv0O
	 lFyY7iurluRfEBtgwIcXHFIY+8tew/1t7/NEQM7NSeJqyHK7O53wox+yCCjQ+if0eL
	 zfWc2ClU6dbgCf6+oXu8WcPThdQRbQXGh0NiK3PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1211/1257] nvmet: Free the old negotiation state when restarting authentication
Date: Sat,  7 Nov 2026 08:58:27 -0500
Message-ID: <20261107135012.820880553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 5c279fcabb0ea7ba61881c13027b15d8054b8abd ]

Restarting a DH-HMAC-CHAP negotiation with SEND(NEGOTIATE) resets
sq->dhchap_step but does not release the previous c1/c2/skey, which
are only freed in nvmet_auth_sq_free() at teardown.  The next
CHALLENGE/REPLY exchange then overwrites those pointers with fresh
allocations.

An unauthenticated host can repeat the negotiate message endlessly,
leaking a few dozen bytes per round and slowly exhausting target
memory.

Clear the old negotiation state with nvmet_auth_sq_free() before
setting up the new one.  Also reset dhchap_skey_len to zero: if a DH
session key was already established, a following round with dhvlen=0
would otherwise pass a NULL skey with a stale non-zero length to the
HMAC code and dereference it.

Fixes: db1312dd95488 ("nvmet: implement basic In-Band Authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c             | 1 +
 drivers/nvme/target/fabrics-cmd-auth.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 1680e5e6839c1..574025730834c 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -237,6 +237,7 @@ void nvmet_auth_sq_free(struct nvmet_sq *sq)
 	sq->dhchap_c2 = NULL;
 	kfree(sq->dhchap_skey);
 	sq->dhchap_skey = NULL;
+	sq->dhchap_skey_len = 0;
 }
 
 void nvmet_auth_sq_destroy(struct nvmet_sq *sq)
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 51d6ad4d021d0..d9dab0cda3b06 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -324,6 +324,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			/* Restart negotiation */
 			pr_debug("%s: ctrl %d qid %d reset negotiation\n",
 				 __func__, ctrl->cntlid, req->sq->qid);
+			nvmet_auth_sq_free(req->sq);
 			if (!req->sq->qid) {
 				dhchap_status = nvmet_setup_auth(ctrl, req->sq,
 								 true);
-- 
2.53.0



