Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3CE336888;
	Tue, 21 Jul 2026 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654988; cv=none; b=dsG2BrsNXIaZ8dNitTjE5DzVmA+kwY/MFRRSvIsrQFl+VPR6ii2hMVGRAbjFACvGhBeWBuqtH39wVEE4SSV1ugwjKagW76t89FKIqzY55FgHyT3ZtekunAR626JfNJNzMh6bPnzA/JksizEPHxDfVFXrMWwhtBtl6ySdzAFsm5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654988; c=relaxed/simple;
	bh=gg3e/WoU0SN1zBIsI2Q1xTWKTeL5fq0MD0Uj5OuesLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBDjfMgd4c6v7c6xvUlXla2vrVmOElLmAnqjqMT5MXXmXnrU4A5Mvfl0spXbmo+v8JXv6lkdV1mhPWeyQ+FGOX2957y9ADUfMqdG1Ck9ync/GAypB9y2EqhNFrwA6qEm6AJCzID1NaJBxURzNCyNp+EHTXDQtC54/bGUntV34oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3HWnVWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3HWnVWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A23A1F000E9;
	Tue, 21 Jul 2026 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654986;
	bh=ZtKjM/xKxb5BUyMpS0MIjU8tHurzKHiT1FyB5Z9T9/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3HWnVWNsebi+MgiNYvxEWFYdlPnc6MxUSfhr5ndodmId8CmMlyOFz9bt9jhDoH5E
	 5zb2+H7vJzsiGAPJjU8AeehP3aI+EPCONqED1q4A70DSiM6YkePXyN4fgR++BoxZOq
	 4JIVsA77mgYlmvVTBfQ/o1hxo5CvIf5KNw/nbhtA=
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
Subject: [PATCH 7.1 1913/2077] net/sched: act_ct: preserve tc_skb_cb across defragmentation
Date: Tue, 21 Jul 2026 17:26:26 +0200
Message-ID: <20260721152637.838141845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -844,11 +844,11 @@ static int tcf_ct_handle_fragments(struc
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
@@ -862,12 +862,13 @@ static int tcf_ct_handle_fragments(struc
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


