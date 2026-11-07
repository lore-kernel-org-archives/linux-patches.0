Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063743;
	b=XOyPQTyp5i5alLTM7vUrxDxLlzqmDDUW7tFnxgfSB80VXo3BnWL0fYsPJ2QmAk9NeTBp
	 bgWi178qqsb9QRdm4u3LsLsXBu+ldKXq95seCvZFOPUY9lEAXpVzmy5/3XNbeWnd6qZPR
	 I7W2tWosTAGlCqJ1yFcEEFQ+4Ue7+pyuh59M2R6uDc1ZYO5xhB52NNzj1DR9MISPeWvus
	 1AfzdhbhQ5wi2pkk43h1a2Pdne9KIPAqIYxsMNBIp4ok+PI4yCEzT4sP7KjQeaUy6ulNm
	 Xu/GWMvBEhdisDjbPLC79KP9QUBCtQ3s8d+7UKBcSSPytsYR5YgjP4CnL1Vqc/Pa+0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v0fsq2V463YmL6GppVoHtc3WiouAG8/sPuhXy72EOFs=;
	b=rpMY34/H0q43roy2ZmXnw7MJgfBwDDLrNr+6QsXGa9+Yyq3zeESdafLQSlBJg9BBI8sG
	 PdrQBMFw4AlMBTvFzog/ax2HmTjgMxozDVMtYrOqypf7vsouBW2N9KGFHOOefDb0CvZJO
	 6iFfxS5NitqtRL0SEFHva4QdPblzVZrXx1SehZVFhtURqtBw9ykIdJh8YJY9zbl+6GxLi
	 QQUzeXoNxqIZsAtT3wC1KPQI5vPSCWwl7HUPM/Q9fTehLqJjw+X+C/FT6ZiddXkLtX/MX
	 kpzC9h4sJ3VnvV7Lj2qiMVP5zV+hgQK2kSaPvYAQb08XdMPOMa05as6vOEwmEvpLRRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMA0lW4O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2535606A32D;
	Sat,  7 Nov 2026 15:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMA0lW4O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CFE1F0089F;
	Sat,  7 Nov 2026 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063742;
	bh=v0fsq2V463YmL6GppVoHtc3WiouAG8/sPuhXy72EOFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMA0lW4O1GYr4WXgHxcEJ7QQ+DhRCnquZxAw0ReHYnApQti/4BTjVOHpteznGpbPT
	 t4t0zB+wKDQsReG4aj/qS8GIBBnK3EihIWauwEA3X3FIa71U8Vs6cXnJi0elHI7emm
	 C/wb/81qJVXD9P7Cn8+aVg5imx1r1pLWe4/Gf8tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 837/869] nvmet: Free the old negotiation state when restarting authentication
Date: Sat,  7 Nov 2026 08:58:39 -0500
Message-ID: <20261107134921.264380829@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4c68225411be3..eb2b6c7a80838 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -249,6 +249,7 @@ void nvmet_auth_sq_free(struct nvmet_sq *sq)
 	sq->dhchap_c2 = NULL;
 	kfree(sq->dhchap_skey);
 	sq->dhchap_skey = NULL;
+	sq->dhchap_skey_len = 0;
 }
 
 void nvmet_auth_sq_destroy(struct nvmet_sq *sq)
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index fc50fde2947d4..61a36fb54e877 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -326,6 +326,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			/* Restart negotiation */
 			pr_debug("%s: ctrl %d qid %d reset negotiation\n",
 				 __func__, ctrl->cntlid, req->sq->qid);
+			nvmet_auth_sq_free(req->sq);
 			if (!req->sq->qid) {
 				dhchap_status = nvmet_setup_auth(ctrl, req->sq,
 								 true);
-- 
2.53.0



