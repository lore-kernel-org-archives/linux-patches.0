Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB52E9EBF;
	Tue, 15 Jul 2025 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586772; cv=none; b=i7HzmOPIgsdby4c2m+DNTYmKONoRlCXQX19P/TtHYmqFpcEg3wtOiwlIOKFiA2k29degL40a31PiOps+49fjDxipz+9WrwGE9fzQ0I7hKfx+EOveMTgCbHN4XSXcs4rn4LPx1QJ98j80paMHHI49WWiRxYvoG+nKpj4Jc9RKpdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586772; c=relaxed/simple;
	bh=FsNG3ndXljPyU4Fr+NKKLlWRJBwQUkfEuZ2TqknJIbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoHxgO/uISBNXvqHRxULZ2RVw95dU7JYR5lJoQnVrKePeDAGCSPgVsHMGO31+dWRFAXeKZByO7Tvo9hV9y2Yi9ympeenWJPUSijXzy6aIO5iqfsq8csPi0bPcgt7Pb/ipP4PAZj64rcGODF51rr/pyxpBxt6PwQjtA14aQJYCnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9yCqbXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9yCqbXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB45DC4CEE3;
	Tue, 15 Jul 2025 13:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586772;
	bh=FsNG3ndXljPyU4Fr+NKKLlWRJBwQUkfEuZ2TqknJIbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9yCqbXjhNf4IQO0chO6SCSiyehdLuBMYR46ZEF/TztDOEXBI3tjhaMoCOgkU3bnY
	 hT/xM+z5n66JHlD6Q8pQPwsWTM9mu2/laLAhFLbv8vFaiVUFtFp3TnkQkHr1b1yPcS
	 fYsAUcFTc1Fnng+HFRxniCRx2sJzhUWPdBjJ/TGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 042/192] atm: clip: Fix memory leak of struct clip_vcc.
Date: Tue, 15 Jul 2025 15:12:17 +0200
Message-ID: <20250715130816.542157413@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 62dba28275a9a3104d4e33595c7b3328d4032d8d ]

ioctl(ATMARP_MKIP) allocates struct clip_vcc and set it to
vcc->user_back.

The code assumes that vcc_destroy_socket() passes NULL skb
to vcc->push() when the socket is close()d, and then clip_push()
frees clip_vcc.

However, ioctl(ATMARPD_CTRL) sets NULL to vcc->push() in
atm_init_atmarp(), resulting in memory leak.

Let's serialise two ioctl() by lock_sock() and check vcc->push()
in atm_init_atmarp() to prevent memleak.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250704062416.1613927-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/clip.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/atm/clip.c b/net/atm/clip.c
index f36f2c7d87146..9c9c6c3d98861 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -645,6 +645,9 @@ static struct atm_dev atmarpd_dev = {
 
 static int atm_init_atmarp(struct atm_vcc *vcc)
 {
+	if (vcc->push == clip_push)
+		return -EINVAL;
+
 	mutex_lock(&atmarpd_lock);
 	if (atmarpd) {
 		mutex_unlock(&atmarpd_lock);
@@ -669,6 +672,7 @@ static int atm_init_atmarp(struct atm_vcc *vcc)
 static int clip_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
 	struct atm_vcc *vcc = ATM_SD(sock);
+	struct sock *sk = sock->sk;
 	int err = 0;
 
 	switch (cmd) {
@@ -689,14 +693,18 @@ static int clip_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		err = clip_create(arg);
 		break;
 	case ATMARPD_CTRL:
+		lock_sock(sk);
 		err = atm_init_atmarp(vcc);
 		if (!err) {
 			sock->state = SS_CONNECTED;
 			__module_get(THIS_MODULE);
 		}
+		release_sock(sk);
 		break;
 	case ATMARP_MKIP:
+		lock_sock(sk);
 		err = clip_mkip(vcc, arg);
+		release_sock(sk);
 		break;
 	case ATMARP_SETENTRY:
 		err = clip_setentry(vcc, (__force __be32)arg);
-- 
2.39.5



