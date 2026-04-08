Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BB4347BA9;
	Wed,  8 Apr 2026 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673088; cv=none; b=LytDkI5vY8wT4pBuDaKZNXc8rjsooELZeHq2mRGMAypRreD8UL5MKrURnxvQA/R/rD8PRaMvKFVWBVy5MGT6u+MY804Ua0rmqbJH3dWagHEofSGQbVEg3ClIv4WQIbxf2mBBOaWazm2z8QLZU26blF8Rzp4x655hGnBa/5VeP68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673088; c=relaxed/simple;
	bh=7sfI17Hvyz0CnnaRPmEi321FgDByTdvwWeJRVfZUkBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSwCHEE0MAsVCr7rsv7b2TtKNjFg4OjpW7Ye3YusbYj/hI94O8Loi0JGM5a3DK8J/XXusFlx4+CZAG3dcKTnaE2agz6IPPKnJnelTOLL4OIOGAAJJiS3EVmbFbZblwRR7flb8SJlkyaTrZhYqFTo9nca7nx1bor3U1Qrypmg1xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqT/f35a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqT/f35a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B37C19421;
	Wed,  8 Apr 2026 18:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673088;
	bh=7sfI17Hvyz0CnnaRPmEi321FgDByTdvwWeJRVfZUkBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqT/f35ayHkoO10dtbIkQ/y/zNTKnEFf660MMf6opaAs2q0ZxIoyOPHdU29SPSSSU
	 KygKZ5jQsQRj3zzaSqfQAF7+HsoWMYtPwgSSEnzHS3wajNisVxuBKSdycS1AxT6xC3
	 nNLA7PZhdGEjUG5JdSgTJ23B68u45TNiyMRWdAK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/277] net/sched: cls_fw: fix NULL pointer dereference on shared blocks
Date: Wed,  8 Apr 2026 20:01:21 +0200
Message-ID: <20260408175937.459787832@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cdddc86952284..83a7372ea15c2 100644
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



