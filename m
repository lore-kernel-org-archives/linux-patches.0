Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0A333065C;
	Sat, 12 Sep 2026 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222068; cv=none; b=GNG5Xz7WpAvEYG6sCQYbC+S3ZKmaz2naaapk91T/u7saniTS7mtlEr/UAyVFiQ0bU8opfq6aIQctJm5plKTQBDsFZt5MbnOesn4lW6I/G5bhdwUhhzkK82qgKPk81p94q4Kb32Js+8WU41bVEQHsM34Xh5Kth7o0YTENedeAkaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222068; c=relaxed/simple;
	bh=JF0dYyzbRKRmZTlT7zZpm2oTtPRcOspGe6xhmKrqR/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1PHDWFBPH0B7u8zinBeZxjHF/lNYmEDQ0i0SOBik6pwvRg+yiPrBfZYM+veMHW/7hhYXyQ+oM8YfWbERnTTVvoaxrcHDD9QriS8Jop84wXSi2LQr7+wp1Rt7g8iTx5q2XOnpJxP/d2G5tsGcKY6xDwbp93YxdaNabplkis3LxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcbkdJ7y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcbkdJ7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB9D1F000FF;
	Sat, 12 Sep 2026 14:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222066;
	bh=u+t0rOgKCMq50zwGzPixIDxLkG87gbbWlYDoOMgmJWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcbkdJ7yo82CnBhymixeXE/zDhWhHqMo20auDynbbat9dEgkyfQkeW2TG5j8OseN0
	 /rlEhv12RN1RLwyXvZy7KZsEMUcM3NYwHsNXDbOEx6fLqKsc1ol9tiBrJOfMy9pl1j
	 M1Hw3iwF/BvBtXJqdsRD+vF/ZGgQXRtq0noF84pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 0504/1424] f2fs: return writeback error from collapse range
Date: Sat, 12 Sep 2026 08:48:56 +0200
Message-ID: <20260912065618.576855695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

commit f8a4108800254d6f7b2755515fbbd9d0caac561e upstream.

f2fs_collapse_range() writes back pages moved by f2fs_do_collapse(),
but ignores the return value. If writeback fails, the ioctl can still
truncate page cache, shrink blocks, and report success.

Return the error before truncating page cache or updating the file size.

Fixes: b4ace3370324 ("f2fs: support FALLOC_FL_COLLAPSE_RANGE")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1531,11 +1531,14 @@ static int f2fs_collapse_range(struct in
 
 	/* write out all moved pages, if possible */
 	filemap_invalidate_lock(inode->i_mapping);
-	filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
+	ret = filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
+	if (ret)
+		goto out_unlock;
 	truncate_pagecache(inode, offset);
 
 	new_size = i_size_read(inode) - len;
 	ret = f2fs_truncate_blocks(inode, new_size, true);
+out_unlock:
 	filemap_invalidate_unlock(inode->i_mapping);
 	if (!ret)
 		f2fs_i_size_write(inode, new_size);


