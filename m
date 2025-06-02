Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8479D227E95;
	Mon,  2 Jun 2025 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877450; cv=none; b=RnU9YCnMP95feqRqgv+1GSQm8fSleOpBa6QCpQACQdwM1bb9mZkf77ExITl1wK9MWZ7u7N6ymR28CP4wE98NF56TwInWTg5Jsf+UuhsQJbUhoVmqAMo4JuIahQybSmZOE3vJqVdqxMqoujo6F25AskygmEABos9WyGisIGl4DtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877450; c=relaxed/simple;
	bh=lSAL+1ANzt8B6ViQzD5EGFcWGnatSKjwwOOzsGdhHKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+0X2l6hPXzfNGHvyrWbJdFZp1CCwtNzvk4eMYQoUZDULDaaqr/ikD6XH1EMKfCiffEq5D32cfxl7CobotBVJo3DO+nPGHaKt1FEGnlfPPSGR4x3LYxg37SB3yugDDJnRQsqOV/Wrz05QriVUZg4KU2Dk4GcKEi6VTS0rGTNXJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcSCkXy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcSCkXy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC11C4CEEB;
	Mon,  2 Jun 2025 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877450;
	bh=lSAL+1ANzt8B6ViQzD5EGFcWGnatSKjwwOOzsGdhHKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcSCkXy04wBE0cn35xppgShZKnlnwdpfGaRENicqx5tzig5ICy5444JVjvVLkpfF1
	 3QwpEMZ896Hdj/fo5ePXpSVvudTObM7FEen0t/yPSbOi3kgIzgO9WEf7JsgQgS38Uu
	 aS1NcsknUJl7bwW3dFguhTLloKMpVDe3OnVdqpdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, Simon Horman" <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH 6.1 282/325] af_unix: Return struct unix_sock from unix_get_socket().
Date: Mon,  2 Jun 2025 15:49:18 +0200
Message-ID: <20250602134331.219556431@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 5b17307bd0789edea0675d524a2b277b93bbde62 upstream.

Currently, unix_get_socket() returns struct sock, but after calling
it, we always cast it to unix_sk().

Let's return struct unix_sock from unix_get_socket().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240123170856.41348-4-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    2 +-
 net/unix/garbage.c    |   19 +++++++------------
 net/unix/scm.c        |   19 +++++++------------
 3 files changed, 15 insertions(+), 25 deletions(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -13,7 +13,7 @@ void unix_notinflight(struct user_struct
 void unix_destruct_scm(struct sk_buff *skb);
 void unix_gc(void);
 void wait_for_unix_gc(void);
-struct sock *unix_get_socket(struct file *filp);
+struct unix_sock *unix_get_socket(struct file *filp);
 struct sock *unix_peer_get(struct sock *sk);
 
 #define UNIX_HASH_MOD	(256 - 1)
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -105,20 +105,15 @@ static void scan_inflight(struct sock *x
 
 			while (nfd--) {
 				/* Get the socket the fd matches if it indeed does so */
-				struct sock *sk = unix_get_socket(*fp++);
+				struct unix_sock *u = unix_get_socket(*fp++);
 
-				if (sk) {
-					struct unix_sock *u = unix_sk(sk);
+				/* Ignore non-candidates, they could have been added
+				 * to the queues after starting the garbage collection
+				 */
+				if (u && test_bit(UNIX_GC_CANDIDATE, &u->gc_flags)) {
+					hit = true;
 
-					/* Ignore non-candidates, they could
-					 * have been added to the queues after
-					 * starting the garbage collection
-					 */
-					if (test_bit(UNIX_GC_CANDIDATE, &u->gc_flags)) {
-						hit = true;
-
-						func(u);
-					}
+					func(u);
 				}
 			}
 			if (hit && hitlist != NULL) {
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -21,9 +21,8 @@ EXPORT_SYMBOL(gc_inflight_list);
 DEFINE_SPINLOCK(unix_gc_lock);
 EXPORT_SYMBOL(unix_gc_lock);
 
-struct sock *unix_get_socket(struct file *filp)
+struct unix_sock *unix_get_socket(struct file *filp)
 {
-	struct sock *u_sock = NULL;
 	struct inode *inode = file_inode(filp);
 
 	/* Socket ? */
@@ -33,10 +32,10 @@ struct sock *unix_get_socket(struct file
 
 		/* PF_UNIX ? */
 		if (s && sock->ops && sock->ops->family == PF_UNIX)
-			u_sock = s;
+			return unix_sk(s);
 	}
 
-	return u_sock;
+	return NULL;
 }
 EXPORT_SYMBOL(unix_get_socket);
 
@@ -45,13 +44,11 @@ EXPORT_SYMBOL(unix_get_socket);
  */
 void unix_inflight(struct user_struct *user, struct file *fp)
 {
-	struct sock *s = unix_get_socket(fp);
+	struct unix_sock *u = unix_get_socket(fp);
 
 	spin_lock(&unix_gc_lock);
 
-	if (s) {
-		struct unix_sock *u = unix_sk(s);
-
+	if (u) {
 		if (!u->inflight) {
 			BUG_ON(!list_empty(&u->link));
 			list_add_tail(&u->link, &gc_inflight_list);
@@ -68,13 +65,11 @@ void unix_inflight(struct user_struct *u
 
 void unix_notinflight(struct user_struct *user, struct file *fp)
 {
-	struct sock *s = unix_get_socket(fp);
+	struct unix_sock *u = unix_get_socket(fp);
 
 	spin_lock(&unix_gc_lock);
 
-	if (s) {
-		struct unix_sock *u = unix_sk(s);
-
+	if (u) {
 		BUG_ON(!u->inflight);
 		BUG_ON(list_empty(&u->link));
 


