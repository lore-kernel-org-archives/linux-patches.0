Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207EC1DF251;
	Wed,  6 Nov 2024 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896004; cv=none; b=i575iiy1KmRXrcAs6FJve9X2eEMQB7iQpbKlueI7I8CwlQwCXqGICzWVsacZS88X8kAI0tKh6YcVpDet0bZT0ZND9cZ8onbWC5azwYZ0L144YAet+WXYTJYl8gs1wa+4Xk7EQNPvRmH15LcenDszMk1a3N0v2ruWPOC4Izprs2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896004; c=relaxed/simple;
	bh=9Y58C6c6hHEKPpHXbGnxF3stIaM69sbdEzzT39cJpDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVkZldgiLaqyRueGxJjKa5gJewMNrkmfYNs5jVbmHTHc1C3gPG9uUON7pRszIIv1M0Hb3xqQb/BhyFEqxz5oN8X+qxsym5AvYJSaNCvPPn3v2BxU8aoK2AhV7YIbBz0zGEtub7XnfrwscewWLZsOak84fml/JoI3NlQbDq/DLOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/TahPez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/TahPez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9979FC4CED3;
	Wed,  6 Nov 2024 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896004;
	bh=9Y58C6c6hHEKPpHXbGnxF3stIaM69sbdEzzT39cJpDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/TahPez8SyBnmXMMYiPs2TBSlmIIuWIG7LfbnxbNwUeAjq40CoYYAIrzAhtoUfz/
	 ZKa/HkiRCns7b3vy09S+CIHy8Jid7WNKzAhFcO7CEtwFuBblDr74Q9no8JjlYHlhva
	 qp7oCvKIIPzKIs3d1mHF05FvjoEBebCVZB0KY4ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 040/245] net/sched: sch_api: fix xa_insert() error path in tcf_block_get_ext()
Date: Wed,  6 Nov 2024 13:01:33 +0100
Message-ID: <20241106120320.211915089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit a13e690191eafc154b3f60afe9ce35aa9b9128b4 ]

This command:

$ tc qdisc replace dev eth0 ingress_block 1 egress_block 1 clsact
Error: block dev insert failed: -EBUSY.

fails because user space requests the same block index to be set for
both ingress and egress.

[ side note, I don't think it even failed prior to commit 913b47d3424e
  ("net/sched: Introduce tc block netdev tracking infra"), because this
  is a command from an old set of notes of mine which used to work, but
  alas, I did not scientifically bisect this ]

The problem is not that it fails, but rather, that the second time
around, it fails differently (and irrecoverably):

$ tc qdisc replace dev eth0 ingress_block 1 egress_block 1 clsact
Error: dsa_core: Flow block cb is busy.

[ another note: the extack is added by me for illustration purposes.
  the context of the problem is that clsact_init() obtains the same
  &q->ingress_block pointer as &q->egress_block, and since we call
  tcf_block_get_ext() on both of them, "dev" will be added to the
  block->ports xarray twice, thus failing the operation: once through
  the ingress block pointer, and once again through the egress block
  pointer. the problem itself is that when xa_insert() fails, we have
  emitted a FLOW_BLOCK_BIND command through ndo_setup_tc(), but the
  offload never sees a corresponding FLOW_BLOCK_UNBIND. ]

Even correcting the bad user input, we still cannot recover:

$ tc qdisc replace dev swp3 ingress_block 1 egress_block 2 clsact
Error: dsa_core: Flow block cb is busy.

Basically the only way to recover is to reboot the system, or unbind and
rebind the net device driver.

To fix the bug, we need to fill the correct error teardown path which
was missed during code movement, and call tcf_block_offload_unbind()
when xa_insert() fails.

[ last note, fundamentally I blame the label naming convention in
  tcf_block_get_ext() for the bug. The labels should be named after what
  they do, not after the error path that jumps to them. This way, it is
  obviously wrong that two labels pointing to the same code mean
  something is wrong, and checking the code correctness at the goto site
  is also easier ]

Fixes: 94e2557d086a ("net: sched: move block device tracking into tcf_block_get/put_ext()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20241023100541.974362-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 17d97bbe890fd..bbc778c233c89 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1518,6 +1518,7 @@ int tcf_block_get_ext(struct tcf_block **p_block, struct Qdisc *q,
 	return 0;
 
 err_dev_insert:
+	tcf_block_offload_unbind(block, q, ei);
 err_block_offload_bind:
 	tcf_chain0_head_change_cb_del(block, ei);
 err_chain0_head_change_cb_add:
-- 
2.43.0



