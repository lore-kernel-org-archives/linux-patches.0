Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74223E49C7;
	Tue, 21 Jul 2026 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653612; cv=none; b=Ki20r/lv+lp5uWH0XxEWQ13K8aMsfab+bTvruOo9Cxrjz54vlvY8GJc7JBqApsUqEvzoTWxM2JgwXLxUCZUIRCoy36/4NYFJK3TEBUOR3+XZz2/qPzd5LNvaoicNcS/OHPgc6NnNx4yDB2wdejXyeI/3ShDRB9bzyNTevlj3OxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653612; c=relaxed/simple;
	bh=YjK3jdh1zskuv6cFNFBzyM4Xdw1pohkb2J/dD/S6BlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT4KAlOgi7c64uJPIHAA1VlGTjQUQpDaA779q7d6/0crr1x9Y9sr6vXpxpFwr2OAWWFtmOrGU7sEAPuQhSoB5514SKsN6AjhvGEkyQee2FbfnAUXERjUZ++Qf7zbD6zxCFiZjz+/MxkDvbYa+CWf5UQQQ7cxZqvCGFVfKcwRJeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkVgpjhk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkVgpjhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DFD1F000E9;
	Tue, 21 Jul 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653610;
	bh=1H6ZCyMLxCcLVaLs3rR5EsZRP0gZ4PiYGyDmPfLxvJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xkVgpjhkLw6DGiMS+w+sC0T5b9PPlHp2JVUr6Yi/Oi1hfARcIzXEWGCLXJyZbFfNh
	 5iBxZsCC14MzyVwQk0WR5VBQK6/gpf/asjTUeTuCMafv/DVDnyq4W4/1Bj1QAZ6/9u
	 KHyCxwvoV1acpWON5vFK8+zOiv8LjibVgCGbXx1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1393/2077] netfs: Fix netfs_create_write_req() to handle async cache object creation
Date: Tue, 21 Jul 2026 17:17:46 +0200
Message-ID: <20260721152625.669618181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit dbd6f56d975b23241b7bbb11bb8f562af548a0aa ]

netfs_create_write_req() will skip caching if the fscache cookie is
disabled, but this is a problem because async cache object creation might
not have got far enough yet that has been enabled - thereby causing the
call to fscache_begin_write_operation() to be skipped.

Fix this by removing the checks on the cookie and delegating this to
fscache_begin_write_operation().

Fixes: 7b589a9b45ae ("netfs: Fix handling of USE_PGPRIV2 and WRITE_TO_CACHE flags")
Closes: https://sashiko.dev/#/patchset/20260624115737.2964520-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-3-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index c03c7cc45e4716..4f55228f0fd497 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -106,7 +106,7 @@ struct netfs_io_request *netfs_create_write_req(struct address_space *mapping,
 	_enter("R=%x", wreq->debug_id);
 
 	ictx = netfs_inode(wreq->inode);
-	if (is_cacheable && netfs_is_cache_enabled(ictx))
+	if (is_cacheable)
 		fscache_begin_write_operation(&wreq->cache_resources, netfs_i_cookie(ictx));
 	if (rolling_buffer_init(&wreq->buffer, wreq->debug_id, ITER_SOURCE) < 0)
 		goto nomem;
-- 
2.53.0



