Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692C546C84F;
	Thu, 20 Aug 2026 16:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243611; cv=none; b=T1wWNJkmvDwEPqMg9t7D99qVaaacvF1T1pOMiZJ4U5d/eUEXGKMjhjUql2+DIUoPajiVTWKqOaxz13JYupHnYuIcXLo1lKECuapRHfJ9O5fu2LPqQTzamrnjuoSAhbdqsHYuZUA62R1QoXS3jqG401Yv7DmnZzhhlQ/wiw50SlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243611; c=relaxed/simple;
	bh=p9vNtYej5MwbtGpQDILnCS2TGVYNtkrH9P47nAXZ+QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGbpUj+PqG4dy0a/mBehY4d253yj3X8hE/ROw0SwkV7pr8/warqjgafmDv5WqWC/o5Nc/Wsl7lDylBL3MbJ/UX8t76DL6/qnU57wCiejeX2MqtSj8zu5Eusb4AeIUwkXkzYIqYT/k4YkhTLWfXkJabiIEFdWA9lLuYyp0TogfjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxebSHMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxebSHMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D0A1F000E9;
	Thu, 20 Aug 2026 16:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243610;
	bh=Fg2pta6EWEVU6RaplOLgsktif7inK8AyZtyL1gMQG0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxebSHMpr7SmHZcPZ1JVvj7DFdXcYNgG/qZmuzFODcSfpgGwL34n9oD6ih6hm9Gc+
	 oZJ/DzKluC2sMRC4LnCKTuNOrqdfK5iP31rZz4mcsyfLG62n5cy9U4/ExxBB46/RBQ
	 yZDZNI9oonDq05Zz/Z8pYvvtF45VkfYerUbfRvpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/272] net/sched: taprio: avoid calling child->ops->dequeue(child) twice
Date: Thu, 20 Aug 2026 16:55:37 +0200
Message-ID: <20260820145235.902911608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4c22942734f0814d3c928c25a80f48df0a6ce45e ]

Simplify taprio_dequeue_from_txq() by noticing that we can goto one call
earlier than the previous skb_found label. This is possible because
we've unified the treatment of the child->ops->dequeue(child) return
call, we always try other TXQs now, instead of abandoning the root
dequeue completely if we failed in the peek() case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e056e1dfcddc ("net/sched: sch_taprio: Replace direct dequeue call with peek and qdisc_dequeue_peeked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -557,12 +557,8 @@ static struct sk_buff *taprio_dequeue_fr
 	if (unlikely(!child))
 		return NULL;
 
-	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-		skb = child->ops->dequeue(child);
-		if (!skb)
-			return NULL;
-		goto skb_found;
-	}
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags))
+		goto skip_peek_checks;
 
 	skb = child->ops->peek(child);
 	if (!skb)
@@ -589,11 +585,11 @@ static struct sk_buff *taprio_dequeue_fr
 	    atomic_sub_return(len, &entry->budget) < 0)
 		return NULL;
 
+skip_peek_checks:
 	skb = child->ops->dequeue(child);
 	if (unlikely(!skb))
 		return NULL;
 
-skb_found:
 	qdisc_bstats_update(sch, skb);
 	qdisc_qstats_backlog_dec(sch, skb);
 	sch->q.qlen--;


