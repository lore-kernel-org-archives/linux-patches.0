Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F43DDAB;
	Wed,  3 Dec 2025 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776457; cv=none; b=J4KU/X+1BaRNsD+dOpXf4vLxicoLievgMobW6jxSpyafGVZ2044cjEdhALYIyawmwGb46csTx2Bqr4v1MD6wvueo66WFUePKTGR3RxGL/pdCI0EPS/SXLKE35kDnYBRm3nb2l5PHdM8APV4c8HQWwj2YvSpvysrkfVk/jw+knOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776457; c=relaxed/simple;
	bh=rmm+wyVyxDIS3bhx/s3jGsd3db0LfiLR0zphv+wZGBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gR6NaD8ZwYubsE/4C3ymuIHRU0A0NSYnedNq75deJJG6MtvUgKbBGDS5Nu5e2GXmjSxYoRq56paww3mYSsoX1h0+K45Zzx4eTzX3tymK3tfjpPSVh5c606wQ308qD3rjqZUgX/kLD7mymUeEAVsG7r2vFuy/OqBkYDwsFsDGU38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6ZhPK0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6ZhPK0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9837EC4CEF5;
	Wed,  3 Dec 2025 15:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776457;
	bh=rmm+wyVyxDIS3bhx/s3jGsd3db0LfiLR0zphv+wZGBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6ZhPK0MDtwjfZzKmYzPVLMTHL8liIbFZpwQSrCSfWis92F+jTgc2yKH1IGbVAP5o
	 T8z72/7T/o3iPcdJ+yTcdxp5nwgY5f/tsFK/ztirILWGW1U8mH10V/4r30reHybAMU
	 p3p+q2///RQVn5ohmc+cxFoWt/PBvkh8N36i9dD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c85cae3350b7d486aee@syzkaller.appspotmail.com,
	Ranganath V N <vnranganath.20@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/300] net: sched: act_ife: initialize struct tc_ife to fix KMSAN kernel-infoleak
Date: Wed,  3 Dec 2025 16:26:32 +0100
Message-ID: <20251203152407.592079128@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranganath V N <vnranganath.20@gmail.com>

[ Upstream commit ce50039be49eea9b4cd8873ca6eccded1b4a130a ]

Fix a KMSAN kernel-infoleak detected  by the syzbot .

[net?] KMSAN: kernel-infoleak in __skb_datagram_iter

In tcf_ife_dump(), the variable 'opt' was partially initialized using a
designatied initializer. While the padding bytes are reamined
uninitialized. nla_put() copies the entire structure into a
netlink message, these uninitialized bytes leaked to userspace.

Initialize the structure with memset before assigning its fields
to ensure all members and padding are cleared prior to beign copied.

This change silences the KMSAN report and prevents potential information
leaks from the kernel memory.

This fix has been tested and validated by syzbot. This patch closes the
bug reported at the following syzkaller link and ensures no infoleak.

Reported-by: syzbot+0c85cae3350b7d486aee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c85cae3350b7d486aee
Tested-by: syzbot+0c85cae3350b7d486aee@syzkaller.appspotmail.com
Fixes: ef6980b6becb ("introduce IFE action")
Signed-off-by: Ranganath V N <vnranganath.20@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251109091336.9277-3-vnranganath.20@gmail.com
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ife.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 99548b2a1bc83..892d4824d81d5 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -643,13 +643,15 @@ static int tcf_ife_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_ife_info *ife = to_ife(a);
 	struct tcf_ife_params *p;
-	struct tc_ife opt = {
-		.index = ife->tcf_index,
-		.refcnt = refcount_read(&ife->tcf_refcnt) - ref,
-		.bindcnt = atomic_read(&ife->tcf_bindcnt) - bind,
-	};
+	struct tc_ife opt;
 	struct tcf_t t;
 
+	memset(&opt, 0, sizeof(opt));
+
+	opt.index = ife->tcf_index,
+	opt.refcnt = refcount_read(&ife->tcf_refcnt) - ref,
+	opt.bindcnt = atomic_read(&ife->tcf_bindcnt) - bind,
+
 	spin_lock_bh(&ife->tcf_lock);
 	opt.action = ife->tcf_action;
 	p = rcu_dereference_protected(ife->params,
-- 
2.51.0



