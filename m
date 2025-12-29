Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEF931B111;
	Mon, 29 Dec 2025 16:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024889; cv=none; b=VF69GC7DdRQTkx1DUYhM+OJMK/vxHR3EVTo/BuWsIU3u+9GzkwL13dWKmDx/vH49LpuvKASfmOVZ9SWT08ymxGMBtYKSj+Sg0q+80leptwMbxzDR+ve3hh9tK4iu9yG/lZlZQ1GuB01fZLKHIu+vnknPbyMv+E0IV+eI5sRMsys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024889; c=relaxed/simple;
	bh=kXlEgGIe5wbeNPLuixyM8IC92fg7QcVRFnogiqH5JZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH+80URWCIh83fWv+JSmFNWRUBa+oIcN4pcFE3+7MLqtiVJgGD/XkMHgexBMsKdHus1mhF6SbficK9Ye/HnLXoWSddesqwskFargST2bmwPN+V8pcWyLeD+RqNowUHPwjbBC326Fb5gz+VnK8X2gBzCnec9GZXoSteXDP5BlUKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6EZvJBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6EZvJBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54D3C4CEF7;
	Mon, 29 Dec 2025 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024888;
	bh=kXlEgGIe5wbeNPLuixyM8IC92fg7QcVRFnogiqH5JZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6EZvJBxwIMNVJTuBbd305uLvREV9BjYr/qV5BrzYEhGtMKGRlm9SAPLyB2fZ8pNb
	 7Zdw/8Qo+T0XeYgndBKGqvr//QCft/IB6Cb+ZUCjtT6xYRuE//X20USIL01yEtrKyo
	 KtRxwfzITi/K5XtDpxXkjtwZvFb4lSMbgYY7hG0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/430] btrfs: fix a potential path leak in print_data_reloc_error()
Date: Mon, 29 Dec 2025 17:06:44 +0100
Message-ID: <20251229160724.236586898@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 313ef70a9f0f637a09d9ef45222f5bdcf30a354b ]

Inside print_data_reloc_error(), if extent_from_logical() failed we
return immediately.

However there are the following cases where extent_from_logical() can
return error but still holds a path:

- btrfs_search_slot() returned 0

- No backref item found in extent tree

- No flags_ret provided
  This is not possible in this call site though.

So for the above two cases, we can return without releasing the path,
causing extent buffer leaks.

Fixes: b9a9a85059cd ("btrfs: output affected files when relocation fails")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6282911e536f0..51401d586a7b6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -256,6 +256,7 @@ static void print_data_reloc_error(const struct btrfs_inode *inode, u64 file_off
 	if (ret < 0) {
 		btrfs_err_rl(fs_info, "failed to lookup extent item for logical %llu: %d",
 			     logical, ret);
+		btrfs_release_path(&path);
 		return;
 	}
 	eb = path.nodes[0];
-- 
2.51.0



