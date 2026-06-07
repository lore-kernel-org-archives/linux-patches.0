Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EE11DE8AE;
	Sun,  7 Jun 2026 10:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826957; cv=none; b=pIZ4dEDe2/dGKAAaobEnWoCv+BFf+4HKqkQEjKM5Hc2zgWzi5oCyFY6JbIIh7jlNngToLs9fq33J1uYYO3/68hmAVE6siQUEsqk7SEbzpiQgBBUS0/AasardvkssdebDUZ5Bby0+8No2kaDyuLJPtGEGwhpbhTQfqIKIVSOC/3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826957; c=relaxed/simple;
	bh=E6CjjOX3DAn6sBZqeUgIeuj0GHeynp5xpc34TGmJNYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tt2W9hPHLdmxYt4V3jLN/2EmixEMGm6KQ0IMHeWRITpq5A56K7X6v2R1vR1z3DR/Vl1V7bmWlRVxxv4xy92Q35ZIPddjj8yiiORxHpwj/hKnBMMAN4w9SGwUbT3skF7wZsyUgPoVDP9UB/KBKw6NCOXDhipqjafD9J5q2YX6134=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrML7Ys9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrML7Ys9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8341F00893;
	Sun,  7 Jun 2026 10:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826956;
	bh=F0/76JCqf5Y/Ej6eYWSN/RNgVbFhEZXdqmG4obSUfFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrML7Ys9NMkblfwF4JVZTs64RK6WpKRlV3bEJ9Bj58JEgbdMHSLbVPdaPLv8VbzsV
	 Y9KfBjmVilxdh+z/dpfGwDNh6utpvPPzVpYimXZMCtXjBGRsnWSAchaJ3L5m9nY7so
	 C7KxkTOXpPLdSVGWxWVGDHIupsLX8maXtSAw9IHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/315] net/iucv: fix locking in .getsockopt
Date: Sun,  7 Jun 2026 11:56:53 +0200
Message-ID: <20260607095728.455846802@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3589d20a666caf30ad100c960a2de7de390fce88 ]

Mirror iucv_sock_setsockopt() and wrap the whole switch in
lock_sock()/release_sock(). The pre-existing SO_MSGLIMIT-only lock
becomes redundant and is removed.

Any AF_IUCV HIPER user can potentially crash the kernel by racing
recvmsg() with getsockopt(SO_MSGSIZE): the SO_MSGSIZE arm dereferences
iucv->hs_dev->mtu after iucv_sock_close() (called from the racing
recvmsg()) has set hs_dev to NULL, producing a NULL pointer dereference
oops.

Suggested-by: Stanislav Fomichev <sdf.kernel@gmail.com>
Fixes: 51363b8751a6 ("af_iucv: allow retrieval of maximum message size")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Tested-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20260521-af_iucv_fix2-v1-1-f16b1c510aa9@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 6c717a7ef29283..c66b90c912e78e 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1538,7 +1538,7 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
 	unsigned int val;
-	int len;
+	int len, rc;
 
 	if (level != SOL_IUCV)
 		return -ENOPROTOOPT;
@@ -1551,26 +1551,34 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 
 	len = min_t(unsigned int, len, sizeof(int));
 
+	rc = 0;
+
+	lock_sock(sk);
 	switch (optname) {
 	case SO_IPRMDATA_MSG:
 		val = (iucv->flags & IUCV_IPRMDATA) ? 1 : 0;
 		break;
 	case SO_MSGLIMIT:
-		lock_sock(sk);
 		val = (iucv->path != NULL) ? iucv->path->msglim	/* connected */
 					   : iucv->msglimit;	/* default */
-		release_sock(sk);
 		break;
 	case SO_MSGSIZE:
-		if (sk->sk_state == IUCV_OPEN)
-			return -EBADFD;
+		if (sk->sk_state == IUCV_OPEN) {
+			rc = -EBADFD;
+			break;
+		}
 		val = (iucv->hs_dev) ? iucv->hs_dev->mtu -
 				sizeof(struct af_iucv_trans_hdr) - ETH_HLEN :
 				0x7fffffff;
 		break;
 	default:
-		return -ENOPROTOOPT;
+		rc = -ENOPROTOOPT;
+		break;
 	}
+	release_sock(sk);
+
+	if (rc)
+		return rc;
 
 	if (put_user(len, optlen))
 		return -EFAULT;
-- 
2.53.0



