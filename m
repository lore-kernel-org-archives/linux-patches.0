Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9622C3770;
	Tue,  6 Jan 2026 17:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720744; cv=none; b=Ixo2eBYzwOBbf6O00n0J4+UoQ6sDn57QPt1z4fRc1O6wZaPeTS+aa/wcjJl7/BKrvolV0gDX5+nXz8R+FmDEpblGN3JXrfKkQMVxbz12MOzIGWTynyDPwlI+iyKKzNGRUqpoBIUxROIibXVU+nCm6HGzVUNGLoLxtQxheVKm3ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720744; c=relaxed/simple;
	bh=C1ePl8ydEQqWgoRvTjenL2Wb58ob1Yyq/e1yTFOzBpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LP+9HFln6NQ1bcv1FzvwC/tzM8NoRtD256f7E4zes8Au2QCFwnOdwkzXPs27glYsnDaP1eMy+PNooYLq86ftouEzYzs0toHT3IsQzKQ6J82T+nTV97WCx6/LkQxiVvfgEgJN6gx/KAzy5L48BxbJLOTSIxdIPE5m/IjTMmTwxSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfY/f+Hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfY/f+Hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195D5C116C6;
	Tue,  6 Jan 2026 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720743;
	bh=C1ePl8ydEQqWgoRvTjenL2Wb58ob1Yyq/e1yTFOzBpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfY/f+HkO6HuvoNmiUoR6HdDPGP6aVMwTZ2RDCBJoJMWunuqXYOquywXJLgGV1DSx
	 ZxnvRZmPGn3STeOlKkoUXbR7Z2ICMILL3lC2sv/ccI1hOtDe27mCE6IOSfjJztT5fG
	 GomBLBvldbXIbHjxivcbGyq8x1FQVUmjUJ+HaC+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9b35e9bc0951140d13e6@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/567] ipv6: fix a BUG in rt6_get_pcpu_route() under PREEMPT_RT
Date: Tue,  6 Jan 2026 18:01:51 +0100
Message-ID: <20260106170503.505024650@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 1adaea51c61b52e24e7ab38f7d3eba023b2d050d ]

On PREEMPT_RT kernels, after rt6_get_pcpu_route() returns NULL, the
current task can be preempted. Another task running on the same CPU
may then execute rt6_make_pcpu_route() and successfully install a
pcpu_rt entry. When the first task resumes execution, its cmpxchg()
in rt6_make_pcpu_route() will fail because rt6i_pcpu is no longer
NULL, triggering the BUG_ON(prev). It's easy to reproduce it by adding
mdelay() after rt6_get_pcpu_route().

Using preempt_disable/enable is not appropriate here because
ip6_rt_pcpu_alloc() may sleep.

Fix this by handling the cmpxchg() failure gracefully on PREEMPT_RT:
free our allocation and return the existing pcpu_rt installed by
another task. The BUG_ON is replaced by WARN_ON_ONCE for non-PREEMPT_RT
kernels where such races should not occur.

Link: https://syzkaller.appspot.com/bug?extid=9b35e9bc0951140d13e6
Fixes: d2d6422f8bd1 ("x86: Allow to enable PREEMPT_RT.")
Reported-by: syzbot+9b35e9bc0951140d13e6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6918cd88.050a0220.1c914e.0045.GAE@google.com/T/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20251223051413.124687-1-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 22866444efc0..276fa74af206 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1470,7 +1470,18 @@ static struct rt6_info *rt6_make_pcpu_route(struct net *net,
 
 	p = this_cpu_ptr(res->nh->rt6i_pcpu);
 	prev = cmpxchg(p, NULL, pcpu_rt);
-	BUG_ON(prev);
+	if (unlikely(prev)) {
+		/*
+		 * Another task on this CPU already installed a pcpu_rt.
+		 * This can happen on PREEMPT_RT where preemption is possible.
+		 * Free our allocation and return the existing one.
+		 */
+		WARN_ON_ONCE(!IS_ENABLED(CONFIG_PREEMPT_RT));
+
+		dst_dev_put(&pcpu_rt->dst);
+		dst_release(&pcpu_rt->dst);
+		return prev;
+	}
 
 	if (res->f6i->fib6_destroying) {
 		struct fib6_info *from;
-- 
2.51.0



