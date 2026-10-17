Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8363A1E92;
	Sat, 17 Oct 2026 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258618; cv=none; b=nvT9re8Y9fm837xVzASe/m5AgyhjgQVa69n3uPlKwo4ieYwnCeKXoJhaeDEteZkcRHFtM4ZD26Vm03p1MuSTonuzgyEvIciWJyRz0dKeMCpbwurDusRKQ0InrhzyaPLvgzNlK4mPspIgA4RskvBkzng1s1qv9wisjPvtVPZy/CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258618; c=relaxed/simple;
	bh=10gv/kUuxu0b9UMhhSitbPLYl1rPUHtoJjP5zhIkcfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYVGn1AMktANoeBSAZW9bImPa8NUpeax6jrInheEOtGh8859ARuR3wvKD3bqgVNppXQ6c3TdE22VGv2eTPBxWgo1hoGYHD2r0KiJN6vM7X1kpitiHQI8Us0kq4tDbVUukF+p2MaygNtMBoj47VxE4ZtzqyB300fuds8DFL4wDX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/jb6Z6D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/jb6Z6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC441F000C4;
	Sat, 17 Oct 2026 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258617;
	bh=3ScHFix8/r2Hns6boMDudnv/PESBR/3HdXGJOTcezfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/jb6Z6D+l3wKrDcZIQNmrM8AULrTHDiiAPT8oSPmtjg8f4MH2iB4Fd5AiZUn+ztG
	 oFqeI2NeBbNOOf4lJ5jJ6Zm8JAQdccYvMOeUxu/H1Yaq7aJhNE3hprEA6XpTuDFC1/
	 sl63ZajJkkBpAtPULbE1q1C+XME6xNwaXvqM927c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+046b605f01802054bff0@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0945/1674] gfs2: Fix slab-use-after-free in qd_put
Date: Sat, 17 Oct 2026 17:53:37 +0200
Message-ID: <20261017160455.391489350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index b0cfbcad5ebb6..6794223b01fc1 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -323,6 +323,7 @@ static void qd_put(struct gfs2_quota_data *qd)
 		lockref_mark_dead(&qd->qd_lockref);
 		spin_unlock(&qd->qd_lockref.lock);
 
+		list_lru_del_obj(&gfs2_qd_lru, &qd->qd_lru);
 		gfs2_qd_dispose(qd);
 		return;
 	}
-- 
2.53.0



