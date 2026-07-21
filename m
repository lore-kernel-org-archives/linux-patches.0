Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61976402B8F;
	Tue, 21 Jul 2026 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659124; cv=none; b=QcO7DSGRyU3kkp0PGglB8sQ0RguOtup/9CyYl1zLNmtfOW6ZADMCQPsLZIaccGJ2BnwWjLO2tU55x9dLFRMU+GgvhKxH5igTzHWA9rsP7Q6wtzyfDam1DQZI+5h9wA2Ct1/SHJUr6iVJgvAFriZQinAQU+CqrF/2w9N8kdfPxYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659124; c=relaxed/simple;
	bh=5KhSdOt9yKESFW9fqHKZ+U809/QghBpXPLSnz8+SWgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVGy97KAO8F4Lp/+NwHQPvH4pW/eI9NlbBV6NkRK7yy3K2G7bH9KP2UqwXBNotwA0d2mbeAAN3kC9rQj9+ORYz+WZ2M7ViG0pH5Uua9TeZERYzk2zlO/gAXDv/7sfk6lbXJOmxLa6vSjhIdyO2W5jCtZLin3/fuxr6E/Ld4hLc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjHhqlaT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjHhqlaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957F01F000E9;
	Tue, 21 Jul 2026 18:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659123;
	bh=kQ+fb2B0XgB2uH1ImDQoVfv/3xnStlipvZbvgMdbUGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjHhqlaT0jzdkIoAdXz30hSyMStqrB7Z4FXI0FtjzUlhFydpdSrNY+Yuz0S/kbip+
	 Lj+6raZHdIMXvDR4yhPve0Y4SNkysyz5oWjF8+YTF+8qjmIT/xLDJ/o9gqGPblBVVV
	 CBibCXU9v0PWrqinOwsiZS+JEgsPtcL4YHLJKGUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1403/1611] net/sched: act_ct: preserve tc_skb_cb across defragmentation
Date: Tue, 21 Jul 2026 17:25:19 +0200
Message-ID: <20260721152547.000761262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Zihan Xi <xizh2024@lzu.edu.cn>

commit 9092e15defbe6c7bc241c306093ca9d358a578e7 upstream.

tcf_ct_handle_fragments() calls nf_ct_handle_fragments() without saving
and restoring skb->cb. The defrag helper clears IPCB/IP6CB, which aliases
the tc_skb_cb/qdisc_skb_cb control buffer. Fragmented traffic through
act_ct therefore loses qdisc metadata such as pkt_segs and can trigger
WARN_ON_ONCE() in qdisc_pkt_segs() when panic_on_warn is enabled.

Save and restore the full tc_skb_cb around nf_ct_handle_fragments(),
matching the pattern used by ovs_ct_handle_fragments().

Fixes: ec624fe740b4 ("net/sched: Extend qdisc control block with tc control block")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/510c51217fd7aaf29c6dc298bab8d643fe229b1c.1781358692.git.xizh2024@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -842,11 +842,11 @@ static int tcf_ct_handle_fragments(struc
 				   u8 family, u16 zone, bool *defrag)
 {
 	enum ip_conntrack_info ctinfo;
+	struct tc_skb_cb cb;
 	struct nf_conn *ct;
 	int err = 0;
 	bool frag;
 	u8 proto;
-	u16 mru;
 
 	/* Previously seen (loopback)? Ignore. */
 	ct = nf_ct_get(skb, &ctinfo);
@@ -860,12 +860,13 @@ static int tcf_ct_handle_fragments(struc
 	if (err || !frag)
 		return err;
 
-	err = nf_ct_handle_fragments(net, skb, zone, family, &proto, &mru);
+	cb = *tc_skb_cb(skb);
+	err = nf_ct_handle_fragments(net, skb, zone, family, &proto, &cb.mru);
 	if (err)
 		return err;
 
 	*defrag = true;
-	tc_skb_cb(skb)->mru = mru;
+	*tc_skb_cb(skb) = cb;
 
 	return 0;
 }


