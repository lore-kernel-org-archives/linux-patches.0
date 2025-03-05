Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65087481DD;
	Wed,  5 Mar 2025 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197335; cv=none; b=NFRsqj0tldWpwOOK2dx+z6h2Ven2EOaHOHhq41peAauRZnt3lNNlm1DBuJ28DmoRFYwhCL5gKNPgR4dTtGUryNh4uqdBeyV0MqKkQSEC9SHviPsQtj+N63U/pxHZRrcmpEdYSkUh+INQ6v/JJRw+pkwDmfZ6R74aW5VAgD+kQ+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197335; c=relaxed/simple;
	bh=y+FTU1VqqOayDWrRQVRQ0OcY9ON4zNJMufF+WDjxpHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaTzIfXNRb1wqvGbCVKg5KsBmqU3Bcro50bo6eTGRVlC7NuLcI7nTbJPQ1wCsPKeQOBFmqV95tZqwveVMNVYoG8N3yBbjl/t277e3CfsQVAxLEEnqOILKs/t5XcdYuXUTBShqX54DWACmT31sDNv5SgiyDbmGbY96yHZrBtv0w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjaqcwWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjaqcwWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC44CC4CED1;
	Wed,  5 Mar 2025 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197335;
	bh=y+FTU1VqqOayDWrRQVRQ0OcY9ON4zNJMufF+WDjxpHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjaqcwWOuOjiEpnh+w80KoMPcGR5MFdQx5y6Mdmv+nDfGZdEdMqJIOdvqVWmEQLtU
	 d0ta63eP/a1jdlIdEHihVB6K6NhlwMg8FNREiQxQ4RExxOwgRgYOKfVzuCQkSOhuRf
	 Vemjo11oZeY7QGIghOTxkIUqG8Dbj/uwv14UduPg=
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
Subject: [PATCH 6.1 120/176] afs: Fix the server_list to unuse a displaced server rather than putting it
Date: Wed,  5 Mar 2025 18:48:09 +0100
Message-ID: <20250305174510.275407552@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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



