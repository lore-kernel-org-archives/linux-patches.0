Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4876F471248;
	Tue, 21 Jul 2026 18:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658112; cv=none; b=Iu+3fQt7ZBLsS4ILRz90HnYHKe8mE+rEnmf/XZQ/vuRIehp4t8B6qroU47S1FgFW6tfXcD2U+hga2oA/CFoXrAImf4iE4vYkXXPBOQl9S0arY5laoJei/FZRU53IBr5LMpLt7dpi+y6qAJPmxKZFmjTtsAhfGgbiAMV2XEFPDaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658112; c=relaxed/simple;
	bh=Q2MfkRiHPG8bu09+FVLaS7osnc7dWXrHA6nGERDXZ2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOw9Ke4sSK0LuRb2+7rUIf1QVxBnBoq+qBK1ivWkooNgUcpvSwmV5Yly1AluvW2fUBKenG/VnYHFCgPJCozVbzP75B4qXIXACufxy0oYxi+4R2kMBNuVBaPYzD8Eutc9TyHO+4kjUacAhk5nPPEQ/vJ2kaBkXfJb0SVMqm10QTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqTf0z/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqTf0z/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DCC1F000E9;
	Tue, 21 Jul 2026 18:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658111;
	bh=wxkU6WBYg5FX2maNZzJh0OM1VDrr+3v+GMm1z4kmhP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqTf0z/kQinPVcDXOk8Bli5X+v5VYB7MzMT0Kns59PDoisUeWsC78CXqP4JdYKULp
	 MTF6HZnxtPxYDGOQVWFqKiMK4X96cmgBHDL44hW85TDTR8FpV1uDht3xAMdzdj60vW
	 g72BNpQcPoTCV8AIOkO+lPxzYZaPjfTSaNSBr4uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1018/1611] netfs: Fix writeback error handling
Date: Tue, 21 Jul 2026 17:18:54 +0200
Message-ID: <20260721152538.290981675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit ac5f95ac5d6d0f4c567b8b642825705a2bf0d79e ]

Fix the error handling in writeback_iter() loop.  If an error occurs,
writeback_iter() needs to be called again with *error set to the error so
that it can clean up iteration state.  Further, the current folio needs
unlocking and redirtying.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Link: https://sashiko.dev/#/patchset/20260619140646.2633762-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-14-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 79b4085590fdb8..08bcdd0a871246 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -587,8 +587,6 @@ int netfs_writepages(struct address_space *mapping,
 		}
 
 		error = netfs_write_folio(wreq, wbc, folio);
-		if (error < 0)
-			break;
 	} while ((folio = writeback_iter(mapping, wbc, folio, &error)));
 
 	netfs_end_issue_write(wreq);
@@ -601,7 +599,14 @@ int netfs_writepages(struct address_space *mapping,
 	return error;
 
 couldnt_start:
-	netfs_kill_dirty_pages(mapping, wbc, folio);
+	if (error == -ENOMEM) {
+		folio_redirty_for_writepage(wbc, folio);
+		folio_unlock(folio);
+		folio = writeback_iter(mapping, wbc, folio, &error);
+		WARN_ON_ONCE(folio != NULL);
+	} else {
+		netfs_kill_dirty_pages(mapping, wbc, folio);
+	}
 out:
 	mutex_unlock(&ictx->wb_lock);
 	_leave(" = %d", error);
-- 
2.53.0



