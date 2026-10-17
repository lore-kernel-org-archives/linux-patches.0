Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC31F3AA9F3;
	Sat, 17 Oct 2026 16:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256374; cv=none; b=s7eaFlQnnlTyV7Pgx+9Us+m7qYQPjfqpCAE/SE8vQm3ey2tnBtGQaWj12PMP2sjsGX8N3YyfwFPeCv5WBsMfEzxxRqU+QC585Ql08toVMWzU2zn/7GRX6JXPN/WOXgWNu0EPmHYZqsIakQWwgo2efZqYWoPdn2p5rQh7OiIO6R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256374; c=relaxed/simple;
	bh=s1Y+EPbN0uNKkhc2rrfWQ+s2bOR0uD6vIq40nXep/go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp493ZuhKbLoKw7VHu1wJ+aXQbc8oJL/Unf6UPYdzhJtpFtxPcbO+JY5JGlPxx5rHKWlzoHxGEZIGtsD9SLzRD0Ta+eq8BGcGawA56ZgkHKIPviUDsqq62z/eNjX/5oHZphzjIHTGUC1/vrSnQefsYiCl7jb6pmBPcg6mKXyBLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6N6Dctv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6N6Dctv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238041F000C4;
	Sat, 17 Oct 2026 16:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256373;
	bh=SrAAV+aV/pAvG7pi1uTKdJ7Dzj8fOmJnrSrmg3cSG1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6N6DctvFwkm+Rbf0oSr8RSk3TuLIjcDVgAW1k0m0485598Xpf2VKDOB0LM8gfumL
	 yqs6dwazS/B0nvDuw0ZgIiN22mNu1qIHhH+EK4Mau8be7fFaXTiLCdvGB/uonclxcs
	 h2Kn3/5AsC9Tu6cojr3nIeHzi1CX08aim6zbJwxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0216/1674] net/sched: sch_codel: match the no-drop threshold to the packet size
Date: Sat, 17 Oct 2026 17:41:28 +0200
Message-ID: <20261017160436.694618143@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 54518e0e827f4ca9229ae657022c60bf60f5c1bf ]

commit 6439461f1618 ("net/sched: sch_codel: clamp default mtu to avoid
disabling CoDel") clamped q->params.mtu to [256, 1 << 20]. The value is
the CoDel no-drop threshold (codel_impl.h "*backlog <= params->mtu"), so
on a link whose maximum transmitted packet size is below 256 the floor
extends CoDel's minimum-backlog exemption beyond one packet and delays
drop or mark eligibility by several small packets.

Keep the upper bound that guards the original overflow (psched_mtu()
wrapping to ~2 GiB on a huge-MTU device) but drop the 256 floor, so the
threshold tracks the real device packet size.

Conditions to recreate the bug: attach a codel qdisc on a link whose
MTU plus hard_header_len is below 256 (e.g. a CAN interface). At that
MTU the no-drop threshold must equal the device MTU plus its
hard-header length; before this patch it was forced to 256.
Requires CAP_NET_ADMIN in a user namespace.

Fixes: 6439461f1618 ("net/sched: sch_codel: clamp default mtu to avoid disabling CoDel")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260819143136.57350-1-jhs@mojatatu.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-34MS.v1.20260925165535@mojatatu.com.2
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_codel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index c05be1eeea566..1f30dc76d20c7 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -228,7 +228,7 @@ static int codel_init(struct Qdisc *sch, struct nlattr *opt,
 	codel_params_init(&q->params);
 	codel_vars_init(&q->vars);
 	codel_stats_init(&q->stats);
-	q->params.mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
+	q->params.mtu = min_t(u32, psched_mtu(qdisc_dev(sch)), 1 << 20);
 
 	if (opt) {
 		int err = codel_change(sch, opt, extack);
-- 
2.53.0



