Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BCE1CB33A;
	Tue, 27 Aug 2024 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772373; cv=none; b=qEY6Dz1isYsNONL/fWVWFWo18YPWWpQY7XJqLsTQv65tvxAWZx5GFRRrbwb3rPC4IuwRz1+1MJjW3HdhgAOmUWMYz66WRaMKKVoU/2KPSkAhRMpzj0+Rr8/7r3JdxYE/3BTnPfKevEoVTQFumg2PvRt2yTYqJwerNvBrwKS/zkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772373; c=relaxed/simple;
	bh=eHJy+axbfR07CI2j7j0IGJANcN/TVwAJbxGHj/Q6rqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmCNHi8Xaofo6xSxxbVgyoFBxEbxSWnX8pX4Al/dE5tFu5GJh8IhYu/pIvpdqR9BAFP7BHv1iz2F5/WFO8FhwUI8wSyokO7sfPpNzoACgvVdYmcK8uU23xxS/ap/DOBIfMkIRqBZIq1JOPCWR0r/IyfUXqsUpEtNnO84nYwB3wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGs2jk+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGs2jk+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0378BC4DDEF;
	Tue, 27 Aug 2024 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772373;
	bh=eHJy+axbfR07CI2j7j0IGJANcN/TVwAJbxGHj/Q6rqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGs2jk+YRq0V//kXDbFOeGOfALlQxuGVyRoGHHLbSpc3FiYv3rNxnJtsk15DfQW4g
	 2/Mv0ekJlB8GYAjSnLcHDSmCMLWwuFXzfKSVYBa1MNrNGVSMpJEstd1qUgsvSDYx+7
	 aAA6qwBibkQSQMPlS5fnWPUnHomgVnrwmKxkudus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/321] NFS: avoid infinite loop in pnfs_update_layout.
Date: Tue, 27 Aug 2024 16:38:23 +0200
Message-ID: <20240827143845.653998216@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 2fdbc20036acda9e5694db74a032d3c605323005 ]

If pnfsd_update_layout() is called on a file for which recovery has
failed it will enter a tight infinite loop.

NFS_LAYOUT_INVALID_STID will be set, nfs4_select_rw_stateid() will
return -EIO, and nfs4_schedule_stateid_recovery() will do nothing, so
nfs4_client_recover_expired_lease() will not wait.  So the code will
loop indefinitely.

Break the loop by testing the validity of the open stateid at the top of
the loop.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 4448ff829cbb9..8c1f47ca5dc53 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1997,6 +1997,14 @@ pnfs_update_layout(struct inode *ino,
 	}
 
 lookup_again:
+	if (!nfs4_valid_open_stateid(ctx->state)) {
+		trace_pnfs_update_layout(ino, pos, count,
+					 iomode, lo, lseg,
+					 PNFS_UPDATE_LAYOUT_INVALID_OPEN);
+		lseg = ERR_PTR(-EIO);
+		goto out;
+	}
+
 	lseg = ERR_PTR(nfs4_client_recover_expired_lease(clp));
 	if (IS_ERR(lseg))
 		goto out;
-- 
2.43.0



