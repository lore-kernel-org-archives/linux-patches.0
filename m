Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8579D1E98EF;
	Sun,  7 Jun 2026 10:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827271; cv=none; b=KD3upxk2Sq64j8IqGHrkGhzFGIgmJEPvAN0QY7qrAISH3rVv+5Vgun59Hhm0Lwhrd4iSi8PD3FWy0KAJ/zRZoR6e8zcgOPu46eCkOXKpqzrQV9Uj40eQ7vVG2uP3cekBYj9zxiB5YKutvuYMyYJgRYeGOpQrQgUfVqwxDRMds3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827271; c=relaxed/simple;
	bh=v/bs8aqtI5HdZDDKBztVXa9QM88/NghD5rox98VhIqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sp1hrTj5OHX6Ekrn16G5FVq3NqoTjjOtO8aeFr9o5R0fUfet1PXL4s0EOyVw1TjBIzEcHwZAgr2NKbvd6czz7altf/HFHS1/cg8AIcm94L3P5bU8h//l13/Y89I0UUXgi+peAEki9pOofu7asalXpNC3k8zXcXZbRqIMBsLgUJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvF+bMo9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvF+bMo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38E11F00893;
	Sun,  7 Jun 2026 10:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827270;
	bh=9oDlDX6P5QbEKPzQk41v0t3e1No8lITDNOCi6RxaR4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvF+bMo9WN9N0ObMaP86OpW8vzGUHuRUK6z9OeR7s9z5EuXkge1WfuLbMoUYd9ZYg
	 QslzlWJeYjCZJuQlQTT/Y+MyPsv/59b/OpEIqMKEJwiuN3YOj/+RRZOsowUDIhzQzi
	 TdQZY3IM10zgysN6yYOQyRMNe3heVAhiTGSU1wPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/307] net/iucv: fix locking in .getsockopt
Date: Sun,  7 Jun 2026 11:57:17 +0200
Message-ID: <20260607095729.166033711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7929df08d4e023..1a0b41fcea8131 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1537,7 +1537,7 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
 	unsigned int val;
-	int len;
+	int len, rc;
 
 	if (level != SOL_IUCV)
 		return -ENOPROTOOPT;
@@ -1550,26 +1550,34 @@ static int iucv_sock_getsockopt(struct socket *sock, int level, int optname,
 
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



