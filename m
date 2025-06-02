Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99712222CA;
	Mon,  2 Jun 2025 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874275; cv=none; b=DWdn/uZeJpqJhfmprfvVSkbN3GHnzKGMdJgSG/lSe33/XU0nrBlJlcTbchRvAcZsgsqAp1zQ0s+Cax2s2rdc4ZUKdSmQNdvzKZSx9ZwP30D8Qon4nFl2rgalmg8sBLQENHeeyZKsVKFeiFehMNQ681VzR6CwQDa3DImrJliCa9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874275; c=relaxed/simple;
	bh=cmWZrq13fe+dyMHnfKW7YmwSmpytxVRyRYGHXlVlZvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wt+W+Ya8oqifQbio/auC1mrOn/VChUqrUTECE+V1i4bJF/49LlHeGv2DakhArnk7E5CaJO6jnaO63jyh0vz9DcXhDBurXYPO269ked19sQXEV14J6KWKv6JeI5Vygsyf95rC0G7n3Z91RCUOvihfQxJgyb2onGiKnTiURre3FqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRPQ/9lS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRPQ/9lS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F312CC4CEEB;
	Mon,  2 Jun 2025 14:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874274;
	bh=cmWZrq13fe+dyMHnfKW7YmwSmpytxVRyRYGHXlVlZvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRPQ/9lSK2ByZJpHTu96HQUnB5ZRBU0Z0jPpWQ284k/Hc3u5acLducm126qgXDyVH
	 w8q/YEFyoS0qQloSK2116DEJPU7AzN2lZmACKJDpz+ydYty5iT9ahCVJ6mUrG3tcPL
	 EI86fCsWi1VL1t79+lVejriJrhyrrCRmY2Rr2v7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, kernel test robot" <oliver.sang@intel.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Lee Jones <lee@kernel.org>,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH 6.6 416/444] af_unix: Try not to hold unix_gc_lock during accept().
Date: Mon,  2 Jun 2025 15:48:00 +0200
Message-ID: <20250602134357.823735075@linuxfoundation.org>
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

commit fd86344823b521149bb31d91eba900ba3525efa6 upstream.

Commit dcf70df2048d ("af_unix: Fix up unix_edge.successor for embryo
socket.") added spin_lock(&unix_gc_lock) in accept() path, and it
caused regression in a stress test as reported by kernel test robot.

If the embryo socket is not part of the inflight graph, we need not
hold the lock.

To decide that in O(1) time and avoid the regression in the normal
use case,

  1. add a new stat unix_sk(sk)->scm_stat.nr_unix_fds

  2. count the number of inflight AF_UNIX sockets in the receive
     queue under unix_state_lock()

  3. move unix_update_edges() call under unix_state_lock()

  4. avoid locking if nr_unix_fds is 0 in unix_update_edges()

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202404101427.92a08551-oliver.sang@intel.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240413021928.20946-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    1 +
 net/unix/af_unix.c    |    2 +-
 net/unix/garbage.c    |   20 ++++++++++++++++----
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -67,6 +67,7 @@ struct unix_skb_parms {
 
 struct scm_stat {
 	atomic_t nr_fds;
+	unsigned long nr_unix_fds;
 };
 
 #define UNIXCB(skb)	(*(struct unix_skb_parms *)&((skb)->cb))
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1703,12 +1703,12 @@ static int unix_accept(struct socket *so
 	}
 
 	tsk = skb->sk;
-	unix_update_edges(unix_sk(tsk));
 	skb_free_datagram(sk, skb);
 	wake_up_interruptible(&unix_sk(sk)->peer_wait);
 
 	/* attach accepted sock to socket */
 	unix_state_lock(tsk);
+	unix_update_edges(unix_sk(tsk));
 	newsock->state = SS_CONNECTED;
 	unix_sock_inherit_flags(sock, newsock);
 	sock_graft(tsk, newsock);
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -209,6 +209,7 @@ void unix_add_edges(struct scm_fp_list *
 		unix_add_edge(fpl, edge);
 	} while (i < fpl->count_unix);
 
+	receiver->scm_stat.nr_unix_fds += fpl->count_unix;
 	WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + fpl->count_unix);
 out:
 	WRITE_ONCE(fpl->user->unix_inflight, fpl->user->unix_inflight + fpl->count);
@@ -222,6 +223,7 @@ out:
 
 void unix_del_edges(struct scm_fp_list *fpl)
 {
+	struct unix_sock *receiver;
 	int i = 0;
 
 	spin_lock(&unix_gc_lock);
@@ -235,6 +237,8 @@ void unix_del_edges(struct scm_fp_list *
 		unix_del_edge(fpl, edge);
 	} while (i < fpl->count_unix);
 
+	receiver = fpl->edges[0].successor;
+	receiver->scm_stat.nr_unix_fds -= fpl->count_unix;
 	WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - fpl->count_unix);
 out:
 	WRITE_ONCE(fpl->user->unix_inflight, fpl->user->unix_inflight - fpl->count);
@@ -246,10 +250,18 @@ out:
 
 void unix_update_edges(struct unix_sock *receiver)
 {
-	spin_lock(&unix_gc_lock);
-	unix_update_graph(unix_sk(receiver->listener)->vertex);
-	receiver->listener = NULL;
-	spin_unlock(&unix_gc_lock);
+	/* nr_unix_fds is only updated under unix_state_lock().
+	 * If it's 0 here, the embryo socket is not part of the
+	 * inflight graph, and GC will not see it, so no lock needed.
+	 */
+	if (!receiver->scm_stat.nr_unix_fds) {
+		receiver->listener = NULL;
+	} else {
+		spin_lock(&unix_gc_lock);
+		unix_update_graph(unix_sk(receiver->listener)->vertex);
+		receiver->listener = NULL;
+		spin_unlock(&unix_gc_lock);
+	}
 }
 
 int unix_prepare_fpl(struct scm_fp_list *fpl)


