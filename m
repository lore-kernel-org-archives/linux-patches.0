Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0C42BEFFF;
	Wed,  8 Apr 2026 18:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673810; cv=none; b=Q8YwVmcLrD79/DVyiLRuVl4Npf9iqQoFgUERT24u0C38Tomzxi6Y8Zr2+BKb5khpUs6Qm2ySizkn7Dh70ClNr+DCKt7qKIYOC04/W8qwpUv1M7KIOAsU4KQHE4FaLcoinim9Jyzq0UKv2JPjgshu/wYVZhkvEz4m3MDY/mLdcpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673810; c=relaxed/simple;
	bh=6OqJVgA0yG/T+CLHN81Uq+bGzQbYI1p9c/Ha5ShHPeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URWkS/Saq582Gr64lBhX7V7VT9cYkq6nZvOCrMGYwxI8SaCCR7daKRL0mEB+MTWBcH7dEJY0/QFtv/cFII1LTP0+yb9NqMdExZWE3BX5gz7FX6ARXTECfVHV7EMp3WH5sY2w+edTxKgvZIgFHo/7c7HXaO3qwYZI3px10mD8R3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qkss6/wm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qkss6/wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050DDC4AF09;
	Wed,  8 Apr 2026 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673810;
	bh=6OqJVgA0yG/T+CLHN81Uq+bGzQbYI1p9c/Ha5ShHPeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qkss6/wmXU/zwEDsEWRZgo/aivSQFJWk1hhtVocncOKa4LxgXoAKkyykm3zHO34mM
	 8TBz4PPXOo5sitE3AoMru/N27t27fHNnj3I+ff8+RzwN40SS4c9F+nA15pT2vJ4VlI
	 pspUlkumW9CtGeK+VDsMj+S3gg5QovbCEbg5nCEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/242] net/sched: cls_flow: fix NULL pointer dereference on shared blocks
Date: Wed,  8 Apr 2026 20:02:18 +0200
Message-ID: <20260408175930.752935789@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 1a280dd4bd1d616a01d6ffe0de284c907b555504 ]

flow_change() calls tcf_block_q() and dereferences q->handle to derive
a default baseclass.  Shared blocks leave block->q NULL, causing a NULL
deref when a flow filter without a fully qualified baseclass is created
on a shared block.

Check tcf_block_shared() before accessing block->q and return -EINVAL
for shared blocks.  This avoids the null-deref shown below:

=======================================================================
KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
RIP: 0010:flow_change (net/sched/cls_flow.c:508)
Call Trace:
 tc_new_tfilter (net/sched/cls_api.c:2432)
 rtnetlink_rcv_msg (net/core/rtnetlink.c:6980)
 [...]
=======================================================================

Fixes: 1abf272022cf ("net: sched: tcindex, fw, flow: use tcf_block_q helper to get struct Qdisc")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260331050217.504278-2-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flow.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 5c2580a07530e..7eeead60ec23b 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -503,8 +503,16 @@ static int flow_change(struct net *net, struct sk_buff *in_skb,
 		}
 
 		if (TC_H_MAJ(baseclass) == 0) {
-			struct Qdisc *q = tcf_block_q(tp->chain->block);
+			struct tcf_block *block = tp->chain->block;
+			struct Qdisc *q;
 
+			if (tcf_block_shared(block)) {
+				NL_SET_ERR_MSG(extack,
+					       "Must specify baseclass when attaching flow filter to block");
+				goto err2;
+			}
+
+			q = tcf_block_q(block);
 			baseclass = TC_H_MAKE(q->handle, baseclass);
 		}
 		if (TC_H_MIN(baseclass) == 0)
-- 
2.53.0



