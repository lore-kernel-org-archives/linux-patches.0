Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208579;
	b=MAYdmk46i78LnhKegdJP4ZKKAQLFIHJM7AnoMLcgoIE5W0DykKm2lZP8qgl3Srec9HHw
	 xK7/zdYcIeUXrcQwIvotWssUWxNM+O8NdzARH1nk4l4yLqn8zE58U7/b3ZRpRU2823qH/
	 B+84Sakqf5wFB0dGEVb8BLUH0U5HXyhyencaBPQmCn6dii5iPlDA4SJOnBkKwhrwv3eDr
	 cVESFvDxCze1zvnmP9h8scoxsb0r7xjhmgyS7ZK88tQZfdgDMHHr9jciCmJIPKKXVtB5a
	 /I9Gu+mpqj6zlfjucWs3mCvTTUhIwZt30XjCNC6ZmKywFbJuuCknKo8IZ130AZ/0x0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NDEezDdKuBbLq6ijDLbfibwV3wlNjDe2I47E+anC2Yo=;
	b=5sE1/QNFAfq3z+k4siJN7OLkk3ZmArbYafrYo5nrnNqXuuhimGjq+XJFT1zey5f7pUqL
	 1PdE7ZRAFijwxP9bNyhXp9XvO1WvdvXI62J2vx1uvRpTsk8KgEYSdLIbUjGNMzL4v/aaC
	 AnQtGbQrMWiduHsnS3ZITIzIlVUqcp54Od9M43m+I/NUSChnZZlaA4hdn61xh+su+L3sQ
	 CnsuCQcXqVwOmpwLGGb9Xjqg9kP4UpV4P56vB0yWU3HS7v1K4eYUaFH6aydWjnsrisiyf
	 gGf5DzSHRadqBT0AgEuUx7+WIMu9Ol86CEJBt9NYrpdEpLpLKZ1Jo5oPlhJcx2WEVYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbBO4163;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47531606A31A;
	Wed, 28 Oct 2026 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbBO4163
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9998E1F01825;
	Wed, 28 Oct 2026 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208579;
	bh=NDEezDdKuBbLq6ijDLbfibwV3wlNjDe2I47E+anC2Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbBO4163ptgqW4sxpGtU4kWBpmsUptOLLdJ5FSZMpF9fgm5Yij7Z+fdMrzWXBqfsx
	 Fl1OWneKZGp6DE3af33CDocdjr+JgdMpnYd/Mc+f2uHRp52IVPD2XnY5iJeIoF7Fmg
	 tPefHAVzgydaTeNunyjHxg3FTqSJsTZReNDA62c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/516] net/sched: fq_codel: match the no-drop threshold to the packet size
Date: Wed, 28 Oct 2026 17:55:21 +0100
Message-ID: <20261028170007.509859749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4a8e85622aa6e..c712d98fa3a22 100644
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



