Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8701A15FD13;
	Fri, 15 Nov 2024 06:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653850; cv=none; b=Xsld0+hehwk/OTOzVyNoIHA7+4RMhrvaTisSJVn3KKCaJgwCl4GpazJPpsRJ6k3ZhZVdEg4QsJLYVuqCm2xvT8GLE0eMW9X0cO+LDLz4Xpm354M7PsWNRNt0X3oOtChpIr+qFB0VHlxbx//HgByOm3hTdg+zy6dwPhMrj1o37rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653850; c=relaxed/simple;
	bh=RReTftOboVnllijtIXlU76jQJeInO9ZVPdkZ70sIMCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbB+XBPROYWmvOKHLGqJ51jIikOqDHAuNtP9+O5kYBab/RP8YQzaAW7MZQmTBfQ/zMQPkWOVzLFr7hf94q2befQ41rwd/nUOmpsBLU5vy84ZCtunqDsK4i8mTV2Hu6dD4ndMqr8s8pGEiLwEACOeKH2AhaG76c+DOaweo2DEAaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWHCvxxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWHCvxxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F231EC4CED0;
	Fri, 15 Nov 2024 06:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653850;
	bh=RReTftOboVnllijtIXlU76jQJeInO9ZVPdkZ70sIMCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWHCvxxNgzZ0waRftEivJmiOTWIctdFxP4/qef7JO81TL/awmDq6W/yUvHzYpCvMH
	 QiSsC/G+bo5IeVlUU2S1OxFJ/QVIXc0JqmWCji1u+koprQ2Ee9BgNLqIB0Dfkdpmco
	 N6qFlNXzsOD4rRnzeNPZXsPf1vJjUpu25u/8c3Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Abdelkareem Abdelsaamad <kareemem@amazon.com>
Subject: [PATCH 5.10 53/82] net: do not delay dst_entries_add() in dst_release()
Date: Fri, 15 Nov 2024 07:38:30 +0100
Message-ID: <20241115063727.471930745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

commit ac888d58869bb99753e7652be19a151df9ecb35d upstream.

dst_entries_add() uses per-cpu data that might be freed at netns
dismantle from ip6_route_net_exit() calling dst_entries_destroy()

Before ip6_route_net_exit() can be called, we release all
the dsts associated with this netns, via calls to dst_release(),
which waits an rcu grace period before calling dst_destroy()

dst_entries_add() use in dst_destroy() is racy, because
dst_entries_destroy() could have been called already.

Decrementing the number of dsts must happen sooner.

Notes:

1) in CONFIG_XFRM case, dst_destroy() can call
   dst_release_immediate(child), this might also cause UAF
   if the child does not have DST_NOCOUNT set.
   IPSEC maintainers might take a look and see how to address this.

2) There is also discussion about removing this count of dst,
   which might happen in future kernels.

Fixes: f88649721268 ("ipv4: fix dst race in sk_dst_get()")
Closes: https://lore.kernel.org/lkml/CANn89iLCCGsP7SFn9HKpvnKu96Td4KD08xf7aGtiYgZnkjaL=w@mail.gmail.com/T/
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20241008143110.1064899-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ resolved conflict due to bc9d3a9f2afc ("net: dst: Switch to rcuref_t
  reference counting") is not in the tree ]
Signed-off-by: Abdelkareem Abdelsaamad <kareemem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dst.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -109,9 +109,6 @@ struct dst_entry *dst_destroy(struct dst
 		child = xdst->child;
 	}
 #endif
-	if (!(dst->flags & DST_NOCOUNT))
-		dst_entries_add(dst->ops, -1);
-
 	if (dst->ops->destroy)
 		dst->ops->destroy(dst);
 	if (dst->dev)
@@ -162,6 +159,12 @@ void dst_dev_put(struct dst_entry *dst)
 }
 EXPORT_SYMBOL(dst_dev_put);
 
+static void dst_count_dec(struct dst_entry *dst)
+{
+	if (!(dst->flags & DST_NOCOUNT))
+		dst_entries_add(dst->ops, -1);
+}
+
 void dst_release(struct dst_entry *dst)
 {
 	if (dst) {
@@ -171,8 +174,10 @@ void dst_release(struct dst_entry *dst)
 		if (WARN_ONCE(newrefcnt < 0, "dst_release underflow"))
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
-		if (!newrefcnt)
+		if (!newrefcnt){
+			dst_count_dec(dst);
 			call_rcu(&dst->rcu_head, dst_destroy_rcu);
+		}
 	}
 }
 EXPORT_SYMBOL(dst_release);
@@ -186,8 +191,10 @@ void dst_release_immediate(struct dst_en
 		if (WARN_ONCE(newrefcnt < 0, "dst_release_immediate underflow"))
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
-		if (!newrefcnt)
+		if (!newrefcnt){
+			dst_count_dec(dst);
 			dst_destroy(dst);
+		}
 	}
 }
 EXPORT_SYMBOL(dst_release_immediate);


