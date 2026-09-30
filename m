Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DC43BE642;
	Wed, 30 Sep 2026 18:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792980; cv=none; b=UTQwJaapz7yfLBfd1mQ3RM00E0AVvf0j2dft9L0WAwz5F+Up7Mut4dfxikfX9vg0TNwhip50UVJha5zhU8lgg1vX+F5M1oRdm9QIqrBGhSFgz2GEH0hvMorg5Gf8EZcUCRYIGR/e/ujROzLVDHdLEej6jnWz8i9AiHikh6jtpMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792980; c=relaxed/simple;
	bh=2aBYUbQtU17sD2RRckrxSlPaCMCvvNotIQhkPws9u90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jmp8XWsWRmzIicP0blsbVI+QfSffpSQ3m1A/gEWUXyXWMtHa8SbfnLNXHbhRV/LfHOAMmYX6oBbmpr24xW3fWfmCpLP9Pox0vycBtDnAfB4m17lxuXsiELN+Jd62xFXCnwYNoRL3eRLUJrRzFIw6DzOKIXgGraPbMmvjYRPdl+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAh7GKHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAh7GKHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8741F000FF;
	Wed, 30 Sep 2026 18:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792979;
	bh=t1lh0Ebrpw7FPvmEsV7TYoCwrh5PQRAYHgBZg9xhjNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAh7GKHCdgd1LvIViHboDIJoZYZN39YU7/o89cZ69syVOLcehNVbxHtMDW6PwU9kv
	 7mZyq1jVy0Ei6fwnnExcplxVVEPTTLUaaGd/Yc0yoWgBXNyh4VH05CIHwr9DIN5BSH
	 Mupu+RS8kQfqqG1j+b2QVqsIMBbgXlaTNjGoSnMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6cc37aba98dac721c415@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/395] net/sched: act_ct: dont WARN on benign flow_offload_alloc() failure
Date: Wed, 30 Sep 2026 17:25:38 +0200
Message-ID: <20260930152342.287517583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 47abe7a5c4eb53269aca3506446f851572a059a3 ]

flow_offload_alloc() returns NULL when the conntrack entry is dying
(e.g. raced with a conntrack flush) or when the GFP_ATOMIC allocation
fails; both are expected under load and neither is a kernel bug. This
path runs from softirq on every committed packet, so with
panic_on_warn=1 an unprivileged user can panic the box just by racing
a conntrack flush against a `tc ... action ct commit` classifier.

Reproduced with a custom repro under QEMU: a small, fixed set of UDP
flows through `tc filter ... action ct commit` on lo, raced against
threads flooding bare ctnetlink CT_DELETE (flush) requests. Hits
WARNING: net/sched/act_ct.c:437 (tcf_ct_flow_table_add(), inlined
into tcf_ct_act() in this build) within ~15s on the unpatched kernel;
same setup is clean on the patched kernel. The fix itself is
behavior-preserving: both branches already did `goto err_alloc`
before and after, only the WARN is removed.

Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
Reported-by: syzbot+6cc37aba98dac721c415@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6cc37aba98dac721c415
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260915150816.36487-1-ngocthang2710.1999@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index cbac27ba76afc..14d16956451dc 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -430,11 +430,10 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
 		return;
 
+	/* NULL if ct is dying (raced flush) or the atomic alloc failed. */
 	entry = flow_offload_alloc(ct);
-	if (!entry) {
-		WARN_ON_ONCE(1);
+	if (!entry)
 		goto err_alloc;
-	}
 
 	if (tcp) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-- 
2.53.0



