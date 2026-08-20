Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A180E483BD1;
	Thu, 20 Aug 2026 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248327; cv=none; b=RJTXQcvQtM3ilHmoP5cd0viTkSUfM1MrIE5Z/OcZICdI2K5d+8Hx6T5qGeInkiMxYrI3SxacONwK/s9TRGkA3yHAQf+A2Zq8289MQ3Mg69E/iQuVWHKM5hKnPBZDTE6U1bDJXzJBJW72+gALa0EyrjNCc7Tt8yi2D8lyEEEsiY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248327; c=relaxed/simple;
	bh=LOGaziGaPdqQ3Awq5BEDRrE4fN26DJov839ZKTV/vhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCFWDyh011Y+mKLimQXLTxbPGCbIvent9vbMjSNfe54qVM8V9/PLXL6NYEx2Mv8ioLSZHjQBraUQjr3ucfYtpzp1Jo/6wiO2+NjV5O5F7sLqqmTGUnwOee3Al7SX0nkkysmabmCWOR7FCBY0Z9pqdJfJQbbKWVJH+IQna8DrzEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHtoCd1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHtoCd1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AF11F000E9;
	Thu, 20 Aug 2026 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248326;
	bh=lirIOCMEFRJjnAclANXpsNJrvNZDH7vkOjNLoDso6CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHtoCd1cpq2uoCdCtCkWaddiKlGFDFDJO1XJGxYcM+dPvhJM3dlS5mJVNQ6LDXzMk
	 iMYWZddXnD8XyINAzwPTLGAU4cbt3SKsjEVQHJchmY781kl8eKQaXP7fPmqedzNh4K
	 v/q/ai+pOM+vbkqQJUdjX1pmkFFjtS1//XVsp/qA=
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
Subject: [PATCH 6.1 150/303] net/sched: act_ct: preserve tc_skb_cb across defragmentation
Date: Thu, 20 Aug 2026 16:54:46 +0200
Message-ID: <20260820145257.795250424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -858,10 +858,10 @@ static int tcf_ct_handle_fragments(struc
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
@@ -875,7 +875,7 @@ static int tcf_ct_handle_fragments(struc
 	if (err || !frag)
 		return err;
 
-	mru = tc_skb_cb(skb)->mru;
+	cb = *tc_skb_cb(skb);
 
 	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
@@ -889,7 +889,7 @@ static int tcf_ct_handle_fragments(struc
 
 		if (!err) {
 			*defrag = true;
-			mru = IPCB(skb)->frag_max_size;
+			cb.mru = IPCB(skb)->frag_max_size;
 		}
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
@@ -902,7 +902,7 @@ static int tcf_ct_handle_fragments(struc
 
 		if (!err) {
 			*defrag = true;
-			mru = IP6CB(skb)->frag_max_size;
+			cb.mru = IP6CB(skb)->frag_max_size;
 		}
 #else
 		err = -EOPNOTSUPP;
@@ -911,7 +911,7 @@ static int tcf_ct_handle_fragments(struc
 	}
 
 	if (err != -EINPROGRESS)
-		tc_skb_cb(skb)->mru = mru;
+		*tc_skb_cb(skb) = cb;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;


