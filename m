Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF38525C717;
	Tue, 25 Mar 2025 12:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906306; cv=none; b=r7SXWIN2JEbkYeWtM8zDO9xNgqREwUPN5x+BwI8RzJ/EXOeJjoGZvgLG5c9MX+yd0CfusrgUrR4kjI9NRbHMJJR9/Ms2GZN+rq1/Jk+iG4ic5kRDVSHMDJScdzX7HxwzQVpW/ISB3J7lzWvHgwCh+/3QlLUr3xk0D2iMZli0uwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906306; c=relaxed/simple;
	bh=qF8nnOmDKv+eJz4k//BNqlGElgCO9OKEuTsnp3XM85g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASpAgU+jK0/W/wE4K3VdGz6Mq9Oq4SNi9Qaw7TAhHvJ0PftFo+sE6FSVT9gES/RGWaF9MLXYMaxtPtUpmTuiT8Zs7nKyZOfIvXWIv9naKB/boNFUQrilC+y/rHTzuNDLxM+TuQCv85a3LZGvTPCxs4wmkG9AxTPAFDg9J8G21GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9z/Fm/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9z/Fm/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710D8C4CEE4;
	Tue, 25 Mar 2025 12:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906306;
	bh=qF8nnOmDKv+eJz4k//BNqlGElgCO9OKEuTsnp3XM85g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9z/Fm/tEsVyozRpSfKMOSyqaonkTZbZuqWXhO6uF+yJivodAwH8DrDBaH4ZxEYCv
	 wIX+oQmJO+svX5dvNKxzNnyLN72copt2wpJEANLbtJhzuLOSJfYD6FSe45Bh3+bbNd
	 PmernBPy87MGuFqUTJ0P3FoJyvkDVYPKvwTWqu5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/116] libfs: Fix duplicate directory entry in offset_dir_lookup
Date: Tue, 25 Mar 2025 08:22:15 -0400
Message-ID: <20250325122150.434751788@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongjian Sun <sunyongjian1@huawei.com>

[ Upstream commit f70681e9e6066ab7b102e6b46a336a8ed67812ae ]

There is an issue in the kernel:

In tmpfs, when using the "ls" command to list the contents
of a directory with a large number of files, glibc performs
the getdents call in multiple rounds. If a concurrent unlink
occurs between these getdents calls, it may lead to duplicate
directory entries in the ls output. One possible reproduction
scenario is as follows:

Create 1026 files and execute ls and rm concurrently:

for i in {1..1026}; do
    echo "This is file $i" > /tmp/dir/file$i
done

ls /tmp/dir				rm /tmp/dir/file4
	->getdents(file1026-file5)
						->unlink(file4)

	->getdents(file5,file3,file2,file1)

It is expected that the second getdents call to return file3
through file1, but instead it returns an extra file5.

The root cause of this problem is in the offset_dir_lookup
function. It uses mas_find to determine the starting position
for the current getdents call. Since mas_find locates the first
position that is greater than or equal to mas->index, when file4
is deleted, it ends up returning file5.

It can be fixed by replacing mas_find with mas_find_rev, which
finds the first position that is less than or equal to mas->index.

Fixes: b9b588f22a0c ("libfs: Use d_children list to iterate simple_offset directories")
Signed-off-by: Yongjian Sun <sunyongjian1@huawei.com>
Link: https://lore.kernel.org/r/20250320034417.555810-1-sunyongjian@huaweicloud.com
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index b0f262223b535..3cb49463a8496 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -492,7 +492,7 @@ offset_dir_lookup(struct dentry *parent, loff_t offset)
 		found = find_positive_dentry(parent, NULL, false);
 	else {
 		rcu_read_lock();
-		child = mas_find(&mas, DIR_OFFSET_MAX);
+		child = mas_find_rev(&mas, DIR_OFFSET_MIN);
 		found = find_positive_dentry(parent, child, false);
 		rcu_read_unlock();
 	}
-- 
2.39.5



