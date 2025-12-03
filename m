Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86CA2FD1C5;
	Wed,  3 Dec 2025 16:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779798; cv=none; b=txz/FGd6B2rQnR8b3zi6x+sefzQ7VNpeiHQRt0aavIMUtRmSXgI6qaWnAC/+rHx8DVvkBgaZSsmVy7r2vPhcE3Vv8dLiHWNA3S3aPM1bN9yYSg4t003gkuOuYkSSDJ7kdAkWYRMg56jWZjZ8r+jiaQ5ChxRHrj7s9cE4Csd5j5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779798; c=relaxed/simple;
	bh=4MLeSIG2iWejoMI+Lt+1ix5xqm5PLy+qhs7qn5johbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CX1Pu+OMOz1uihsWxIEfN7+iGb4880U23d72DpYebd/Bt5FSrjvvpqMKSxT/we6JPuw/IuUNxvBUVAEUCtl0w95NcU4HkNqxhYYo14ld+gkzUpI+CpZHuknxDIYxO1+CyVui4okJTBpGM1D70UnIQZ4Lec8d+1G8cV3bOkKyGhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POS4d9Re; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POS4d9Re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507AAC4CEF5;
	Wed,  3 Dec 2025 16:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779798;
	bh=4MLeSIG2iWejoMI+Lt+1ix5xqm5PLy+qhs7qn5johbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POS4d9ReOPWuKV+K4ouUlkA5NbndL9/1XHRiv5XwMOLoy+mfzjWIJWBO3l3ssts8U
	 D/b+m2iFajGWEACT3rDNGoS5Z5n8K9EzG2WZrJJwzdcltMTOWTkkU8oXSoz9MYjXOH
	 h/SVtMREsCjwoez/7TI1OtKAiwHj3p629LmKpI00=
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
Subject: [PATCH 6.1 365/568] net: sched: act_ife: initialize struct tc_ife to fix KMSAN kernel-infoleak
Date: Wed,  3 Dec 2025 16:26:07 +0100
Message-ID: <20251203152454.068556147@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 41d63b33461dc..a4505b926a1e4 100644
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



