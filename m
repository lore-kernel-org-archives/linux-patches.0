Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B1638C437;
	Tue, 16 Jun 2026 18:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635451; cv=none; b=hnfkV5wgD1gif6fm3jhWjOTGiJ5VaZ30XDbNPNuyBn/yuGr6/6KRqWBKBYdLjKbgrGyi6o24TAE3jvFwQ7jPX7E8kZtbtJLyq9Xsqitkh+GosAmhgTny1bHI2GXCwChCC+YKOP99MmWR/IsUIa4N16Mp2A7deZQYuTrH1zCOnK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635451; c=relaxed/simple;
	bh=Bdoq9BWkdVKFSJJeoU0mG0w8v0M02a7nb6F+b+Mg1U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSjaFgBodJyvr51jKLnX/h+WlHBU0+JLRl2it7v/JfTAsU55HgR7c7dIM/EfVuP8Ca3f6FM4rjXHr1G4BXNhi6N59IL9yX2tnSOdDML2z43o2zpnX1eLgtq9hgKPfJ2LIKBrSnrswoXKu6bHiSmA5CD1lqXeko2ROQvZ8D6f5aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CK+P9V2H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CK+P9V2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835A31F000E9;
	Tue, 16 Jun 2026 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635450;
	bh=2sPQAMDj4dl9eIlPSxukx0VUBh4e6q5+ymPjP6RdgbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CK+P9V2HQZG8DwpERycp4JLInBcwdsadYTYTO5cDaBvhaWBKHN/JPz6eqqbhmyQh+
	 9+dprM+5bkOOvQth/OS98NG48cP4DjqJiWZGcHv0pKfBkVV1DLUINhpKzfVa+apalq
	 ebj4LNY6rdv3QMLfETMSFeR4Zve78AVlyRnC0upc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/342] net/iucv: fix locking in .getsockopt
Date: Tue, 16 Jun 2026 20:25:14 +0530
Message-ID: <20260616145049.122137648@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3d0424e4ae6c9c..8c08f07ce46551 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1550,7 +1550,7 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
 	unsigned int val;
-	int len;
+	int len, rc;
 
 	if (level != SOL_IUCV)
 		return -ENOPROTOOPT;
@@ -1563,26 +1563,34 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 
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



