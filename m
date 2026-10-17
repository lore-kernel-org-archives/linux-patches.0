Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A583ADBA4;
	Sat, 17 Oct 2026 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256371; cv=none; b=LHbqgh9YVL83IU8+Ku7vueO6YmCGBJZ92XSdgxjbe26GgyFvN5Brr9ooN5CV6Ha2o045GFQxY5CmT9UYqBA66qm0xILZ7EXK1v193/1YiiETLY+sv8q43lWd441+ME0UiQLJXXU/Dhu8CBSmaWYYliXa3mYHeRWUcsOf1xHO3L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256371; c=relaxed/simple;
	bh=bKgVKB2N2gU7sX6tQRIuIuqxV4l65NHUldPhH0n4RKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcgFmAxoEx/QmE2F+TS9T6QYPKfFIfAo0gVjW/uxHZ6hhRBWsL1kOatlOhDm9ynkIN9UdNaHAmZmdtmu80qrqWG07elNTe468KAn1pkxkkCFyzREpjVJX4xWo4UZrR7TXnxn8+B8GE0gFmZ8oaGdBFHLOguNCyH4E0m2P9u6jt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrPM6E/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrPM6E/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15621F000C4;
	Sat, 17 Oct 2026 16:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256370;
	bh=S59ywalC8dDGvURTb+tMeWoeIfThLE/95aq45BDGPGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrPM6E/zqEdZTEq9VgbTKWHjGwzbxE5b5HtmJQIISpPipyF86WdUu0S22BBGAhthQ
	 fb1JFl4lmt8fL0H7zByhSGWzg1PEojzh+/43jvJ/mmrsvEpiGASZL/7Frl6B2rSM3T
	 L1x59OEg4B1n4PYSJ8NAUFvgYWSnHO4+eNKnqAig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0215/1674] net/sched: fq_codel: match the no-drop threshold to the packet size
Date: Sat, 17 Oct 2026 17:41:27 +0200
Message-ID: <20261017160436.668802226@linuxfoundation.org>
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
index ac2f643dd8427..08cb94bf5950b 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -503,8 +503,8 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
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



