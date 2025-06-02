Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D6220E026;
	Mon,  2 Jun 2025 15:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877482; cv=none; b=tCaSC3FS+g9km0N+dJFAtrI0dq8E3WigEDLZALtfTPlh2ryonSDZ0xgmA3VQgfoMHws0VHhiQaZLzHF152deuXeirc5HYvjBaT7wbNc4TCuSVozwuyVOGen3HcJdbmMUMy1oFFAsidvIVP7bVHlONJ6r8o5i0ASxAsQU4aEx/O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877482; c=relaxed/simple;
	bh=sFzijGUe2J1e43mYV73sPgCAyUjf14rasx9eBRe+/aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SliF4cIiQLdyH3rSxZ3+lamBUaM6x7Vfbs1attAl/znwaZqdO6ira4SsBqk2BFhXytBgV/p5hGeUza9OHASl+ABR+vTExnccPsuUXIGYk4HA4d0j1LLBGoAROEQBOVnyqKTj3ClVhcok5m0byyjS0Y46Xx/ZecCAeGgRfy4ZtZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwMfqJVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwMfqJVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D76C4CEEE;
	Mon,  2 Jun 2025 15:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877482;
	bh=sFzijGUe2J1e43mYV73sPgCAyUjf14rasx9eBRe+/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwMfqJVV1tJOeD8gErmZy2VwiFSqZ7+jRJHRq5Ly9IoQbhbkA2gZpBIdw7qqCWZSl
	 kTz6zNJbjv6ZdZpVfgCygTbxchh+F0y1w/ZLJUW6TBUyTee6xBNcSMHO63OWA6xX0Z
	 FyXvU/aLlVDDffznxhHfJ+o/gXwJC9LyWduq92So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 291/325] af_unix: Bulk update unix_tot_inflight/unix_inflight when queuing skb.
Date: Mon,  2 Jun 2025 15:49:27 +0200
Message-ID: <20250602134331.728639079@linuxfoundation.org>
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

commit 22c3c0c52d32f41cc38cd936ea0c93f22ced3315 upstream.

Currently, we track the number of inflight sockets in two variables.
unix_tot_inflight is the total number of inflight AF_UNIX sockets on
the host, and user->unix_inflight is the number of inflight fds per
user.

We update them one by one in unix_inflight(), which can be done once
in batch.  Also, sendmsg() could fail even after unix_inflight(), then
we need to acquire unix_gc_lock only to decrement the counters.

Let's bulk update the counters in unix_add_edges() and unix_del_edges(),
which is called only for successfully passed fds.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240325202425.60930-5-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/garbage.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -144,6 +144,7 @@ static void unix_free_vertices(struct sc
 }
 
 DEFINE_SPINLOCK(unix_gc_lock);
+unsigned int unix_tot_inflight;
 
 void unix_add_edges(struct scm_fp_list *fpl, struct unix_sock *receiver)
 {
@@ -168,7 +169,10 @@ void unix_add_edges(struct scm_fp_list *
 		unix_add_edge(fpl, edge);
 	} while (i < fpl->count_unix);
 
+	WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + fpl->count_unix);
 out:
+	WRITE_ONCE(fpl->user->unix_inflight, fpl->user->unix_inflight + fpl->count);
+
 	spin_unlock(&unix_gc_lock);
 
 	fpl->inflight = true;
@@ -191,7 +195,10 @@ void unix_del_edges(struct scm_fp_list *
 		unix_del_edge(fpl, edge);
 	} while (i < fpl->count_unix);
 
+	WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - fpl->count_unix);
 out:
+	WRITE_ONCE(fpl->user->unix_inflight, fpl->user->unix_inflight - fpl->count);
+
 	spin_unlock(&unix_gc_lock);
 
 	fpl->inflight = false;
@@ -234,7 +241,6 @@ void unix_destroy_fpl(struct scm_fp_list
 	unix_free_vertices(fpl);
 }
 
-unsigned int unix_tot_inflight;
 static LIST_HEAD(gc_candidates);
 static LIST_HEAD(gc_inflight_list);
 
@@ -255,13 +261,8 @@ void unix_inflight(struct user_struct *u
 			WARN_ON_ONCE(list_empty(&u->link));
 		}
 		u->inflight++;
-
-		/* Paired with READ_ONCE() in wait_for_unix_gc() */
-		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + 1);
 	}
 
-	WRITE_ONCE(user->unix_inflight, user->unix_inflight + 1);
-
 	spin_unlock(&unix_gc_lock);
 }
 
@@ -278,13 +279,8 @@ void unix_notinflight(struct user_struct
 		u->inflight--;
 		if (!u->inflight)
 			list_del_init(&u->link);
-
-		/* Paired with READ_ONCE() in wait_for_unix_gc() */
-		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - 1);
 	}
 
-	WRITE_ONCE(user->unix_inflight, user->unix_inflight - 1);
-
 	spin_unlock(&unix_gc_lock);
 }
 


