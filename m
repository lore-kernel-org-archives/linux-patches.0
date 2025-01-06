Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EE116D9B8;
	Mon,  6 Jan 2025 15:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178112; cv=none; b=WvmdBUS/JYLxXVzjrV9vCvfqNJzBoHSFEBsrMu83HuAAV8lSfF5EHV8qlSeNTFHkBxHXSsQhbiYEg32FsFAzi0J5Jw28+8l3rhCdGPxDO0oA9L14kHkMTJBxSXddT11ckRgAnirnNEs9CEXxLelHpBQddDSF0kMuDqiJPIOWefI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178112; c=relaxed/simple;
	bh=46n9B6XXb2nfPQ451zID9BJsU02x9HWZk2zB2vvgAm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hipsljo1GwwJJwCtBM5eCRJYI7IRXDxCSXTlGx+4F1adtjJdyHX7GwQadLsuRtL3ekeUfTcbtw1VKnZgps7QJ/qRjgVFt/PSwrWbRdH24KsOCRz9JUUd1+UK4DavQ0/epLz1Ocv2vWNNjRYw0XIfuI7fLZjGhe8Ee36MaW8bS/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9hqqr+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9hqqr+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762B5C4CED2;
	Mon,  6 Jan 2025 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178111;
	bh=46n9B6XXb2nfPQ451zID9BJsU02x9HWZk2zB2vvgAm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9hqqr+uafmom11ImJ26bgSrgG00dj9tZRGtojBOFQ1Y9n6vOsAqfcPYVrv6JyZhX
	 3gzMYOruRc1/azrRSAHbm3lH1obcA4Me3f2dIQ0fPwjCpJAeHDrCUnal3MEG5SFcf4
	 EQyH1Xqsltblm00y37wfK96q0vc/Roac/0cDiLqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lion Ackermann <nnamrec@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	"David S. Miller" <davem@davemloft.net>,
	Artem Metla <ametla@google.com>
Subject: [PATCH 5.10 001/138] net: sched: fix ordering of qlen adjustment
Date: Mon,  6 Jan 2025 16:15:25 +0100
Message-ID: <20250106151133.268907860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lion Ackermann <nnamrec@gmail.com>

commit 5eb7de8cd58e73851cd37ff8d0666517d9926948 upstream.

Changes to sch->q.qlen around qdisc_tree_reduce_backlog() need to happen
_before_ a call to said function because otherwise it may fail to notify
parent qdiscs when the child is about to become empty.

Signed-off-by: Lion Ackermann <nnamrec@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Artem Metla <ametla@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cake.c  |    2 +-
 net/sched/sch_choke.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1541,7 +1541,6 @@ static unsigned int cake_drop(struct Qdi
 	b->backlogs[idx]    -= len;
 	b->tin_backlog      -= len;
 	sch->qstats.backlog -= len;
-	qdisc_tree_reduce_backlog(sch, 1, len);
 
 	flow->dropped++;
 	b->tin_dropped++;
@@ -1552,6 +1551,7 @@ static unsigned int cake_drop(struct Qdi
 
 	__qdisc_drop(skb, to_free);
 	sch->q.qlen--;
+	qdisc_tree_reduce_backlog(sch, 1, len);
 
 	cake_heapify(q, 0);
 
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -124,10 +124,10 @@ static void choke_drop_by_idx(struct Qdi
 	if (idx == q->tail)
 		choke_zap_tail_holes(q);
 
+	--sch->q.qlen;
 	qdisc_qstats_backlog_dec(sch, skb);
 	qdisc_tree_reduce_backlog(sch, 1, qdisc_pkt_len(skb));
 	qdisc_drop(skb, sch, to_free);
-	--sch->q.qlen;
 }
 
 struct choke_skb_cb {


