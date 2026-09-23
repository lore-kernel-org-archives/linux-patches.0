Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EA253C3A5;
	Wed, 23 Sep 2026 14:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174826; cv=none; b=Qs661ZrSpQqchJ3LBhQyn/HDuZ/BDiHSyEbrMcqhUFFyhQ4wHu2rywuIfwLU5ENCFkFbpWkhS4eAm6apMfibLNAO/mMMvLvLmP2Ot1+Zb+rZCVCPoqWJAKUeoIEYecMDWugK5RFfyDcm93TDE7AP7velhloj7p8OB6sbBv+UQJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174826; c=relaxed/simple;
	bh=ZSIIdCRiMOAeFxwOPmpYIMnFANYlPvFk3/ueDDSbeAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avz+2CobBzR8NYYqXL6bTv3lemhfihPWnmPO0UKVOnOwYOOUiaa77A0j91Wl/1SAIp/XrJKZhoXtGm2MDgziS7X+BRAcwryY4bXjKqeIxRne9khjNQJrx7SVtLJdCe8vpf4NcYS+g8ZMoyeXqO+UmjrnjI9EiABYhtC0WN6hP+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VShWVUd7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VShWVUd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EDC1F000FF;
	Wed, 23 Sep 2026 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174825;
	bh=WUSJHt7GG18b/VsjLJUkrkEqyiKyqtnnA00UygXnPZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VShWVUd7ZWR8Oeb2LMospkpCmMuEbNXkKcbQR6HEZJ1U0YATUn8Ii2QY8TGtVKHUC
	 YNB1tlJQw+x0B43HotT9ykAo/xeG6oowQjFCAZMbTK7093+6BTObmgGh0u65Egj6kt
	 qg+YvSSswY4QBrC9bAWfYSpzO2aGsJNdNunMuioE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.18 237/398] btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()
Date: Wed, 23 Sep 2026 16:05:11 +0200
Message-ID: <20260923140649.560394353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

commit 0594e3423f4ba3137c734371169491f9a98e9af4 upstream.

mark_block_group_to_copy() iterates over the commit root with
skip_locking=true. A concurrent transaction commit can swap and free
the commit root during iteration, causing use-after-free when
accessing extent buffers.

Fix it by using path->need_commit_sem to protect the commit root search.

Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
CC: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dev-replace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -491,6 +491,7 @@ static int mark_block_group_to_copy(stru
 	path->reada = READA_FORWARD;
 	path->search_commit_root = true;
 	path->skip_locking = true;
+	path->need_commit_sem = true;
 
 	key.objectid = src_dev->devid;
 	key.type = BTRFS_DEV_EXTENT_KEY;


