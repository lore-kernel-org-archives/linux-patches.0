Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C352576;
	Mon,  2 Jun 2025 14:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874344; cv=none; b=RpFYiqCOPS6iwydTAbZbzzwNWBkQyfXFTsKDUsQHd8UGJoU24HYeMtB0MJljhm0/IM3pV2Dl8mpIUS0ZX1bhIfz2+DUDA8qC9IMQileNvfV3zs7V90GjVheJjupcwNHptLbyKQon46OMVZONZNF/u0welFKKwqpKgSlr3Xvz5fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874344; c=relaxed/simple;
	bh=0rMAJWqPfJXqV+CS0E3KADiPG99EWsA/+kA7pHZfoaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5WXZafaxEblEIeTbKStMN3gOkdZyYy1dyJ4p6iqYvJn517qTojqubMEGoof0L2s3WYSf6FQvjLnVTufzYNXIYzrcsbYTsFbWJORXgzkn0u0vaklwldVY/fAd5jipZcEhy/bHdg1Q1rqFaHwvOHlCpXPKCVBy3ytUdniy1bhszY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTcZmzIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTcZmzIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA19C4CEEB;
	Mon,  2 Jun 2025 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874343;
	bh=0rMAJWqPfJXqV+CS0E3KADiPG99EWsA/+kA7pHZfoaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTcZmzIR178LOWK0zwb/en46rzpcPuI2sKrT20EBg3s4hpEmf9NE9JTj6OtC4qiqU
	 atgBImw8UgUV+jfUL1UlqI874Nw0oO3Zl6//KGi2zapqr8tGd9oSjtgikdK7LZ0NOg
	 Td8HHClOl32dZd+Ga44TPax8y+7/9wh1lkRA5+bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 407/444] af_unix: Save listener for embryo socket.
Date: Mon,  2 Jun 2025 15:47:51 +0200
Message-ID: <20250602134357.447442849@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit aed6ecef55d70de3762ce41c561b7f547dbaf107 upstream.

This is a prep patch for the following change, where we need to
fetch the listening socket from the successor embryo socket
during GC.

We add a new field to struct unix_sock to save a pointer to a
listening socket.

We set it when connect() creates a new socket, and clear it when
accept() is called.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240325202425.60930-8-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    1 +
 net/unix/af_unix.c    |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -83,6 +83,7 @@ struct unix_sock {
 	struct path		path;
 	struct mutex		iolock, bindlock;
 	struct sock		*peer;
+	struct sock		*listener;
 	struct unix_vertex	*vertex;
 	struct list_head	link;
 	unsigned long		inflight;
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -978,6 +978,7 @@ static struct sock *unix_create1(struct
 	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
 	sk->sk_destruct		= unix_sock_destructor;
 	u = unix_sk(sk);
+	u->listener = NULL;
 	u->inflight = 0;
 	u->vertex = NULL;
 	u->path.dentry = NULL;
@@ -1582,6 +1583,7 @@ restart:
 	newsk->sk_type		= sk->sk_type;
 	init_peercred(newsk);
 	newu = unix_sk(newsk);
+	newu->listener = other;
 	RCU_INIT_POINTER(newsk->sk_wq, &newu->peer_wq);
 	otheru = unix_sk(other);
 
@@ -1677,8 +1679,8 @@ static int unix_accept(struct socket *so
 		       bool kern)
 {
 	struct sock *sk = sock->sk;
-	struct sock *tsk;
 	struct sk_buff *skb;
+	struct sock *tsk;
 	int err;
 
 	err = -EOPNOTSUPP;
@@ -1703,6 +1705,7 @@ static int unix_accept(struct socket *so
 	}
 
 	tsk = skb->sk;
+	unix_sk(tsk)->listener = NULL;
 	skb_free_datagram(sk, skb);
 	wake_up_interruptible(&unix_sk(sk)->peer_wait);
 


