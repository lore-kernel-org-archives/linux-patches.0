Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344761C2DB1;
	Tue, 27 Aug 2024 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772772; cv=none; b=nmR9wcp2CHz/Qla4/ChS/A1sdf26jFjbd4lzVo068zF6GvGCovkNV4VsoEUow9g1tE9l7Ra8dD2+LGue1VOa06V2nJSd0zFDfisMTORAaDs9SFPSLgIJOW4HOdZh29lzjpE5pMcLFHCNeTxVhEISZwP9rksBZJAva0Tu9lRTQB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772772; c=relaxed/simple;
	bh=1/01EInRKEJkEUtI2WMk1EsfaUOsOXcOAlu2VmniP4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVDdxJAmNtzWOmtkKI4pdzeiZIDiAcKmLtkNqCmLS2C1ykKH889B+SfWvwoz0r5cRzRGQXEJjTf0CG8l1nwM1NmG4dvcRMMz41p2HRGuCJPK/umWN5EJdlCyjJnqf4QK0gaSx8iTGg4Tlv09L0a7R24MlAMeLEm/BANq1W1I10g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhsVP6Tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhsVP6Tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C8EC61043;
	Tue, 27 Aug 2024 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772772;
	bh=1/01EInRKEJkEUtI2WMk1EsfaUOsOXcOAlu2VmniP4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhsVP6TvJl13BmirTRm7QOOHrH7SWl8poa0ZzBvuUWsav4dfyw3pUJLef6DcjLVDJ
	 P81ThTkYS+lN3eIAIhzP/wNuIo/l0rbcABAAw8tk2LtxbLvgIU1lUvb4ttMBty7nq/
	 czQqv472X7HY9H76xqe/R6WXNy7AF3Oodq9nqp1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.1 315/321] gfs2: Remove freeze_go_demote_ok
Date: Tue, 27 Aug 2024 16:40:23 +0200
Message-ID: <20240827143850.248444333@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andreas Gruenbacher <agruenba@redhat.com>

commit bbacb395ac5c57290cdfd02389788cbce64c237e upstream.

Before commit b77b4a4815a9 ("gfs2: Rework freeze / thaw logic"), the
freeze glock was kept around in the glock cache in shared mode without
being actively held while a filesystem is in thawed state.  In that
state, memory pressure could have eventually evicted the freeze glock,
and the freeze_go_demote_ok callback was needed to prevent that from
happening.

With the freeze / thaw rework, the freeze glock is now always actively
held in shared mode while a filesystem is thawed, and the
freeze_go_demote_ok hack is no longer needed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/glops.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -613,18 +613,6 @@ static int freeze_go_xmote_bh(struct gfs
 }
 
 /**
- * freeze_go_demote_ok
- * @gl: the glock
- *
- * Always returns 0
- */
-
-static int freeze_go_demote_ok(const struct gfs2_glock *gl)
-{
-	return 0;
-}
-
-/**
  * iopen_go_callback - schedule the dcache entry for the inode to be deleted
  * @gl: the glock
  * @remote: true if this came from a different cluster node
@@ -748,7 +736,6 @@ const struct gfs2_glock_operations gfs2_
 
 const struct gfs2_glock_operations gfs2_freeze_glops = {
 	.go_xmote_bh = freeze_go_xmote_bh,
-	.go_demote_ok = freeze_go_demote_ok,
 	.go_callback = freeze_go_callback,
 	.go_type = LM_TYPE_NONDISK,
 	.go_flags = GLOF_NONDISK,


