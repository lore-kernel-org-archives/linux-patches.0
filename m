Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EB144AB71;
	Tue, 21 Jul 2026 21:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669752; cv=none; b=OFXU3e6Sx8yf5SxLiIrQR7QCCuPH29CBah/f0dHVySpxt6YuMwOjPNQCm463AC1vzcK3djY4oNfG/0oBKcb9/+NE13SHhRp8xgics5Xmgernp9xLjewMCmTimvShxF9pR/rChtAdRMfqjHmHpRQfqADbIxyCfikRPzTVCRgEdwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669752; c=relaxed/simple;
	bh=MwpsehAnwD7XUgvAW27TCyk+P+WFz4jP4jwF6wzknyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuRWq6XjXIJPo7sHMtiV8YCu0OKoE1J++n+wLCtRl48b2RBUYO8K9nCPKyn4RyW+iuBDvkvX3/E5zRNcT7j/Vs5yBKndi+WL/+Tw2MIeLTTfrzkqCICfAbhTXsUVXbarZXlY1yORlD2kxmNfiooC4FoSNMUTxA6QXWFzzdkC4iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mv2d5/dp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mv2d5/dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EFE1F00A3A;
	Tue, 21 Jul 2026 21:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669751;
	bh=ivwnlIuj7QvJex5PCmO0VUuCGvdq9Rq9oIaetHxHXxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mv2d5/dp/mvkdmjcMvuRqbDTWrGLBrh//GlAAOaP0l64fC6dvLxrWTZDlKfIiAYY4
	 S2fR3bxEQCeB93ibp9mZ2DHJRCDsPJKmY7q1403urRQkqozJkaFP4p73osZZU8lzNm
	 TI57HHlivLQU6oDcfYB29Vt8xPQLIzzeRqaWlSGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0673/1067] afs: Fix vllist leak
Date: Tue, 21 Jul 2026 17:21:14 +0200
Message-ID: <20260721152439.650819799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit fc10c0ecf06f2981af5d04357612b00051e03e9e ]

Fix a leak of the new vllist in afs_update_cell() in the event that it is an
empty list (nr_servers == 0), in which case the old list isn't displaced
unless the old list is also empty.

Fixes: d5c32c89b208 ("afs: Fix cell DNS lookup")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-18-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 7c0dce8eecadd1..93f695936fefca 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -474,6 +474,8 @@ static int afs_update_cell(struct afs_cell *cell)
 		rcu_assign_pointer(cell->vl_servers, vllist);
 		cell->dns_source = vllist->source;
 		old = p;
+	} else {
+		old = vllist;
 	}
 	write_unlock(&cell->vl_servers_lock);
 	afs_put_vlserverlist(cell->net, old);
-- 
2.53.0



