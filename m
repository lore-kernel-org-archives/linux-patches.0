Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484D9280CFB;
	Mon, 13 Apr 2026 16:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098210; cv=none; b=Vkyzeo1f9WORtZy4abrHYbwVEFWAPynHQCqZzNT0v3VCQycrL4IM5hCmFygAQLB+wGwZW81cYoSrfENa9sOqGJ1e+k5tC49YdvFm8iXCIoUDqv36r/PRHAl6CL3j0c3WWgESKaLMjULIT7TRfwjJi2VAFXEQT76IQpYcwkg4lZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098210; c=relaxed/simple;
	bh=HSMuRvSKEit6Pfbt6IXbAQEvtZxckm02KGMLtvgqNeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaoaVmGUK0NFPFJaiiZFD7vbb2lKLAc+Xo57HpG2XRFdNVk+PbYwlSWMaSBQtReu/F9KF9awkskmt9324/Cf5y1/+VmVx1om7i+SfYr777JRyE9n9uFNp5DqAh/v6vcgITRZIzSN/TPUrqfSTU0wo4sLMXE4zgzFlsleEuThmsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8T8/E71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8T8/E71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D0BC2BCAF;
	Mon, 13 Apr 2026 16:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098210;
	bh=HSMuRvSKEit6Pfbt6IXbAQEvtZxckm02KGMLtvgqNeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8T8/E71a6HE+5qLvAJQAYST+Fj0WAUnz/MYAYnbndPQEPJTZB1u5g7pR7k+o4fXF
	 sYh0ni2VCKIw6bBhxcHGAyNmW+WN7VStQdMTSAFuyx6V3d5EFJ5Vr4rAEKtZvIqrDK
	 63YVa/KOUXUuZrI9WLIYIEMRbZ+cU6rzZ0smclxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/570] net/sched: cls_flow: fix NULL pointer dereference on shared blocks
Date: Mon, 13 Apr 2026 17:59:26 +0200
Message-ID: <20260413155846.771138112@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index 22ed49748302f..74a6dbd234213 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -501,8 +501,16 @@ static int flow_change(struct net *net, struct sk_buff *in_skb,
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



