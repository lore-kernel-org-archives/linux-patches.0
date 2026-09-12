Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4171231B10B;
	Sat, 12 Sep 2026 13:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220903; cv=none; b=EJ8FdiQrodwNG0qlQ8PwTZFaH/wPtl2GglJu0QU1xC1JORoAl9dkL5+8jGNXsg6gUrfkuozmXfSvnpDoO4EFtPLahoFjtu0uoZuHiGs0iW5b+XOYeaVL5MIyfg/S937MTt0Q0lbuoQeNEHIjCBEFe3KZJeJ8AtQiLch2rTDAlDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220903; c=relaxed/simple;
	bh=4Sf1Dt2uXXUyiBbbOtJqz+ubAy3o/3C0iVtJm0pT0+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su/IeY89vB1cbC2GLm5+w+A1aFXkrzhQJwJTrwzp9w3xzEtY3n4QkEOtMt6sDaCu6d077UJr3WlEYDGay8OCpWZxPtRPGSE1Wj3+suVPbkhvlm5ldPTCvJko9OEumRSOn1o/LTQTv7wctPU09p9SrqtavX2k8avhEYPGkRmCNVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOJ/IWRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOJ/IWRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C03B1F000FF;
	Sat, 12 Sep 2026 13:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220901;
	bh=UkT9ghV+PDg5+Hpm+8awKYgwYKoVL2B5dpqJscPvQ70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UOJ/IWROTuG5n4a/40erOZpWxwJYeN3nluprzAk7BMtyYSTTbVl3niyEnnw6DOeqK
	 fXZvpA2H80Lknxhnvf26Dj0lKbG83PxZuHYniGlxWCX+Qk+PguwRfkF0QUHtxOmJuR
	 tJEPKxhF7oMxfJ0+NOBq9Dje3AcAVJteErCOJXf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 0273/1424] net: fix spurious TX timeout after dev_activate()
Date: Sat, 12 Sep 2026 08:45:05 +0200
Message-ID: <20260912065613.389886064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 82aeed2400786bd3f79d88cb8b8f42e6127e5923 upstream.

While debugging another issue today, I found out that my TX queue is
reported as stopped for 4294907392 ms (49.7 days), on a machine that
had been up for four minutes.

    bnxt_en 0002:01:00.0 eth0: NETDEV WATCHDOG: CPU: 28: transmit queue 23 timed out 4294907392 ms

4294907392 is not an elapsed time. It is the value of jiffies at that
moment: INITIAL_JIFFIES is 4294667296, which leaves jiffies 59 seconds
short of wrapping.

dev_activate() runs transition_one_qdisc() over every TX queue, which
resets trans_start to 0, and then stamps only queue 0 through
netif_trans_update().

Stamp jiffies instead. A queue stopped across dev_activate() now gets a
full watchdog_timeo of grace, and is still reported if it is stopped
that long.

Fixes: 9b36627acecd ("net: remove dev->trans_start")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260825-trans_start-v2-1-286b4d6d70cb@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1237,7 +1237,7 @@ static void transition_one_qdisc(struct
 
 	rcu_assign_pointer(dev_queue->qdisc, new_qdisc);
 	if (need_watchdog_p) {
-		WRITE_ONCE(dev_queue->trans_start, 0);
+		WRITE_ONCE(dev_queue->trans_start, jiffies);
 		*need_watchdog_p = 1;
 	}
 }


