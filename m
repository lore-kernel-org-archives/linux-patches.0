Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7696B14B075;
	Wed,  5 Mar 2025 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197560; cv=none; b=T3UZNGd5YVEtbP/Q/Qf92DISU1LPpWn5pHiPuf1UmVxNEoLIIxr8R1SjTtPaOkJMbIskNWuDoHpmRmF98u8K9p5AC60x1toGahDXWLIXovXybgC+JudLiP8InkJwj2d9bdH+c5R/rzAyQeLVXTNTmhIdpJ75GZsZJYrBqLM0vt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197560; c=relaxed/simple;
	bh=885Uvb7lH9Ma8JLLyNK7V2u2PmWKfPgBMt0+XJhlaBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/p7UuEmsaEn2WVeR6HOX2bS72Gv4gh/gRV4nHaJ6TeLm2EVeOJ9EuFe0qnRlQdFGUYwDlVUKuCILv/4ytA06FrTBoT7XWzgyWAgyqOND2dl/XSEXVljrZyKjuApAxv5hP9tFIlbjdyzfzcMqxaMmEtz0W/CJsW4um8zEpigPws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxAAWePC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxAAWePC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A86C4CED1;
	Wed,  5 Mar 2025 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197560;
	bh=885Uvb7lH9Ma8JLLyNK7V2u2PmWKfPgBMt0+XJhlaBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxAAWePCK0uBNXkcubDVX9DCY2LzfWoYB3kIne1wVDh58HvadsHDKoyNccZHSPNS/
	 weaPccue9Y4JWDhnsmxG6Ak+01a3r2rI0z7qL+7NiU0+8ltd36uig5AKdlkHFDYDzF
	 BflLH3LCTbzlIHePAupu1oZTFhkQ6s3PXdYju8To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/142] afs: Fix the server_list to unuse a displaced server rather than putting it
Date: Wed,  5 Mar 2025 18:47:20 +0100
Message-ID: <20250305174501.193948238@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit add117e48df4788a86a21bd0515833c0a6db1ad1 ]

When allocating and building an afs_server_list struct object from a VLDB
record, we look up each server address to get the server record for it -
but a server may have more than one entry in the record and we discard the
duplicate pointers.  Currently, however, when we discard, we only put a
server record, not unuse it - but the lookup got as an active-user count.

The active-user count on an afs_server_list object determines its lifetime
whereas the refcount keeps the memory backing it around.  Failing to reduce
the active-user counter prevents the record from being cleaned up and can
lead to multiple copied being seen - and pointing to deleted afs_cell
objects and other such things.

Fix this by switching the incorrect 'put' to an 'unuse' instead.

Without this, occasionally, a dead server record can be seen in
/proc/net/afs/servers and list corruption may be observed:

    list_del corruption. prev->next should be ffff888102423e40, but was 0000000000000000. (prev=ffff88810140cd38)

Fixes: 977e5f8ed0ab ("afs: Split the usage count on struct afs_server")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250218192250.296870-5-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/server_list.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/server_list.c b/fs/afs/server_list.c
index 4d6369477f54e..89c75d934f79e 100644
--- a/fs/afs/server_list.c
+++ b/fs/afs/server_list.c
@@ -67,8 +67,8 @@ struct afs_server_list *afs_alloc_server_list(struct afs_volume *volume,
 				break;
 		if (j < slist->nr_servers) {
 			if (slist->servers[j].server == server) {
-				afs_put_server(volume->cell->net, server,
-					       afs_server_trace_put_slist_isort);
+				afs_unuse_server(volume->cell->net, server,
+						 afs_server_trace_put_slist_isort);
 				continue;
 			}
 
-- 
2.39.5



