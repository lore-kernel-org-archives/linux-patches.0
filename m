Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090723264D7;
	Mon, 13 Apr 2026 16:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099538; cv=none; b=BykYIi56yeVZDwkD0pNL6a1TYjHZpu0YCPm089HGp6SPi3/S0qA9M57ycDQBb48sJTy/ddEG1kRjofj5e4KRtwK50HETNWV4UdsTJjIX3CpJZe994K5Fqzhjx3hycpB6bKktJCol7PR2w0on0oLHkZXYrNXT1hCGTda7SgCqj/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099538; c=relaxed/simple;
	bh=Zge050bSmU4geplVTuBwvmTYtjcGGZHTiKD9MiMdUGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRWRq7JMhZSUrjZO0VHX13k/9Q/2MBrCbbn/u+8WCBGyDB9Jr9fRaRfwMGBksW+CQAzbReUop/hACkjlyrHEUbRH/MOy+qNlNYSplYZiI4HiEo/v6SD/ADv3utkouvk0rgTl6OqitQkmYZfVqbwQZiwAnaoZTFBbAku04gAXN6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/sXQOy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/sXQOy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D82BC2BCAF;
	Mon, 13 Apr 2026 16:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099537;
	bh=Zge050bSmU4geplVTuBwvmTYtjcGGZHTiKD9MiMdUGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/sXQOy0B2CcA5NKF/CfoJjCx5rs7VQm2jf6XAyCIpl7qEnG54xtJ5xN5oF27hj6H
	 2/h/AaU1LWgrRFXzFaUOYQdK+96NS3bFT5NHWwoKU8vHr6/y6EVwJMDzfeUADXrIJt
	 YrVTzeHrRjgHpfBQJfdbRAqTcXGvHWKh1G+PchEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/491] net/sched: cls_fw: fix NULL pointer dereference on shared blocks
Date: Mon, 13 Apr 2026 17:59:56 +0200
Message-ID: <20260413155832.180799668@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit faeea8bbf6e958bf3c00cb08263109661975987c ]

The old-method path in fw_classify() calls tcf_block_q() and
dereferences q->handle.  Shared blocks leave block->q NULL, causing a
NULL deref when an empty cls_fw filter is attached to a shared block
and a packet with a nonzero major skb mark is classified.

Reject the configuration in fw_change() when the old method (no
TCA_OPTIONS) is used on a shared block, since fw_classify()'s
old-method path needs block->q which is NULL for shared blocks.

The fixed null-ptr-deref calling stack:
 KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
 RIP: 0010:fw_classify (net/sched/cls_fw.c:81)
 Call Trace:
  tcf_classify (./include/net/tc_wrapper.h:197 net/sched/cls_api.c:1764 net/sched/cls_api.c:1860)
  tc_run (net/core/dev.c:4401)
  __dev_queue_xmit (net/core/dev.c:4535 net/core/dev.c:4790)

Fixes: 1abf272022cf ("net: sched: tcindex, fw, flow: use tcf_block_q helper to get struct Qdisc")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260331050217.504278-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_fw.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index 08c41f1976c47..23cf4f7111174 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -246,8 +246,18 @@ static int fw_change(struct net *net, struct sk_buff *in_skb,
 	struct nlattr *tb[TCA_FW_MAX + 1];
 	int err;
 
-	if (!opt)
-		return handle ? -EINVAL : 0; /* Succeed if it is old method. */
+	if (!opt) {
+		if (handle)
+			return -EINVAL;
+
+		if (tcf_block_shared(tp->chain->block)) {
+			NL_SET_ERR_MSG(extack,
+				       "Must specify mark when attaching fw filter to block");
+			return -EINVAL;
+		}
+
+		return 0; /* Succeed if it is old method. */
+	}
 
 	err = nla_parse_nested_deprecated(tb, TCA_FW_MAX, opt, fw_policy,
 					  NULL);
-- 
2.53.0



