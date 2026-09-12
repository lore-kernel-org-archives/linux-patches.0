Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3210E367B60;
	Sat, 12 Sep 2026 08:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200734; cv=none; b=bIaeokVU8QNK9Kyd/HIJqjaQtH8GEjofDLR3zQKbGHnFML6a/xGHreivg8vcMLuHjjHm5op/bTLuOZF3+HUY1DjdDWeArw+3qR9GE7tj1DffaaKN8WsxxcrTmRe62DgTMYirYkj2zV4nIRRFm0SN2BeK9Sb2xbsod/lLItERs+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200734; c=relaxed/simple;
	bh=HaY1cd3wPA8M6wjh7ScNg5hD6hz85AqmC30aCw4hUss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvVTMiV4pBZgKIngFRBrY1O0M2eiYSnrFRQlP2vOf+lC3AIcnc/WhbF2jMTm/lyWRpsZZOWl/Are6MeXF1SI9OW9jIoL1rI0xibjRGCkwfCu5Ewv6V6KieE7LjKx39PCypH+myV9GGX8xWsaRyU1c+Z68/3sZoq79gZaCgyIlyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d86Sh35o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d86Sh35o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94A71F000FF;
	Sat, 12 Sep 2026 08:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200732;
	bh=faJPC4nrCvJ8FtMVM0Lqd2DNzYkH7lRTkIwRqzHBMLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d86Sh35oyddmT1rZX1zrG9xqM+pKwr75byBILoTjahFm9roYJ6Oe0ZxJDR6s0pXTN
	 QL5/mhdGHJMLveCxACby7/yszk/oKqNm92gmaOpoAOFdYNVpoKI6pTt4qS+kkw1GD1
	 1kQSD4adihBWuCNfi5NHl/bSvv9nMnHRMuuYtI6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0850/1815] iomap: release the folio batch on iomap callback failures
Date: Sat, 12 Sep 2026 08:43:20 +0200
Message-ID: <20260912065708.873940603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 31e3d833d522746a93d135e8b465d16f8ad33453 ]

A sashiko review of an unrelated patch points out that the folio
batch mechanism used for iomap zero range fails to release the batch
in a couple error scenarios. If either calls to ->iomap_end() or
->iomap_begin() fail, the direct return paths bypass the batch
cleanup.

The ->iomap_end() case is not a practical issue at the moment
because there is no user of the mechanism that returns an error from
this path. The ->iomap_begin() case is theoretically possible
because XFS can invoke the fill helper and error out at various
points thereafter. This subtly complicates things because XFS does
not transfer iomap_flags to the iomap data structure in the error
path.

To deal with both of these issues, first make sure to invoke the
cleanup helper in the error path for either fs callback. Second,
update the helper to clear the flag unconditionally and release the
batch so long as it is populated. This more clearly delineates the
purpose of the flag to control the I/O path and not necessarily the
status of the fbatch, so add a comment around this as well.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Link: https://patch.msgid.link/20260729192737.3190206-2-joannelkoong@gmail.com
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/iter.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e4a29829591a7..63617ec482500 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -6,12 +6,18 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+/*
+ * Release the iter folio batch. Note that the iomap flag is meant to control
+ * the I/O path for the mapping and may not be set in error situations.
+ */
 static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
 {
-	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
+	if (!iter->fbatch)
+		return;
+	iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
+	if (folio_batch_count(iter->fbatch)) {
 		folio_batch_release(iter->fbatch);
 		folio_batch_reinit(iter->fbatch);
-		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
 	}
 }
 
@@ -79,7 +85,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 						  olen),
 				advanced, iter->flags, &iter->iomap);
 		if (ret < 0 && !advanced)
-			return ret;
+			goto error;
 	}
 
 	/* detect old return semantics where this would advance */
@@ -110,7 +116,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
-		return ret;
+		goto error;
 	iomap_iter_done(iter);
 	return 1;
+
+error:
+	iomap_iter_clean_fbatch(iter);
+	return ret;
 }
-- 
2.53.0



