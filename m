Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE4B359FAD;
	Fri,  9 Jan 2026 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960036; cv=none; b=M6XaiC2LqzZJh772/R3tqi/lcckFzvbeVfZVshqmPsuv8aYqzESS5NjdQY0YV+FEOnI0Rz+oHs5EWlYYyZZDSkXNg+SkMcSR8F9u25hMCFBiR/XBhVFxyi428EXxludaI6BiTqTTUxodqiP08jIjBBQ0UrTw+/xwQesNStQ02DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960036; c=relaxed/simple;
	bh=ctrJoTyIAumbzjwpUPkL2LBBzPWfv8lNhVf07uI79JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIroDupd9UBVyd846lqhXkFKdQMoQ3JtrQqhnmdt2VZxYCXP+c8q74yZZv212h4xIJ6yr3x/2CbAJmu73T5LftjgRPvSQTySdRiqS0+RAmdWi2CwCJKgJXdbaOxARbvAzHSe9erDwETA8R/4pD4bu3FTaiHcFsjAHY5srt7XRRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJSlz80b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJSlz80b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAA4C4CEF1;
	Fri,  9 Jan 2026 12:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960035;
	bh=ctrJoTyIAumbzjwpUPkL2LBBzPWfv8lNhVf07uI79JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJSlz80br6kBcLxO36J0nT2wxlgG/MV8XcgwPGuNNUrcUnAC1/VbJFZoNiKuZNnXg
	 rJMNNOyDncsNvyjd+65wZkqcQCxdGtcpMN7hNf7FFLE3XkFJAozqmWly7bQIjZmOQV
	 AEpAe7IxuX8e/99OozBz0XTC+0a+V1cx+u4QEoRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/737] NFSv4/pNFS: Clear NFS_INO_LAYOUTCOMMIT in pnfs_mark_layout_stateid_invalid
Date: Fri,  9 Jan 2026 12:36:42 +0100
Message-ID: <20260109112143.884875804@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b40c20bd364b0..0737d9a15d862 100644
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



