Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211002;
	b=kZTo0sEL40E9XHwue/2bUJjV3ayRYMAj33EN4IzCwKmPBdHNTSNzmAzrv2s3z/QpbYb4
	 58jSktOdtmAZvc1uoT8P3cADAntual+DCifoBwoRHoo4jHlfHMcSaeoHny74jYOgtob33
	 B2OshHCvnlP5BYe7NwhXynzyRUMd3sf2aeWsVqWobHgjggzAiufqJzIIAZM6xUlBgJfCx
	 4Y5n/UQUkhFlVyhmPRJiirxeN7PfI2Wxz2uac5X05XWcL8If6l971R387ZwuyyJ3Q1CwC
	 kzZBXTo0oXbYTQ4Lgi2gcPrPW4WlSekZoZL9x0yvMhZdgGzudG5pvwj26nuyPGl/AgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AelSTaqv4wET8EHSnGMSqPL2tyoYYBR474jAJsZgN6E=;
	b=J4pXRRXKa6eAz3NYDqvmhbUjdJcMDXtzK6LMOpDbDC5NTkoKlbyACFbRRh+s5fUR4ow4
	 J3PeP8La201HzX/kFb6v3czB5VMph4u+ZG6c/KCzTsAQqZpq8Jh1yaGrT7n18OjtWdH85
	 yzsslDzGU6pgG/XfDbmpJoJv7vKvBwASsFwF1AaEKlFDytATbBazI97KZX0tEPdyexnt2
	 zKu/Od4JfUUFaTuTAdAHnounWB9gBMqsNNXbBhpoUC4HjRgq3nnEHlEXMbQtS9NPyFPY8
	 NmZCBNH5wEzLEMISlONw3zof9xfmZKxoCrFSPUQOYAbnTvjSvx/JgNoY1XtIllDpnzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhKeLQUq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EFA606A31D;
	Wed, 28 Oct 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhKeLQUq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117B91F01825;
	Wed, 28 Oct 2026 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211001;
	bh=AelSTaqv4wET8EHSnGMSqPL2tyoYYBR474jAJsZgN6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhKeLQUqTrzuivriMj/1W7oJFxwXoFB8Kyq8EbWKBwRaKox8eDdwirhPcdFNYH8Ph
	 l4xuzxdKo7X2IvnF0AVR+E4G8MUb/kcZD/xtiruWTahIuqysxt7dPV3Z/ehIGn3brm
	 /HupTLhCek3BC9GUTYTaeFaXtmR7Amoo8psY9118=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/571] net/sched: fq_codel: match the no-drop threshold to the packet size
Date: Wed, 28 Oct 2026 17:55:26 +0100
Message-ID: <20261028170012.261345559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit d031465acc362866f27e4f8f79cfecf1037fe2e5 ]

commit d9ebd8f9aa8b ("net/sched: fq_codel: clamp default quantum and mtu")
clamped both q->quantum and q->cparams.mtu to [256, FQ_CODEL_QUANTUM_MAX].
The two fields mean different things: quantum is a DRR credit that wants
the 256 floor, but cparams.mtu is the CoDel no-drop threshold
(codel_impl.h "*backlog <= params->mtu"). On a link whose maximum
transmitted packet size is below 256, the floor extends CoDel's
minimum-backlog exemption beyond one packet and delays drop or mark
eligibility by several small packets.

Split the clamp. quantum keeps [256, FQ_CODEL_QUANTUM_MAX]; cparams.mtu
tracks psched_mtu() (the device MTU plus its hard-header length) with
only the upper bound that guards the original overflow (psched_mtu()
wrapping to ~2 GiB on a huge-MTU device).

Conditions to recreate the bug: attach an fq_codel qdisc on a link
whose MTU plus hard_header_len is below 256 (e.g. a CAN interface). At
that MTU the no-drop threshold must equal the device MTU plus its
hard-header length; before this patch it was forced to 256.
Basic Testing done: with dev->mtu=100 and hard_header_len=14, a
return probe on fq_codel_init() observed cparams.mtu change from 256 to 114

Fixes: d9ebd8f9aa8b ("net/sched: fq_codel: clamp default quantum and mtu")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260819143136.57350-1-jhs@mojatatu.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-34MS.v1.20260925165535@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_codel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index f801b6af33c0d..bfb7d77c294a9 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -499,8 +499,8 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 	q->flows_cnt = 1024;
 	q->memory_limit = 32 << 20; /* 32 MBytes */
 	q->drop_batch_size = 64;
-	mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, FQ_CODEL_QUANTUM_MAX);
-	q->quantum = mtu;
+	mtu = min_t(u32, psched_mtu(qdisc_dev(sch)), FQ_CODEL_QUANTUM_MAX);
+	q->quantum = clamp_t(u32, mtu, 256, FQ_CODEL_QUANTUM_MAX);
 	INIT_LIST_HEAD(&q->new_flows);
 	INIT_LIST_HEAD(&q->old_flows);
 	codel_params_init(&q->cparams);
-- 
2.53.0



