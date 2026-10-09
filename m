Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67464E780C;
	Fri,  9 Oct 2026 14:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555728; cv=none; b=J43UvqzTp6UFVVCqOzcktiuz2FjEBO/UZUzKwZNgtm/f2AxRbOZMtRv1CtmwKGZsYE39zF4ADrpf6kmo6HWE2HOz31sgvet2FYyyqjJxTSGdsD5uHfgoYQlZIDePamvBi0WsVFKpYVyFwrbA426DFLC6Lbm7TPLQRcDoahj9Q9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555728; c=relaxed/simple;
	bh=EotnESlJxcS4nFAaWOWmWns3OZ0Dg+4CQAdTssDQIqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijLbF6YM9OXBE2RivCDiytIDFQpJd5r8cDNLcoDCYjobQYOoCIVOQ/p9ljfFEfb1Iy9p2t9Mnd5vM9ekW9G4E1MgQLGbQJwJ9Ekz3o2OnCYq/HzoddkeGRq/l9kghyWQge1dxyjbEUbfho/LEBAy9Zzl3A8ImeadlH3Zukqpsuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNwdAyDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNwdAyDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2152D1F000FF;
	Fri,  9 Oct 2026 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555727;
	bh=lnTHLIGxJdFs8Jbqq3l8jMCZRKZa5q4DujijGvq2n88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNwdAyDC/RjSnketOA7rJ+vrcjDqJ401HNpV8bSJcFiAkwUUSiHtJtwN2ACKanNvj
	 FQrH3wyyfd/jHPiP6/6ji7pTUftKp+z+yf6Z5yHHXnw4dtGxru7TUZPNMwUl23UNm8
	 JejRVnMsuOhznKcTrexXMSzPnha5CrNtc4k4D4Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/403] net/sched: sch_codel: match the no-drop threshold to the packet size
Date: Fri,  9 Oct 2026 16:07:47 +0200
Message-ID: <20261009140954.561688777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
index 1d2caed1bf5b8..4a639555de79d 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -206,7 +206,7 @@ static int codel_init(struct Qdisc *sch, struct nlattr *opt,
 	codel_params_init(&q->params);
 	codel_vars_init(&q->vars);
 	codel_stats_init(&q->stats);
-	q->params.mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
+	q->params.mtu = min_t(u32, psched_mtu(qdisc_dev(sch)), 1 << 20);
 
 	if (opt) {
 		int err = codel_change(sch, opt, extack);
-- 
2.53.0



