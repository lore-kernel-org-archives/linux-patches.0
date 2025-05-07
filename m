Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C681A29A;
	Wed,  7 May 2025 18:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643659; cv=none; b=diDAqR3TPQ7jobL6RFc2AbJ/YyYzVwWhAtvp3nxA/g3auTIbZSscHPb/jr27RDTF+hQxCxkCX3UNGFkGR7s/cpHe1SZE4t65rcQlZd3iSIDmATX+HqyccHRas+lTxZ0MeWT/AsUv+yvMezlzmyMHct8p+Z8yfnZv0hFQLxVDOmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643659; c=relaxed/simple;
	bh=Ml1Ls26j149o3cUDH0iPT0Ma6byKBnqz0AqndwPC5pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvgltKdhzt8afyzm5iobDPuwb6s7kpo6zRQuPEn9KY6NpushXsUNCJCH/KXgfVkZ2+P0ejRMQQv/LYGrak+TpFyRbbWpLNyctFK8YbHqM136Tzt7YLvCgxJ1JsyW6L+J8RzYhfFzZ2IiDs/jE+E4zR/d/4Cbi+EVWJxLamfbcnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROLeBE7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROLeBE7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53149C4CEE2;
	Wed,  7 May 2025 18:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643659;
	bh=Ml1Ls26j149o3cUDH0iPT0Ma6byKBnqz0AqndwPC5pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROLeBE7JrOr8KH+WtK5FmhIjip9hWyKb4uNqrx4+lW2gC0bbYZYFvhl1NEj3qQxVi
	 jRgAhZe0iaFDnurI3HIA8XLmr8Jf1jZl1LLSlHBpmj5tcBUpBvtdMk6Kv84nPEqu1l
	 VS+st+lJMaijbqhPHqQvfd3UjGvmWo+tCK96CRcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 74/97] sch_htb: make htb_qlen_notify() idempotent
Date: Wed,  7 May 2025 20:39:49 +0200
Message-ID: <20250507183809.966745014@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 5ba8b837b522d7051ef81bacf3d95383ff8edce5 upstream.

htb_qlen_notify() always deactivates the HTB class and in fact could
trigger a warning if it is already deactivated. Therefore, it is not
idempotent and not friendly to its callers, like fq_codel_dequeue().

Let's make it idempotent to ease qdisc_tree_reduce_backlog() callers'
life.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-2-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_htb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1482,6 +1482,8 @@ static void htb_qlen_notify(struct Qdisc
 {
 	struct htb_class *cl = (struct htb_class *)arg;
 
+	if (!cl->prio_activity)
+		return;
 	htb_deactivate(qdisc_priv(sch), cl);
 }
 


