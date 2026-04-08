Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF473D7D9D;
	Wed,  8 Apr 2026 18:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672579; cv=none; b=UvcGCQqglSccOxzpd906ekUzLwldrTirxkRvld7px0CcYl1IagUiyh3O0nO/A9Utt4UbrP6X4CpndXCSi8nszx294kT5ECnmf2mRciJTyeJeDV3ZJtgnN3lAfhTjzGsN/lRtMkUt0O5N96ZGORIUTlI/WJXeKLCwbBP/RXaMcCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672579; c=relaxed/simple;
	bh=Dfm5Ks+oGD6MWEB32K+suVtGYXjX557GZSFbDXfF2Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJbIiGIqCGcfNdv6VZjdjNaqHeGpvBAZf2czcCAwT5cWRw/nz/ZcbIrFSuLcjfnEfZFdVrjnnOavCHeQzz9cnhYwW+081qNYexD/SueXyn1e6rzRjmjnmkg+qZEuvaQfJlVXKYZIfHfm9y3hXRyPgMc9vxUtzd+RhlMBRShfDZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cb+cXide; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cb+cXide"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62E3C19421;
	Wed,  8 Apr 2026 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672579;
	bh=Dfm5Ks+oGD6MWEB32K+suVtGYXjX557GZSFbDXfF2Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cb+cXideVROTavbF4AtJ75IoL57v3c5SV9RTfDNVKOFwXVc7O+F5pgYWUEDMQTcXc
	 krGQ9ssvySZquSremh0bNgvMxiat2pDt/XMETS5X5r6DeSyDTKmpEFlFg5dECTwxGk
	 6cF+ubn52oRfbegOgvyOA0CpuSw05ATjS1+ijrBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/160] net/sched: cls_fw: fix NULL pointer dereference on shared blocks
Date: Wed,  8 Apr 2026 20:02:27 +0200
Message-ID: <20260408175915.447696987@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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
index c49d6af0e0480..2e5e8df5ca55c 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -247,8 +247,18 @@ static int fw_change(struct net *net, struct sk_buff *in_skb,
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



