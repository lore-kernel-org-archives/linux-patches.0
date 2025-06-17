Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73312FA623;
	Tue, 17 Jun 2025 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179345; cv=none; b=Nz4qah+XoDK2QOccO1wAzMAfo336sCWvFoLy7tOCNniFZdsmNlXj5J9LWzO2jhSCNgLaCDIer0e76RTzNNiyEBKnpTTuFxPEAUhRmiQJY+fZMH9DcQBWYqJAEMhAQ8/mhOY1y79MT6WfbAt0kfXYNSLBh7OwBanT3Grpsw4S9+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179345; c=relaxed/simple;
	bh=oDRSFhxsjnsNrXGDeDKaDQbcDsPgzqCr2Tx1FpCZo+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaANkOLSIKCfVNpUjlbWi7qh6c3JHS+VeVhgZZS5c6BfsMUAmbqcpv1hozt6prx2S+q3Gh2+GxKUpbERhf2J6dvQhT4saFz/yczeCjZAxgUd5i4YG7MrtuNKdUAScESzMPGuF/Stj7AjP9uznnF6pbl6kB0oAos/IXpyj+X/3Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Djd3W3bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Djd3W3bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B80C4CEE3;
	Tue, 17 Jun 2025 16:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179345;
	bh=oDRSFhxsjnsNrXGDeDKaDQbcDsPgzqCr2Tx1FpCZo+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Djd3W3bgKCnNnkuWyTnqrpl1S2hU805aIK5TozbMB0vBDs/L8dpW04bj00m1ftYqA
	 ca7N5fdoOMzAf7zxIiQgUGnuO5/W4Mp4DuSz6OUMtE+2KU4KH9puzNrrj2BzoeXk4G
	 0P+CSHrxAyMsW760VndzK/9kD3NGwAsDbBf2UYtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 718/780] net_sched: red: fix a race in __red_change()
Date: Tue, 17 Jun 2025 17:27:06 +0200
Message-ID: <20250617152520.734465277@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 85a3e0ede38450ea3053b8c45d28cf55208409b8 ]

Gerrard Tai reported a race condition in RED, whenever SFQ perturb timer
fires at the wrong time.

The race is as follows:

CPU 0                                 CPU 1
[1]: lock root
[2]: qdisc_tree_flush_backlog()
[3]: unlock root
 |
 |                                    [5]: lock root
 |                                    [6]: rehash
 |                                    [7]: qdisc_tree_reduce_backlog()
 |
[4]: qdisc_put()

This can be abused to underflow a parent's qlen.

Calling qdisc_purge_queue() instead of qdisc_tree_flush_backlog()
should fix the race, because all packets will be purged from the qdisc
before releasing the lock.

Fixes: 0c8d13ac9607 ("net: sched: red: delay destroying child qdisc on replace")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Suggested-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250611111515.1983366-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_red.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 1ba3e0bba54f0..4696c893cf553 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -285,7 +285,7 @@ static int __red_change(struct Qdisc *sch, struct nlattr **tb,
 	q->userbits = userbits;
 	q->limit = ctl->limit;
 	if (child) {
-		qdisc_tree_flush_backlog(q->qdisc);
+		qdisc_purge_queue(q->qdisc);
 		old_child = q->qdisc;
 		q->qdisc = child;
 	}
-- 
2.39.5



