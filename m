Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E201DE8AE;
	Sun,  7 Jun 2026 10:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826978; cv=none; b=tfB2Z3pldmS8rzKLufQ1KtiJh1jj9LXR4y7K5PmeWblvlhbFUVx2UZamiFXm2jk4E53VRKa6gMcbRNcm5ervx3oeu9TUhAY7W+sxOPwM9Cj+oNjkZIbdCvTaGnvgHw81wae7TEeh531IZFIVG7TwUgk2wuT1h+GxOOkXtka8tU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826978; c=relaxed/simple;
	bh=E6L3lwGTSLWbQSWHHVRqFYQbrIiQpVFGFqZ7/ZkXwyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhQ+CLPZ80LYeBV5nFBkwAuC69f1rYjigwIoikbbs56yHBMmFwjJ9jcrc0Jis+1abUxAGcCPIM6NhOewAR1lLXDYGIJ6yCQ3bbwvtRUJDuiUwKiFFdkIr9t1P2ykJ57IlPA2l3lXgFt1o2Lclk4OYJXDENK2a4tp03slbcaZ8vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d59L5ObM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d59L5ObM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833861F00893;
	Sun,  7 Jun 2026 10:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826977;
	bh=5SNWqrSQyOXtQs+mGfwRw2E1tZPtSocVJ+kxdqY8bAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d59L5ObMfNSt1pd6WJ1a2Wso+Q556ZjSn3IbgsUUBbB11tLDYqkA7NwnPcUSiiK5e
	 E5dvB5DSyF3NPJbTtUMwgYoD5uaN/fOsVIF/kaOhP5DXWlWJGpwpVFB/LYlnTFdZdy
	 aOB2PMsDg2F9YKIzv8ULx3PaMOJW3W9deCRJ9sp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 028/332] net/iucv: fix locking in .getsockopt
Date: Sun,  7 Jun 2026 11:56:37 +0200
Message-ID: <20260607095729.121105026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 6554d2cffc1961..30cbd98f941a98 100644
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



