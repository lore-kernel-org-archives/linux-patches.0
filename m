Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C8A199FA0;
	Tue, 10 Sep 2024 10:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963602; cv=none; b=qsjvK9wZwtYvIe9aU8SrhlAiLRDMqv/EWSndl68SPd6lw6Pel4HcSqoOPvHZ5W6ReoDXx7prhwCCai51pZWuh3SrE3T+FfHQLxt8oAmHLoqd41UKcENZXgv4RjpXUJtFRFxCKQAIxDss5G78o1u52mPC2t29JU7OuCcBJNSTqhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963602; c=relaxed/simple;
	bh=MVYozCpN+Q/i/mHV314skEOtDhEQyz+sPxMyDHhz98k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P0Qk8YDsH1xoURulAoumA2YjWK3/vK9zAVoEocYr/aHWI+s80xOZw555zLDVQhiHrcbUFKUIX6LDcGOhWqlpgYnklQTNMTequHb60FheeM6AC36T1SBu++C6YQ5AYC6Ck/ugNVDRIL/PdzJLj7OyZiuh7TnaGUqdmxnIigyEwa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pcx55CG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pcx55CG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF40C4CEC6;
	Tue, 10 Sep 2024 10:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963602;
	bh=MVYozCpN+Q/i/mHV314skEOtDhEQyz+sPxMyDHhz98k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pcx55CG8nSK5kcpjFx6aOjGVOHRcsOXP3IWOTk8YwGV9S98u8fWwcjFGml7rJmJTv
	 gwG1zPkXhW0vD6JA8863oSneKZB/O10VkqO1Jc/az3Gbq4ftj4HLSvuQOnkrXRS0qB
	 FdflhdfsMVKIP4Xu1fDq14zyEiCEIA/wwPLXIohM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7fe7b81d602cc1e6b94d@syzkaller.appspotmail.com,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 087/214] sched: sch_cake: fix bulk flow accounting logic for host fairness
Date: Tue, 10 Sep 2024 11:31:49 +0200
Message-ID: <20240910092602.308824254@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit 546ea84d07e3e324644025e2aae2d12ea4c5896e upstream.

In sch_cake, we keep track of the count of active bulk flows per host,
when running in dst/src host fairness mode, which is used as the
round-robin weight when iterating through flows. The count of active
bulk flows is updated whenever a flow changes state.

This has a peculiar interaction with the hash collision handling: when a
hash collision occurs (after the set-associative hashing), the state of
the hash bucket is simply updated to match the new packet that collided,
and if host fairness is enabled, that also means assigning new per-host
state to the flow. For this reason, the bulk flow counters of the
host(s) assigned to the flow are decremented, before new state is
assigned (and the counters, which may not belong to the same host
anymore, are incremented again).

Back when this code was introduced, the host fairness mode was always
enabled, so the decrement was unconditional. When the configuration
flags were introduced the *increment* was made conditional, but
the *decrement* was not. Which of course can lead to a spurious
decrement (and associated wrap-around to U16_MAX).

AFAICT, when host fairness is disabled, the decrement and wrap-around
happens as soon as a hash collision occurs (which is not that common in
itself, due to the set-associative hashing). However, in most cases this
is harmless, as the value is only used when host fairness mode is
enabled. So in order to trigger an array overflow, sch_cake has to first
be configured with host fairness disabled, and while running in this
mode, a hash collision has to occur to cause the overflow. Then, the
qdisc has to be reconfigured to enable host fairness, which leads to the
array out-of-bounds because the wrapped-around value is retained and
used as an array index. It seems that syzbot managed to trigger this,
which is quite impressive in its own right.

This patch fixes the issue by introducing the same conditional check on
decrement as is used on increment.

The original bug predates the upstreaming of cake, but the commit listed
in the Fixes tag touched that code, meaning that this patch won't apply
before that.

Fixes: 712639929912 ("sch_cake: Make the dual modes fairer")
Reported-by: syzbot+7fe7b81d602cc1e6b94d@syzkaller.appspotmail.com
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20240903160846.20909-1-toke@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cake.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -785,12 +785,15 @@ skip_hash:
 		 * queue, accept the collision, update the host tags.
 		 */
 		q->way_collisions++;
-		if (q->flows[outer_hash + k].set == CAKE_SET_BULK) {
-			q->hosts[q->flows[reduced_hash].srchost].srchost_bulk_flow_count--;
-			q->hosts[q->flows[reduced_hash].dsthost].dsthost_bulk_flow_count--;
-		}
 		allocate_src = cake_dsrc(flow_mode);
 		allocate_dst = cake_ddst(flow_mode);
+
+		if (q->flows[outer_hash + k].set == CAKE_SET_BULK) {
+			if (allocate_src)
+				q->hosts[q->flows[reduced_hash].srchost].srchost_bulk_flow_count--;
+			if (allocate_dst)
+				q->hosts[q->flows[reduced_hash].dsthost].dsthost_bulk_flow_count--;
+		}
 found:
 		/* reserve queue for future packets in same flow */
 		reduced_hash = outer_hash + k;


