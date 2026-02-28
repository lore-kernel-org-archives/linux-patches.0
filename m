Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C07D375AAA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301623; cv=none; b=fpitgF0lVvbHVsyjvvoAS8NsDkMILqmJ2nCgPzZ3Rv8XgCJzDFwYPV4QPOavL6Q9SAh1VpOG36HHaWzOZlsBB/RxaVbp/gGDDEzqL6q6ryUaj98ScXX4N1w2ZIXH6Se+M4CIt/3BmtNSkYMyM/XTVebhLjwgioJexYhG/ltpwVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301623; c=relaxed/simple;
	bh=IKVNHAYlv58XXhQeXuXKipN7akEU7lfWU3ELgmFMWkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpIDd3VCdR8odgzr/4xzpj0K+fHWp2G4QKhXBdXRCWj+BKWmbltQFvi3Ap9m+k1sVPa5wgoYooDCqAiCaRhOQfwtpcArxZi/CMJ3KltlgtvJ7dizeuP2iEB0ZAerV1ee/K8mlprqOeO6rswPvxDZbF7ld5JEQ2danmdMf90ISaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGf3INfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGf3INfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47761C19424;
	Sat, 28 Feb 2026 18:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301622;
	bh=IKVNHAYlv58XXhQeXuXKipN7akEU7lfWU3ELgmFMWkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGf3INfT0q/V6jyxoQ6FLA1F+weMro6UDTlp7nGg33bjHWXf4r41KTM6D0ZAv/mPC
	 GTiMcRX3G+Cx9Lz8HOg6IdjvVV8Z/RSNYMwMKIwAPQL7GgeXIe8kVSwfhIMvaOg1+R
	 RjMhXmEutdEdFnFfZSmZ9fOuTOQmBBtFJLfIOMabkYQoIGd8EAZUZSTw5cI3XgzNGH
	 AN3x7okgJHskIgfyfCUUXhN5NiCox36nzSww2PyaLwWzMknhW2SJQD1yDcy6y1Lq0I
	 8a8KfyKkP4vXKvq357tkRwHYzXCPdy2bnpDjIbT1j1xmqyp1rpvhHniuUJfUpYr3is
	 mjMrq+YWBtu0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	syzbot+046b605f01802054bff0@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/385] gfs2: Fix slab-use-after-free in qd_put
Date: Sat, 28 Feb 2026 12:53:55 -0500
Message-ID: <20260228180011.1568201-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 22150a7d401d9e9169b9b68e05bed95f7f49bf69 ]

Commit a475c5dd16e5 ("gfs2: Free quota data objects synchronously")
started freeing quota data objects during filesystem shutdown instead of
putting them back onto the LRU list, but it failed to remove these
objects from the LRU list, causing LRU list corruption.  This caused
use-after-free when the shrinker (gfs2_qd_shrink_scan) tried to access
already-freed objects on the LRU list.

Fix this by removing qd objects from the LRU list before freeing them in
qd_put().

Initial fix from Deepanshu Kartikey <kartikey406@gmail.com>.

Fixes: a475c5dd16e5 ("gfs2: Free quota data objects synchronously")
Reported-by: syzbot+046b605f01802054bff0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=046b605f01802054bff0
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 642584265a6f4..95b20e6a3fbc6 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -336,6 +336,7 @@ static void qd_put(struct gfs2_quota_data *qd)
 		lockref_mark_dead(&qd->qd_lockref);
 		spin_unlock(&qd->qd_lockref.lock);
 
+		list_lru_del_obj(&gfs2_qd_lru, &qd->qd_lru);
 		gfs2_qd_dispose(qd);
 		return;
 	}
-- 
2.51.0

