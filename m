Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037059;
	b=BApPGtzWVCEfvzU/ke4TfjrX7h4C4KJ4pkccuPsezKpRTWN6AJHAx0QI4Hgq7yoal2wg
	 Xi/z7ljdpK2PKPebSlhynviSeH/tHq+O5v1qCmAM014tythJT+aQBvAX+SMTrvzhj1A1Q
	 1GfHOp+N7iVn5Qdv0XTLotPh3XpCUsuHvqJLROciUXEyAYWUBn3v46et7w3CrMAxspqWZ
	 wSxEWF+ERIZ6qOyypQj4OKUmD/zx/Ou8AuOnQAS1tj2nM5K+jvMxm4hl/X2cMlD+cWFvq
	 C6UPduvCf2TqHGlKU9To60wEtW+8or+TrGrhvU5YDQX81wx9YCwuHtbg6jAa+hgRb4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iSHAxM4t1OcS94VNRcUQQHPpQ33OjusQp/F/I287J/U=;
	b=XbzUcwOlbwLVMy4AO3q6QBUkLF5sJ5iBkO4MuH0UyMu4j1HUUuCvS+AgpP/xzBp2bsd4
	 xi7jdXXx6qw0VwXTljHANbE609VOO1G9xsnTeXckmWvg+cOoLzBAqfXhkhwmAtm2qM0uv
	 H9WgxE75glLSE8N5dc+nWB/YZvSZOuDxI91x1FkWvcV0ygatzjT9QjqoMBLubeR+BrdUr
	 7t47CdLoqtH5Fil0QC6fX951y9pLtSi6gxIJwrswuetsqrUzhe0FzKWc6uC9pN70XS+Gq
	 gaqJyI/bVycSRCf50dXze6PoTaA0n7HO4jlMQTqN95WhRQvg5FbcaE1SnzPEApLsSEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCSSOyVh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86632606A331;
	Wed, 18 Nov 2026 21:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCSSOyVh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2F21F000C4;
	Wed, 18 Nov 2026 21:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037059;
	bh=iSHAxM4t1OcS94VNRcUQQHPpQ33OjusQp/F/I287J/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCSSOyVhbQpo4NwnI+ITdn1LJLytKsvEPWUcNFUCl3X8iKRykCpZeEK4iB83hVycG
	 0uzGbFf5RBOATmOYJlZj9MbBuyayKoimbF5bTXghn/AcAPo/cybu+y9I5Qyt38Sa40
	 jpkhz+kkacdYYSoxABb1QvtKivSDTH/ytV6GqFZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1278/3318] nvmet: Free the old negotiation state when restarting authentication
Date: Wed, 18 Nov 2026 15:31:40 +0100
Message-ID: <20261118150358.582561908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 59762bbb98da3..6ed832c4ec964 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -226,6 +226,7 @@ void nvmet_auth_sq_free(struct nvmet_sq *sq)
 	sq->dhchap_c2 = NULL;
 	kfree(sq->dhchap_skey);
 	sq->dhchap_skey = NULL;
+	sq->dhchap_skey_len = 0;
 }
 
 void nvmet_auth_sq_destroy(struct nvmet_sq *sq)
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index aed3d4de1133c..24bd7b45a6d84 100644
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



