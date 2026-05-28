Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9732341B37D;
	Thu, 28 May 2026 20:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998705; cv=none; b=NZL8ky9TmN9FNgXz3cLusjK/4Kb1LZ+RdTunlICAZtbavrg3NmtRbgG8Biran3tpR3ZYGpI8Ng40tA84hYJS1fqWm/Sk5J72BouiPJIWVq/AZhAlNod40cgFTKNIMzcvAPCeADBmTGCoUUAjoxRr0l4bzZb8twIw91v34sKIWpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998705; c=relaxed/simple;
	bh=WCfEPlAWoK9oGl6XvTVxFb3a0qBYDWN23lnBBxK7uXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnAw1Ykpyl/pDf6qotus6MEVBBGjmzY1LlIR1f1ISgeIkYzc5RwIu1YrkdEUD8Tyo4tjp3C7V9Q0omCA5LAwMAsH6L2sixnfeH6MHcOQEfZv+R6QVlJNn2yg8PQpDp2UrUfiUbE0HInG5bSPfshAFAvWk8paIN+pacuVOotAoW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmKcmQkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmKcmQkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05981F00A3A;
	Thu, 28 May 2026 20:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998704;
	bh=yFHvJvqKVXUFbIbGCSgli6wPNxhhQUdkUH9xIuc6+dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmKcmQkAEGNBdIBqp7E4LcO5Ag+DhbXfJL/1/omODKkR2s39nG+PwaAalNlb/auGx
	 g0Aw777Aj5z9dNVR2pem9niiHCRXYrqMJ1+P2JOR+/cYlXIsQ2bZjN0CIPHKUiJZS6
	 x9tmz19Vk+HJV99VysntZIP2qObGOv+ECJlsYP8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 267/461] netfs: Fix partial invalidation of streaming-write folio
Date: Thu, 28 May 2026 21:46:36 +0200
Message-ID: <20260528194654.895369250@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6d91acc7fb85d33ea58fca9b964a32a453937f4b ]

In netfs_invalidate_folio(), if the region of a partial invalidation
overlaps the front (but not all) of a dirty write cached in a streaming
write page (dirty, but not uptodate, with the dirty region tracked by a
netfs_folio struct), the function modifies the dirty region - but
incorrectly as it moves the region forward by setting the start to the
start, not the end, of the invalidation region.

Fix this by setting finfo->dirty_offset to the end of the invalidation
region (iend).

Fixes: cce6bfa6ca0e ("netfs: Fix trimming of streaming-write folios in netfs_inval_folio()")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-21-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 24b20e80e9a8a..5d554512ed23a 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -262,7 +262,7 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 				goto erase_completely;
 			/* Move the start of the data. */
 			finfo->dirty_len = fend - iend;
-			finfo->dirty_offset = offset;
+			finfo->dirty_offset = iend;
 			trace_netfs_folio(folio, netfs_folio_trace_invalidate_front);
 			return;
 		}
-- 
2.53.0



