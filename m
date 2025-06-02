Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272F91B81DC;
	Mon,  2 Jun 2025 14:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874214; cv=none; b=oJo7e+ZHXvuEQNT/TixMo2VGSZVhGHObsQGDA19TW82zUnIOcRhLd20F/KAmJeolC6eClp1EV3csCw01VKHzUk5FLDpvDYgmfOSMSDtUxb8L+3ScF7MM5G0ESJHnvGNR/gOrRPEYf0GS6cU6gI+4fESy3/3ONcpRVBUohMFRMBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874214; c=relaxed/simple;
	bh=mP6L7XKcQaG38K7qXAf7dM7D9B2uzCBgrplSwZTWV8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDsDBcB9zt96U+cgtZmRDePvgwBeo2c0QsasZTxpE0cU1IHnrTXUu7dD2fJ2TDGCLSLmJk0ycyo7vdmydNlVILMR6O9vRfBceCThoXzs1tHH5dVTZtZwp8fKtDAwoFlLzbmA70zv06iVv6zg8Ylaq3ezUeMqXkgU/UV5QWTcyto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dujWSc39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dujWSc39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C92AC4CEEE;
	Mon,  2 Jun 2025 14:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874214;
	bh=mP6L7XKcQaG38K7qXAf7dM7D9B2uzCBgrplSwZTWV8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dujWSc39Qd+HqcFXjp9mizaMFzN6JoDfRQoQn7xD3Ypzo7ygVjZC6qf2oCd6wVLTR
	 uacMRfs6LV/9+CS8Vs+JjcdnnbYGbntgFNR1hcXImTe7zOfRS/qYzu/bwzQOpNRFYV
	 vPAe9VyZN8yajHX8BE6ThadDWar/XMzXQx3OLlFg=
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
Subject: [PATCH 6.6 395/444] af_unix: Return struct unix_sock from unix_get_socket().
Date: Mon,  2 Jun 2025 15:47:39 +0200
Message-ID: <20250602134356.939886853@linuxfoundation.org>
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
@@ -14,7 +14,7 @@ void unix_destruct_scm(struct sk_buff *s
 void io_uring_destruct_scm(struct sk_buff *skb);
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
@@ -34,10 +33,10 @@ struct sock *unix_get_socket(struct file
 
 		/* PF_UNIX ? */
 		if (s && ops && ops->family == PF_UNIX)
-			u_sock = s;
+			return unix_sk(s);
 	}
 
-	return u_sock;
+	return NULL;
 }
 EXPORT_SYMBOL(unix_get_socket);
 
@@ -46,13 +45,11 @@ EXPORT_SYMBOL(unix_get_socket);
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
@@ -69,13 +66,11 @@ void unix_inflight(struct user_struct *u
 
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
 


