Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C13B26056D;
	Wed, 25 Feb 2026 01:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983716; cv=none; b=mwAIB2wIty+tWE+ETOdIAj9KQ+4pqjfN2dVCt93NhApyY65ZVbpJ4zZkjZnbclqkQ35wFyqJYyJGW87fjlshRwWDqfSc854I5AHp2wZw/GLpsn6dBqEyWKlEvK3d427k4k1hi27FR/GABOYfwMgaBbrr2lDyzp+Zvgz3k6seTsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983716; c=relaxed/simple;
	bh=YkIxeVoaJOEz5cQLgzwdxhhbc3o67Fk6p8dNWSQ0GPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=is3ISRfXpkmMtpTYPRzAs17Vkr9QSSUBI8lm13dZExbwmUFBGKNFJ3JTLAd4TytLXfiwtXazV/MqbArQMz1ZM6B4zG8tHpYZdKuQXNnQA9h7R038v0KDPf39M9wLYcgn0KmaJCHnuc9WrGobNlFYhYnxWkEqqU/JP6Df+vLdS+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1kGWcGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1kGWcGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF03EC116D0;
	Wed, 25 Feb 2026 01:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983716;
	bh=YkIxeVoaJOEz5cQLgzwdxhhbc3o67Fk6p8dNWSQ0GPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1kGWcGuaebj85YKORMmzCMH5HWe5TSV0HY8wELVXWcT5REllQg5qrr1Ap20aafy/
	 1vTR3iQ+aODZMKSIAHwmC80Bw7PUM1Al7Fv4JepYr/CByc4z5rYIVQJaz6vOOvIy6a
	 8pRfTSWgwwo1rXD8kqtpk/o/Od6bF04FGSyJC29w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+046b605f01802054bff0@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/641] gfs2: Fix slab-use-after-free in qd_put
Date: Tue, 24 Feb 2026 17:15:40 -0800
Message-ID: <20260225012349.300389769@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index f2df01f801b81..898fc3937b449 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -334,6 +334,7 @@ static void qd_put(struct gfs2_quota_data *qd)
 		lockref_mark_dead(&qd->qd_lockref);
 		spin_unlock(&qd->qd_lockref.lock);
 
+		list_lru_del_obj(&gfs2_qd_lru, &qd->qd_lru);
 		gfs2_qd_dispose(qd);
 		return;
 	}
-- 
2.51.0



