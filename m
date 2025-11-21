Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653CF2F5466;
	Fri, 21 Nov 2025 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731471; cv=none; b=oJBJdCz4I/iUbngmy2uPkbwKQLBlVSoMX+eO0LPzfXJKLBUJjellRWl0LxJ1gf3opFZ/HRbBFk6ivGyETVehOTp/ADqd0LRt9UIfKhKuLM1ZBnmF3ebXYxcR5BCss/RjmiA9jY1usvipywpIFaH4KKADzn0aeX/EGm9ajzdVGAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731471; c=relaxed/simple;
	bh=pJBYNJHmo+seYjQIr8KOffy/piK+4zo7XDwrnD7meQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/WI7LT+5xR+pfrIiDMf64fGMvV01swXfPajtTeZlwhvlfoCRYmpSYVRdvcNyrjxMZjxcsnVeLl+35mXmwRPgn8Xlz/28kj3nHNGS/1OR424DFaSuiJdiwU2Kp5gt6wLn3BGaYHqoKfNOvZQfmdjalS/ZR4xeEhuOjBFMKfy+pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iA6NUNoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iA6NUNoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8227C4CEF1;
	Fri, 21 Nov 2025 13:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731471;
	bh=pJBYNJHmo+seYjQIr8KOffy/piK+4zo7XDwrnD7meQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iA6NUNoK8QLlnDfXwvvIwFUldYzruz/4ZmbedyNfwN09smEDtw1AesiDy9pvIgjiV
	 4RZoO9vFh3R+OlWXyKv46mxuyQ8URMrJbgZMMZm6Jv4jumZp22PBIXgM9GtNh12Ksi
	 dUWtc/9dBxhpJlhsNVbib144so8ne3nWv2GkQmTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 218/247] btrfs: release root after error in data_reloc_print_warning_inode()
Date: Fri, 21 Nov 2025 14:12:45 +0100
Message-ID: <20251121130202.557775620@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

commit c367af440e03eba7beb0c9f3fe540f9bcb69134a upstream.

data_reloc_print_warning_inode() calls btrfs_get_fs_root() to obtain
local_root, but fails to release its reference when paths_from_inode()
returns an error. This causes a potential memory leak.

Add a missing btrfs_put_root() call in the error path to properly
decrease the reference count of local_root.

Fixes: b9a9a85059cde ("btrfs: output affected files when relocation fails")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -174,8 +174,10 @@ static int data_reloc_print_warning_inod
 		return ret;
 	}
 	ret = paths_from_inode(inum, ipath);
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * We deliberately ignore the bit ipath might have been too small to


