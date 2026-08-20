Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54178272E53;
	Thu, 20 Aug 2026 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243594; cv=none; b=Zgj3cs8ohu88l7MCnsLyU8zQXEhYhdVrNfHTl45Om/idFouyvvZQZwRLyJauvhDLV+lN/t3BA19epxw5ccr6csz+ZPv+cD/a+a2ONtSeJqyRBwbNv8br6EX6njDlkeCLKKDhRRqMZ83xXwFiY6q7WqUfFy5ZlAUtyYGvWAPpu38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243594; c=relaxed/simple;
	bh=F8jOeEesjFP1n4QMVYDErr59pxsLbXN+I0H07B4tkzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeB1LvOcFRPrK7/NUwEhFOHIPARtJrXmRSCDGkFtGaGYiTVgEnNN3Ic9dV1rzj/Q2j0HvkvvVA67/lXMqUkYsFp/ql5wKbMp8he2djya7ZR84qd9c4L7MmGchTmnfly3U0ZPMNby6mozQ6NqlscGbcaOxYzZsNpRqbHO8qs/EZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LY3GoZxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LY3GoZxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E811F000E9;
	Thu, 20 Aug 2026 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243593;
	bh=Kuu8nS+PDUaOX8E/LXoa6WRviJjC27b+J4LmzeLfe2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LY3GoZxlzFF0+ib/tCg5/QrHJLz8DTlimQyBE1V84FHDxDOgFzvjFWRc7u4VQ8gvx
	 XwcFr2ilAWAO4c/nbR3Bcm3bCfR6WKoyJDN2kTIsfAbdDlTWGmrI9n7LMA0btvX25n
	 DGPPCGyk0Hebd7Bb6UWFrulA/EC7zuh8diK9kSC8=
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
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/272] net/sched: act_ct: preserve tc_skb_cb across defragmentation
Date: Thu, 20 Aug 2026 16:55:31 +0200
Message-ID: <20260820145235.718716139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

[ Upstream commit 9092e15defbe6c7bc241c306093ca9d358a578e7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -700,10 +700,10 @@ static int tcf_ct_handle_fragments(struc
 				   u8 family, u16 zone, bool *defrag)
 {
 	enum ip_conntrack_info ctinfo;
+	struct tc_skb_cb cb;
 	struct nf_conn *ct;
 	int err = 0;
 	bool frag;
-	u16 mru;
 
 	/* Previously seen (loopback)? Ignore. */
 	ct = nf_ct_get(skb, &ctinfo);
@@ -717,7 +717,7 @@ static int tcf_ct_handle_fragments(struc
 	if (err || !frag)
 		return err;
 
-	mru = tc_skb_cb(skb)->mru;
+	cb = *tc_skb_cb(skb);
 
 	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
@@ -731,7 +731,7 @@ static int tcf_ct_handle_fragments(struc
 
 		if (!err) {
 			*defrag = true;
-			mru = IPCB(skb)->frag_max_size;
+			cb.mru = IPCB(skb)->frag_max_size;
 		}
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
@@ -744,7 +744,7 @@ static int tcf_ct_handle_fragments(struc
 
 		if (!err) {
 			*defrag = true;
-			mru = IP6CB(skb)->frag_max_size;
+			cb.mru = IP6CB(skb)->frag_max_size;
 		}
 #else
 		err = -EOPNOTSUPP;
@@ -753,7 +753,7 @@ static int tcf_ct_handle_fragments(struc
 	}
 
 	if (err != -EINPROGRESS)
-		tc_skb_cb(skb)->mru = mru;
+		*tc_skb_cb(skb) = cb;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;


