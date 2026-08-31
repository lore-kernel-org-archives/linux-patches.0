Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACD1438013;
	Mon, 31 Aug 2026 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184613; cv=none; b=lKsQ2jxLE8bbFJasL9BliUcHfRYXr86traFHRCdFNPDCC3N/G96983FTVlLP4iDuj7Mh2K/9Vw81UzlZ3d55RvEN2U41rp5kkt1TX37aWuS7jGSXceqZ1IQUeWSUf1hGrog1rkeljF4/r/dDThrMtxbDjkbfp1/+xgpLQwoywHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184613; c=relaxed/simple;
	bh=OOIkjxlAIkMp0uSYcCBqcU5UDYzqh6qJl2TU/T7iQ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsEMdn2zEBnBQ0mFA2tuiOiTHbhsxk+n0kEFvqr2Nz43AzEQm1v3UqMhESgElME0RIeXh05Tn7gtiHk0iMdSpfLyYXTiIRWGwEauLht6H1Ar+b9KxLE2RdOpnEtZx+OQTeT5DAQIfqy0VVWJ7bldHOddEMg9ovUzG2w29AdcviI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZ55Ux4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZ55Ux4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831E81F000E9;
	Mon, 31 Aug 2026 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184612;
	bh=LI4J6AOCU0kjC8BrW/89/VzFes45ylq14BHR/0KA4V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZ55Ux4oxtE0HkCAAE0s0SiW0xTI8i0veBvN3Na9vjsh9dtcrbcZP61Gz+ptiNzc1
	 ArCV5yiDPliotvJ7pAg+/ioaEJHl2Za9tGoeBeoqTaFMGphHHAS7YQOZGkPGoLqubF
	 rVUOhl9yLWqnjpcQPyiQZlZKCPiRnVkNB5cXO6jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 31/91] net/sched: initialize noop_qdisc owner
Date: Mon, 31 Aug 2026 15:34:19 +0200
Message-ID: <20260831133401.329986125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 44180feaccf266d9b0b28cc4ceaac019817deb5c ]

When the noop_qdisc owner isn't initialized, then it will be 0,
so packets will erroneously be regarded as having been subject
to recursion as long as only CPU 0 queues them. For non-SMP,
that's all packets, of course. This causes a change in what's
reported to userspace, normally noop_qdisc would drop packets
silently, but with this change the syscall returns -ENOBUFS if
RECVERR is also set on the socket.

Fix this by initializing the owner field to -1, just like it
would be for dynamically allocated qdiscs by qdisc_alloc().

Fixes: 0f022d32c3ec ("net/sched: Fix mirred deadlock on device recursion")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240607175340.786bfb938803.I493bf8422e36be4454c08880a8d3703cea8e421a@changeid
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 1bb8862698030..65561ecae516b 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -684,6 +684,7 @@ struct Qdisc noop_qdisc = {
 		.qlen = 0,
 		.lock = __SPIN_LOCK_UNLOCKED(noop_qdisc.skb_bad_txq.lock),
 	},
+	.owner = -1,
 };
 EXPORT_SYMBOL(noop_qdisc);
 
-- 
2.53.0



