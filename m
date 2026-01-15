Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DC04C81;
	Thu, 15 Jan 2026 17:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497804; cv=none; b=SUTaM4YZJ6DwV5BERLQa2JW4zxGA09VlXJit0JpJ7119U68OCgLLFbIglmOWVZaqnCbyT1X4QxPvYAyX9Sa5q1c3qDe/iRWbqz58hz4hLQdRuN8+C7JGf97VE7CfdHNiIyWc5Y8tHD5qQS9KNgzWvlULnRkEf9mlwCQcTDgZP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497804; c=relaxed/simple;
	bh=0NAilvdNgoUt6kO3svJ6ir5lHbGu7f4bQ9hUWdSvG+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmWlW2M9u6q9aKUELI+8SK7Mz+z8y53PZm3S2Qj5hGghxGhikDv+hiD8YQ/bhRN2em0/nEGUVoSszvkwOL0ZtNqbtofbEpJTlaY55ovB1zJsNuEVwm16qupY7iaSp4ZhGByYlNS6meG/a3IIWICLjNvebcAKyoUSjAOB644i3hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUg5APX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUg5APX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61D6C19422;
	Thu, 15 Jan 2026 17:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497804;
	bh=0NAilvdNgoUt6kO3svJ6ir5lHbGu7f4bQ9hUWdSvG+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUg5APX7ODe8oJpIWSS1xlnF7qtuEJLffFtXjydcw88aMxKk15iyEe/UKFjQ5A9na
	 1udzSJW7nT4TM0+gjAy0Kh0F7Mzq1O9ccXIPMAqIZfRUkuDxE11VW9BXvkk8yd619c
	 8Q/F0Z3fCrV4i2K1QUawSPGk3z1+E9If9zs0g3dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/554] NFSv4/pNFS: Clear NFS_INO_LAYOUTCOMMIT in pnfs_mark_layout_stateid_invalid
Date: Thu, 15 Jan 2026 17:44:02 +0100
Message-ID: <20260115164252.639517327@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Curley <jcurley@purestorage.com>

[ Upstream commit e0f8058f2cb56de0b7572f51cd563ca5debce746 ]

Fixes a crash when layout is null during this call stack:

write_inode
    -> nfs4_write_inode
        -> pnfs_layoutcommit_inode

pnfs_set_layoutcommit relies on the lseg refcount to keep the layout
around. Need to clear NFS_INO_LAYOUTCOMMIT otherwise we might attempt
to reference a null layout.

Fixes: fe1cf9469d7bc ("pNFS: Clear all layout segment state in pnfs_mark_layout_stateid_invalid")
Signed-off-by: Jonathan Curley <jcurley@purestorage.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index ef273b71f0198..50d608f6c6906 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -465,6 +465,7 @@ pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 	struct pnfs_layout_segment *lseg, *next;
 
 	set_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags);
+	clear_bit(NFS_INO_LAYOUTCOMMIT, &NFS_I(lo->plh_inode)->flags);
 	list_for_each_entry_safe(lseg, next, &lo->plh_segs, pls_list)
 		pnfs_clear_lseg_state(lseg, lseg_list);
 	pnfs_clear_layoutreturn_info(lo);
-- 
2.51.0



