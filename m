Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4367714A4C7;
	Wed,  7 May 2025 18:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643330; cv=none; b=L76gAsuyrUxwVt/ET6ol3UbpgD/npcl9tmFsS+dOxo/tgEtWnD5w6xAqx+oYxta3V1xaTqteRqcSjxD0IW3/03AngqLExbpgRHTDA1nohwz+6AzreUpHB3l8OEs/4QoJl8PO1+4GuureLdBVNLOWhZhA5FdMyKHRXT5G6ggytaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643330; c=relaxed/simple;
	bh=w7JHTz5UQAP2ILkAnSBv9saO77GCZ4BWAacaM5aHgGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgvxSYyrFFmzgzVx7CZ7vDkupBkMl4kHWa6DGFSqsPP6nCEvkgU0CbvQK4WARc78m1NsN/45FnMJbe8aIEXVVdymaLBk6S6vxA5Qeh8xWxMh37k+RaRwixHfLSJMzeQiNXiwYcj49goWgVkkm8wZNpk4JJR5R1IFsMjweu8XrEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRaecKNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRaecKNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62184C4CEE2;
	Wed,  7 May 2025 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643329;
	bh=w7JHTz5UQAP2ILkAnSBv9saO77GCZ4BWAacaM5aHgGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRaecKNXQfxLX+IlpsvNQ6Cvwr62W1j8fAyoPsfaHjR1rvAogOztGJjHeDOzo9jq6
	 VHg27o28lzgty29orYj+CZg7E30/6ZQwDmkkAVdo0tse7WftSIjOyy/cpHZPg7TbaJ
	 TM8s5TLr5LkjInCv5T5K4yM+XCSWIeT+ly+ovqgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/55] net_sched: drr: Fix double list add in class with netem as child qdisc
Date: Wed,  7 May 2025 20:39:24 +0200
Message-ID: <20250507183759.975180461@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit f99a3fbf023e20b626be4b0f042463d598050c9a ]

As described in Gerrard's report [1], there are use cases where a netem
child qdisc will make the parent qdisc's enqueue callback reentrant.
In the case of drr, there won't be a UAF, but the code will add the same
classifier to the list twice, which will cause memory corruption.

In addition to checking for qlen being zero, this patch checks whether the
class was already added to the active_list (cl_is_active) before adding
to the list to cover for the reentrant case.

[1] https://lore.kernel.org/netdev/CAHcdcOm+03OD2j6R0=YHKqmy=VgJ8xEOKuP6c7mSgnp-TEJJbw@mail.gmail.com/

Fixes: 37d9cf1a3ce3 ("sched: Fix detection of empty queues in child qdiscs")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20250425220710.3964791-2-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_drr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 80a88e208d2bc..e33a72c356c87 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -36,6 +36,11 @@ struct drr_sched {
 	struct Qdisc_class_hash		clhash;
 };
 
+static bool cl_is_active(struct drr_class *cl)
+{
+	return !list_empty(&cl->alist);
+}
+
 static struct drr_class *drr_find_class(struct Qdisc *sch, u32 classid)
 {
 	struct drr_sched *q = qdisc_priv(sch);
@@ -345,7 +350,6 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct drr_sched *q = qdisc_priv(sch);
 	struct drr_class *cl;
 	int err = 0;
-	bool first;
 
 	cl = drr_classify(skb, sch, &err);
 	if (cl == NULL) {
@@ -355,7 +359,6 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return err;
 	}
 
-	first = !cl->qdisc->q.qlen;
 	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		if (net_xmit_drop_count(err)) {
@@ -365,7 +368,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return err;
 	}
 
-	if (first) {
+	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
 		cl->deficit = cl->quantum;
 	}
-- 
2.39.5



