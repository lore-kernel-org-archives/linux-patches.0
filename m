Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056AA335561;
	Fri,  9 Jan 2026 12:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960141; cv=none; b=CPmyhObxAlC48eieIvDTaKp37gAhDHmYuQtZFKk8gKWBV5qfuB9GrayH+l4mJz6+7FlcnkEY3IkpIYO/2IP8BMWUd0RQpfinoN97/z86obL1SXse/xG2YJnCsDOIo/i+O3hSNtXhI6GSCJVZ1zBlJHo26vBczuMRcSBkBFzho+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960141; c=relaxed/simple;
	bh=J4DNuhPJCa0qW3QgSIXGww0/522uNZ70xfkzt10tq3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fzg8XHnaK++bzmN+UDbwFxQcpc7U55IZycN3bbPGC2IjWX+0PCRMQ4jJZqVfe8HkHTmDi6gKkiwr7lqpdgMmZHbhB4pJqPze9uD69T7Q0ArkrlwXXhMY1aqnuHTa7YjtrIVchywxvXbcSmCtJwIL4PvTEfuK/F9YIA8Gnj65xIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZ3jMT7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZ3jMT7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6FDC4CEF1;
	Fri,  9 Jan 2026 12:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960140;
	bh=J4DNuhPJCa0qW3QgSIXGww0/522uNZ70xfkzt10tq3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZ3jMT7+SpOV2Gdd8Z0N8H9wPfFtI7Wsr5puIqOZc8mU/YIMTckFpBugnHPKGreyJ
	 /lxUMcAo1CDHfwV0Yxnt3zIiGfoSgi/ELcNNPtWxN1T9CKotH03VD8AjJfU8G+nbiS
	 mP3xpZKQFDMgVbIDR5nvHRdXrRp988hJzbyEMjpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 300/737] btrfs: fix a potential path leak in print_data_reloc_error()
Date: Fri,  9 Jan 2026 12:37:19 +0100
Message-ID: <20260109112145.293265355@linuxfoundation.org>
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
index b1be3e0fe7282..68bb5079aef74 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -266,6 +266,7 @@ static void print_data_reloc_error(const struct btrfs_inode *inode, u64 file_off
 	if (ret < 0) {
 		btrfs_err_rl(fs_info, "failed to lookup extent item for logical %llu: %d",
 			     logical, ret);
+		btrfs_release_path(&path);
 		return;
 	}
 	eb = path.nodes[0];
-- 
2.51.0



