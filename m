Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55895330657;
	Mon, 29 Dec 2025 16:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024948; cv=none; b=A/Zu5uqZSg91aYIQPmjBWwBfS3OgStUp+Aj6wo3FXph71v+GHxEd0XM5i8S/AYc9IUZ9wUWbBpBkwH8qgN93Hcc9Fb/YnN7aRrYI+6Zk7Wq1SSThPVtJQFYImSN9v7c9glTy3SUz4XrKdRYsPoVWR+vvp1T2NuZFrdOigSZGYhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024948; c=relaxed/simple;
	bh=EtVAcF0b7PGDYclNNu4Rq2Ns5M5zPUMAUulDvSVNRLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZobVXyUWNMg7jP0bJi6YtTEyVSWof3K/TFWs39SRU0O2MnKlKF4VeXDA5cWUBZLmMaX+0ilTj7yjBg6gtfK+M2oeCT5OeP9W8xKbfpHdYdtBNzaVfvWHu7v/idWXymlu6F+EqRoGZyeBORdloDeqrVF/6Byosrust6GeJJUtvKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0Qwch8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0Qwch8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A72C4CEF7;
	Mon, 29 Dec 2025 16:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024948;
	bh=EtVAcF0b7PGDYclNNu4Rq2Ns5M5zPUMAUulDvSVNRLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0Qwch8cZx3dwPhm3WF7r3zC7C+xueEYgoXqBbzzWa6g2l4eo6H6VgykUO22lIKvu
	 5D0WuYbyqTXXi4Z6HXZEQAlNe+Sz9EJz6deSywrm2ZdaS5AILaf9Athee7IVY2BlPd
	 X7tNB9tf5BCDyAkvFpte36A1U3jRs8bwNqRcLXAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/430] gfs2: fix remote evict for read-only filesystems
Date: Mon, 29 Dec 2025 17:07:23 +0100
Message-ID: <20251229160725.878452812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 64c10ed9274bc46416f502afea48b4ae11279669 ]

When a node tries to delete an inode, it first requests exclusive access
to the iopen glock.  This triggers demote requests on all remote nodes
currently holding the iopen glock.  To satisfy those requests, the
remote nodes evict the inode in question, or they poke the corresponding
inode glock to signal that the inode is still in active use.

This behavior doesn't depend on whether or not a filesystem is
read-only, so remove the incorrect read-only check.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 0c0a80b3bacab..0c68ab4432b08 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -630,8 +630,7 @@ static void iopen_go_callback(struct gfs2_glock *gl, bool remote)
 	struct gfs2_inode *ip = gl->gl_object;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
-	if (!remote || sb_rdonly(sdp->sd_vfs) ||
-	    test_bit(SDF_KILL, &sdp->sd_flags))
+	if (!remote || test_bit(SDF_KILL, &sdp->sd_flags))
 		return;
 
 	if (gl->gl_demote_state == LM_ST_UNLOCKED &&
-- 
2.51.0



