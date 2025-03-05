Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C2B2517BC;
	Wed,  5 Mar 2025 18:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198004; cv=none; b=Ln3BcgbwaKmimqB/+NQHgKhcsyx0q4IaHqLsB9kXPowmdONokJMF0VXI12gLPGsyfe5ozBmaCnYdqo+wTogRyCU66lzMn778RU+CXhNeLZGIdl0Id48GjXPOHvcQ52d7l0qhNgeno0VsG8lqn3aBj1lB4gHXMfSMLjYTsRqjbSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198004; c=relaxed/simple;
	bh=ZmsC1R1ms9LcZ88pWw3GDGQG+3qYBN8yDvlaE5SVS1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQKlhwoAgzpfYs46P/CDGYaVaGblhqhA26kyap6rx2V5Xs8tdZGu2t1qvj8NyWeIYWcqMbKzD7I5oEX5KevK91y/24hjNbCZEO06tl7P1TjsV4mXOxbIHesjhWnK/DSNbKfbTsJb4sY+xET2hZh3XzzPM7PGT4GJfAUf6STLhnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yI6sCiaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yI6sCiaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01D5C4CED1;
	Wed,  5 Mar 2025 18:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198004;
	bh=ZmsC1R1ms9LcZ88pWw3GDGQG+3qYBN8yDvlaE5SVS1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yI6sCiaORimHCTNHs0J+igxJsMi4AmFEiRrFbLqE4BluW3XknIuUIfsNIK03V3pge
	 xjR9G9Kn/jB7TUR9LHFct0UX0Nk5G1jgq1rochphZQqI19mp02wMkRgJzO0RpBNjUT
	 zsycdm5sMjXKjwQwVBOGNr7nSYwRrQwHe6+8gqko=
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
Subject: [PATCH 6.12 031/150] afs: Fix the server_list to unuse a displaced server rather than putting it
Date: Wed,  5 Mar 2025 18:47:40 +0100
Message-ID: <20250305174505.065298956@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7e7e567a7f8a2..d20cd902ef949 100644
--- a/fs/afs/server_list.c
+++ b/fs/afs/server_list.c
@@ -97,8 +97,8 @@ struct afs_server_list *afs_alloc_server_list(struct afs_volume *volume,
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



