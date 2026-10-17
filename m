Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6FD3ADBA4;
	Sat, 17 Oct 2026 16:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256108; cv=none; b=uzY+BMC6LJmZdjtUgvsbHM/vKbLTgV/Yve8CviWzcoW97lGY/jpQ8cVLU+Mb7jwOrYSXSNZymDdeVMea0Aya8jRh2VHBYEAwBxntxERg/W3NxrhGh08PlEvXNYvTSk3qlRm61jwCnlVRv4Yy832JsADICBOoJz2qy12f+jB6kfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256108; c=relaxed/simple;
	bh=7ShkoV2e7aXhxF25hPOUos8o8SSOflyW0ho8gxbciGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHR6hCddt2p5fcAi285087CLw6YPaD0xgsIFhs9xcmKxeN9qqk3751gmG47UcOVoo6PcVVhfgC86BvhWa2jeQcBapN/SzPmhS+kE+xRvMxbXIyc1udB4SKOg1AGDVKm4IkBhWm+Ick6fQvuTc9Q9co77PFyG6VRyW7GTfF+PD3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11vOExmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11vOExmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE431F000C4;
	Sat, 17 Oct 2026 16:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256106;
	bh=mMFd5kaEGNw8c0BUUjY/eMp/PbIOdMZ7JnZQdZiKjyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11vOExmnR3K0iGV1icwLEEfG96nKkBml6982TRJsPTsTGelVTdu2P3XV3tS0sGaAn
	 QtUhqw1y7z+aKi1gimazEk8QhVvd68AD5wFbkwGAAgK10HuDBF4qDd6OIhVOuTVS09
	 dXdk6UkhQWHNJBcbzTYuflPH8OKL3YkJUqMl3S10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0128/1674] net/sched: act_ct: fix helper UAF due to extensions realloc
Date: Sat, 17 Oct 2026 17:40:00 +0200
Message-ID: <20261017160434.448072509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit dad19b59da050cb60d3f7023dac2a042a84bf0bd ]

While calling the helpers, a raw pointer to the extensions area is
wired into expectations list:

  -> nf_ct_helper()
   -> helper->help()
    -> nf_ct_expect_related_report()
     -> nf_ct_expect_insert()
      -> hlist_add_head_rcu(&exp->lnode, &master_help->expectations)

In case the connection is not confirmed yet, more extensions can be
added afterwards with *_ext_add() calls reallocating the extension
space and leaving the now invalid pointer in the expectations list
that is later accessed while removing the expectation.

Make sure that helpers are called at the end after all the other
extensions are already added.

Note that the helper rejection now leaves the mark and labels set,
but that's not different from how the NAT was handled before or how
the mark and the labels were handled on confirmation failure.  And
there are no atomicity guarantees provided by the API anyway.

Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
Cc: stable@vger.kernel.org
Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260921145655.3167436-7-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Preserved the existing add_helper condition that upstream had removed. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 096adcf2209a7..55e5c24cb4835 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1083,18 +1083,24 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		}
 	}
 
-	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
-		if (nf_ct_helper(skb, ct, ctinfo, family) != NF_ACCEPT)
-			goto drop;
-	}
-
 	if (commit) {
 		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
 		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
 
 		if (!nf_ct_is_confirmed(ct))
 			nf_conn_act_ct_ext_add(skb, ct, ctinfo);
+	}
 
+	/* Run helpers for the connection if nf_conntrack_in() was executed
+	 * or if we're about to commit.  This has to be done after all the
+	 * extensions are already added.
+	 */
+	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
+		if (nf_ct_helper(skb, ct, ctinfo, family) != NF_ACCEPT)
+			goto drop;
+	}
+
+	if (commit) {
 		/* This will take care of sending queued events
 		 * even if the connection is already confirmed.
 		 */
-- 
2.53.0



