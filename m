Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9F1253924;
	Mon, 23 Jun 2025 13:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685321; cv=none; b=YfPBBdQ1VUSxiGCnCHVCWZmHUyWwkomU9/4ye7tw7Sq+dw9jyuJ4Gk9qJxqKJKlpjplQRTK/jr5xXdIWiEEOro4YlaCchKqn0krbutEc/+YA2fUjZrZ76ZuyU6bE/fWiL/0I8a9d1JZG9sfQlaki/9MXpTTBMeXkwaGQQBpBhZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685321; c=relaxed/simple;
	bh=aG28zNqUBQQLhOZTxvrtZlB01S5viv+YMM/ICmXiKvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Efs0Q7gbTIP3MA8d2hr3LZAQk9f6VQyNeNBum58Iyql+5eU987QK+QQqOUxLmZioXTAC/uBVKWajZBmgNK/4v28q7IqJ7ah+5Ev6yOS9b05iaXufloe9eEr36FakZcKZtglmRr/09txhJGr2kJBhqOMSwphsgZwwHcN7JJ3FEYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdHesvAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdHesvAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EC3C4CEEA;
	Mon, 23 Jun 2025 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685321;
	bh=aG28zNqUBQQLhOZTxvrtZlB01S5viv+YMM/ICmXiKvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdHesvAmZyR/rMZYoJPvnCiLam+6yhDl1ZjgojZFW6jUW35XNpGQxOOMqwfRem2VP
	 lAvNVSyzexCQdW3GCFnNGoVvofUhY2yokuXZdmPJGJQkrSxaWBx+P9IAGY9rq3VSrb
	 NLNJuNQEqbroAQMThQj8tv8q7ikvf+DGWTph3Mso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/222] net_sched: tbf: fix a race in tbf_change()
Date: Mon, 23 Jun 2025 15:07:00 +0200
Message-ID: <20250623130614.658584756@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 43eb466041216d25dedaef1c383ad7bd89929cbc ]

Gerrard Tai reported a race condition in TBF, whenever SFQ perturb timer
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

Fixes: b05972f01e7d ("net: sched: tbf: don't call qdisc_put() while holding tree lock")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Suggested-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://patch.msgid.link/20250611111515.1983366-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_tbf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 259a39ca99bfb..9b11e9256336c 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -394,7 +394,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 
 	sch_tree_lock(sch);
 	if (child) {
-		qdisc_tree_flush_backlog(q->qdisc);
+		qdisc_purge_queue(q->qdisc);
 		old = q->qdisc;
 		q->qdisc = child;
 	}
-- 
2.39.5



