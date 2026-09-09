Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B54572688;
	Wed,  9 Sep 2026 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962987; cv=none; b=O3w+mTpyfqLTNebT9c2vXV3YwrkY/nYu587vqg0oiaA3mbv6RbRbeOoEEwTJzLEeU8pRxSlPwE182bWYg3qflS+HVSlw34jW7aXost6ZZlRHbFCm3FEFBGVTzQv3bosgWy3B1PAgsQxIj6g+hZl7ReFAsBM3FVsx6kTRTVAn8xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962987; c=relaxed/simple;
	bh=hGrPgyulE9sIkOucuSjXrqus8+U1laZUcCjhe9vT0iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bs3kurMabnHM7uzKTbaYSFJUI6YnIMjXUgjKRpV6utbaJdWrBs0HOy8+kiLCCo/XMZkN8M7wi050KmyrFFJ9KZuBH5YflHLhnUIDUiz1OdpklMJuvws/on7w1ZxLAy9cHjBqmM5Ku+RnKNY9tciYDnmd4ibJLODjDIyTW+w+j4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hylJJr8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hylJJr8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E92F1F00A3D;
	Wed,  9 Sep 2026 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962986;
	bh=EdOjDogcTY4lFmLOzH+UUf+Z3/jnN8X7GIe2lzJI+N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hylJJr8YMd5bcWlfdDvo/zgwk4v+hQzq3raAFrM3VT6O20At/quqg010gw48xR6l0
	 JKPosRPJfIJbkx//B/c+q5ir/ufhf2bUcfn3Z38K5DydQilcbboI7PmxXqh1DMmJfM
	 2SG9kcb8cgJpbwW1ubptNVpx1HFHAwGXoJPVt0dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Guanghui Yang <3497809730@qq.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 458/556] f2fs: fix dentry folio leak in find_in_level
Date: Wed,  9 Sep 2026 15:42:18 +0200
Message-ID: <20260909134246.681550157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

commit cca7d3e30bf30333314e31bc70b9a739f1342167 upstream.

find_in_level() gets a dentry folio with f2fs_find_data_folio() before
calling find_in_block().  If find_in_block() returns an error, the
function stores the error in res_folio and breaks out of the loop without
dropping the dentry folio.

This leaks the folio reference on the find_in_block() error path.  Drop
the dentry folio before returning the error to the caller.

Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -320,6 +320,7 @@ start_find_bucket:
 
 		de = find_in_block(dir, dentry_folio, fname, &max_slots, use_hash);
 		if (IS_ERR(de)) {
+			f2fs_folio_put(dentry_folio, false);
 			*res_folio = ERR_CAST(de);
 			de = NULL;
 			break;


