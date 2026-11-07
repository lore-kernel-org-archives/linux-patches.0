Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062649;
	b=K90HLdofrYSfnBLWsRlO1BLlqZFSFP0XeT+qkZO1rhQD8lh3GVT9GZRV3xJiMxAE2WNA
	 WpyBPQadX+4Nnx16bdGK4020ySfO3iQgMXrSnn9UlG/9lmthWplQMdm170ffbIiDongbR
	 l8N7FtBg7spYyKONX5xPKcfaCGPjR2phyGv8xdb7Lj89gHJ+qZrFtoOE+c0RBdV1BlI0w
	 GGwFRoD7k11kekk4t2+1FC3wuUCYx06pXBP662kD39999B28n+l4TqKzc1usL4ggpJC7L
	 idqpJzmS5tpFR4TPVNtcWqPJDapyPPE77Fm0pm9+JgpEOimHqBeK5gbR2NhBbms4xyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vv7iWvrhzRgOy1Mx7vOwvNiwHytfyJA9BZLJCBqfJOI=;
	b=USqoot70QnluoixF1U1OMxyHa4Kr/L/whncPrjxqXayb/2n7hYOhqMm1Rkmdw0y5OSc8
	 xyWATQ3qfAeFC0Langre9Me1Fi1jvhX4DZ07Q89qOSS3uQcgmlk3VtWvAKq7lJLiNYoMg
	 R/gPHWU2M9GPyS9qYhoPrrXCIdYGjsX9YLj84UY2kwnSsjt2YNRWBmPhi0L95TT1ZBZpH
	 eNuIQ70lW4UI0W6eyxFZTvX+bYg8TsJnAur8kFvUtsiqrau4HF49oPrC+Z9qqp23tW5Sm
	 nNccHUndTv4XluUp39CfPuVdKEnqE/92P9M5lhX8AzqLxs06FSOcPC+UTGknwHya65g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEnpSFJK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5F0606A332;
	Sat,  7 Nov 2026 14:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEnpSFJK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194841F0089F;
	Sat,  7 Nov 2026 14:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062649;
	bh=Vv7iWvrhzRgOy1Mx7vOwvNiwHytfyJA9BZLJCBqfJOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEnpSFJKHUkSqlFKsLgkh1wBsmlpZxrI/l3ccXob1rQ/XXgzOMe4GoQ0ez1oqsKCt
	 VbwcK90SSX3d9npZT2OQqcVFl+ecHBf79rNR4avgTtwDvuac3ps4kzTIenQba6L1QX
	 F+cslLLysMICsviZNQrvZIbM76F2Vciqz+BJ/Tb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1514/1536] nvmet: Free the old negotiation state when restarting authentication
Date: Sat,  7 Nov 2026 08:58:50 -0500
Message-ID: <20261107135040.389895130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ba12b59c67304..de4fd9eeeafb0 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -240,6 +240,7 @@ void nvmet_auth_sq_free(struct nvmet_sq *sq)
 	sq->dhchap_c2 = NULL;
 	kfree(sq->dhchap_skey);
 	sq->dhchap_skey = NULL;
+	sq->dhchap_skey_len = 0;
 }
 
 void nvmet_auth_sq_destroy(struct nvmet_sq *sq)
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 72446965028c5..cfd1fc6032593 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -279,6 +279,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			/* Restart negotiation */
 			pr_debug("%s: ctrl %d qid %d reset negotiation\n",
 				 __func__, ctrl->cntlid, req->sq->qid);
+			nvmet_auth_sq_free(req->sq);
 			if (!req->sq->qid) {
 				dhchap_status = nvmet_setup_auth(ctrl);
 				if (dhchap_status) {
-- 
2.53.0



