Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC103D45CB;
	Tue, 16 Jun 2026 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633300; cv=none; b=HNhjcTfN0feJhBVxTIvAD+CEaN6ssZoTu+hCUgGW8G8VAfwZBHNMWWWgeKOGpeS4AYNdKHpEPM5ZHOs021nk/fRXs0c/euDwzi9A/zXiUpi2l3OXZT70I15hqP83UFF6QboIOUXOvzASxqCXuyQEWy7gMGvS6ARfZW/JnpSCsAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633300; c=relaxed/simple;
	bh=+u/zyOq3AHe331UweUAigjygqtWfeUGb8hea/PiUI4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPd5aC8Lsli3mT4hmpONJLEL4JbGUrmAMvvGRbuTtJm/kW0sEkApqJHtszMl0lnTLY3pBZi9P1cJxr6PZ8HxVmfxrgcZFAW8J7XGYWByv7FCMCMjLiY/9D7CmDqe1ckjD+8eTJ+tav8rkOPJINaLQstzER8Bit8mNZ0nYPhExVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/jsa4Nq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/jsa4Nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A78F1F000E9;
	Tue, 16 Jun 2026 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633299;
	bh=X7xz2iv3AiNOLtmd9H+zdzGLhcBc66YnyAxefFB/CaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/jsa4NqD+L7txV3YIDjcTX3cL6eb3kHJK1w0VdgS+BdTWd6CGddLq0TdWXjbcFOu
	 Z5csE6Qz8TOLTpxGqlEm0f5T8n6vEdhRfGrJQBdNmA0JArxMAY14xUIU6XB3nXqbfZ
	 /UaJltB3cmpNFDr79S1EJYnzhKPgjTdXbV2j91N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/411] net/iucv: fix locking in .getsockopt
Date: Tue, 16 Jun 2026 20:24:17 +0530
Message-ID: <20260616145101.407519169@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e6cb3e1cbbf9b8..3188d719a2e42d 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1533,7 +1533,7 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
 	unsigned int val;
-	int len;
+	int len, rc;
 
 	if (level != SOL_IUCV)
 		return -ENOPROTOOPT;
@@ -1546,26 +1546,34 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 
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



