Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BAA434E5D;
	Tue, 21 Jul 2026 20:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664038; cv=none; b=MktfOvPhUZdKHKEZWW/KhA1SywzA4XcC80AW+oDqQZz/QC44cLsJj9tLwxNKY4vETySRZPi5K8CFZVnluB2fymqj5GBXO5G+UTE2HEAw4bkebJ/kvckVKy3lRmeMAuH9zY4KmFqWtmp9exvLLkHx6zfFDSTpwcS5ViuhaNLanOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664038; c=relaxed/simple;
	bh=B23UITkSMUGZUhY8FLmabrLodmIV40A3b3Eff02yg4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8SZj5Q0PqRThGnoGDjgKSYViDeZencGw3up+yVl3zU/Ei/zG3oG62F+m+1JwO0D8ZobaP4aWEKPiWSz0qIaeoFBa+jx5LIpjmH0pLyN4CLNYmO3jlCJogji+l8OzOUJ97EsYvxDxVM6OxuiFIqdOqctlAEA/409PEmWssSDzEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBNw2Pcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBNw2Pcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329D01F000E9;
	Tue, 21 Jul 2026 20:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664037;
	bh=a05XnPOcuKt0lxCMvkwTVJXA3cqCGJ+68Bnoe+FDBmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBNw2PcwIG9zoVt76r9Vyzk4NAWzd/kMoZ2XSAZ/j2VX4iAn+3IEqWQ3sMZu7Yalm
	 o9kjE+NDzxTUJN+kGJIB+Yp3nXPaizjWVo7MpFgI1AxyS6YXJNoPwCw82bsH9Jn3y7
	 vvVIuqURiXm+JKjqrfY0mlgBBZcljhXNOr1YH2vc=
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
Subject: [PATCH 6.12 1048/1276] net/sched: act_ct: preserve tc_skb_cb across defragmentation
Date: Tue, 21 Jul 2026 17:24:51 +0200
Message-ID: <20260721152509.440712577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


