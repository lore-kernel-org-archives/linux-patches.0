Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F22424649;
	Thu, 16 Jul 2026 13:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209490; cv=none; b=kNldDwXNL6fV9mHE8q0u5fWYyTi5B/peHU9q2taUOevRGgkmzftInpF60Scmlj6/YWvLNwmy+vBhCLowMQU4tTrxku+wMAMrcHX+c155x7PZ3zbqyGONq8Sts/QFWC/HU2SjgmMgsrSFU979kmGSvYgu50kuYiMPYi8yVtncqOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209490; c=relaxed/simple;
	bh=fqC+d64BIhcQ9lmuibkfC37eDBcKvbrAtXCj30P3uKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfvS+Wtn31/aPkDJFbolUyGCGrJ7c/ERDKrVMIjhKthiV+2LvmvZD/kwMiMPZ1YsiRgNgsm7ST1dDEgR33KN3kBMpnwNZlcXDl9Hwzbu6XTZkLpkBicEzd6WwI6ufl+IGwyi0fb3prkesnUN4/2CkjDqGbQF+jNw+nw6IyrFBvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7BmsN64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7BmsN64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEC01F00A3E;
	Thu, 16 Jul 2026 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209487;
	bh=bfoEu6SMpPC2mVxDZ6xNM6RdBvGkwZ+uof1i6t9wODw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7BmsN6487vrm+3sv6yLk6gK9Jg69MaiGERZv5d8NvEAJW8Ywqa6JjnP8FBH+TQcV
	 OeKmyelax9B9vLgXgQEAZ/wTu4X5M3tIm3Xgj/vPtdWAVGfYm/ka970RjzVQW9FVbH
	 5ogKUd+SSUwcHoYG7xTRRdUdUliP0B74tbp0HRzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhengyang Chen <chzhengyang2023@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 203/518] netfilter: flowtable: IPIP tunnel hardware offload is not yet support
Date: Thu, 16 Jul 2026 15:27:51 +0200
Message-ID: <20260716133052.263930408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 6c5dcab95f4cd42a1648739ec9300fbb4b1a021f upstream.

No driver supports for IPIP tunnels yet, give up early on setting up the
hardware offload for this scenario.

This patch adds a stub that can be enhanced to add more configuration
that are currently not supported. As of now, the offload work is
enqueued to the worker, then ignored if the hardware offload
configuration is not supported.

Check the NF_FLOW_HW flag to know if this entry was already tried once
to be offloaded so this is not retried on refresh when unsupported. Move
NF_FLOW_HW flag check to nf_flow_offload_add(). If this NF_FLOW_HW flag
is unset the _del and _stats variants are never called.

This can be updated later on to skip hardware offload work to be queued
in case hardware offload does not support it.

Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_flow_table.h |    2 ++
 net/netfilter/nf_flow_table_core.c    |    7 +++----
 net/netfilter/nf_flow_table_offload.c |   22 ++++++++++++++++++++--
 3 files changed, 25 insertions(+), 6 deletions(-)

--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -357,6 +357,8 @@ static inline int nf_flow_register_bpf(v
 
 void nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow);
+void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
+			     struct flow_offload *flow);
 void nf_flow_offload_del(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow);
 void nf_flow_offload_stats(struct nf_flowtable *flowtable,
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -345,10 +345,8 @@ int flow_offload_add(struct nf_flowtable
 
 	nf_ct_refresh(flow->ct, NF_CT_DAY);
 
-	if (nf_flowtable_hw_offload(flow_table)) {
-		__set_bit(NF_FLOW_HW, &flow->flags);
+	if (nf_flowtable_hw_offload(flow_table))
 		nf_flow_offload_add(flow_table, flow);
-	}
 
 	return 0;
 }
@@ -369,7 +367,8 @@ void flow_offload_refresh(struct nf_flow
 	    test_bit(NF_FLOW_CLOSING, &flow->flags))
 		return;
 
-	nf_flow_offload_add(flow_table, flow);
+	if (test_bit(NF_FLOW_HW, &flow->flags))
+		nf_flow_offload_refresh(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1101,9 +1101,17 @@ nf_flow_offload_work_alloc(struct nf_flo
 	return offload;
 }
 
+static bool nf_flow_offload_unsupported(struct flow_offload *flow)
+{
+	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
+	    flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.tun_num)
+		return true;
 
-void nf_flow_offload_add(struct nf_flowtable *flowtable,
-			 struct flow_offload *flow)
+	return false;
+}
+
+void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
+			     struct flow_offload *flow)
 {
 	struct flow_offload_work *offload;
 
@@ -1114,6 +1122,16 @@ void nf_flow_offload_add(struct nf_flowt
 	flow_offload_queue_work(offload);
 }
 
+void nf_flow_offload_add(struct nf_flowtable *flowtable,
+			 struct flow_offload *flow)
+{
+	if (nf_flow_offload_unsupported(flow))
+		return;
+
+	set_bit(NF_FLOW_HW, &flow->flags);
+	nf_flow_offload_refresh(flowtable, flow);
+}
+
 void nf_flow_offload_del(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow)
 {


