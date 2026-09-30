Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B23E55293A;
	Wed, 30 Sep 2026 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790174; cv=none; b=LsaC/K+jN3D3pztookP6UdyHfIClaxUgXhK2hA+LdL4lmzzv+xVqg5quv7ulDansZuzWecs1DBLV8inicqNdru5m83i1m55nJW0Ci9/2xy1AeD2nY8NEQaPNMbKRzlmvpwkLK+PX2nCK0jrUy5IpBNWOUyYbX6UpND91XzjDy04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790174; c=relaxed/simple;
	bh=bJwxOpXNyBPwoiPbMVORodLtt263UHqcTwSoUlfGe/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRJbVpWl8oO9ARgWAm7lIGrAhs1+1YhyZ3LxcCPiBKO1AyCZRtWrJqY7Tr1p3Md5HAuUvBaTwbHMMyWCOnwfVMSZufCjLP+hiNKoNGVhxnIRS9wTV+MJKd8prvfk8u2bByuWHFfn8R2Ae6Bi1CioNQJgjenScLZ0DAbbSwyJrNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4vdK644; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4vdK644"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70D21F000FF;
	Wed, 30 Sep 2026 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790173;
	bh=aU7iZ/i9/s0cg3RcaG0NEoM5HuQ6NYNsk2DxnQvziXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4vdK644qhZ4fJ17KxZvNOTXIhjkWSLfJYvxbmB77SsSxLpAehsywFn0W0PRnhNjz
	 K7QyiDonckT3m1w0PDYdG9WgruiOmWLqTHjAdYO1aV6C2gJ5so7gCyx8p/pbq5Jnps
	 1qYXyCQwseMhFY8DBqHyBwGL6blcKCiuM6VoPMRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Guanghui Yang <3497809730@qq.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 692/877] f2fs: fix dentry folio leak in find_in_level
Date: Wed, 30 Sep 2026 17:26:43 +0200
Message-ID: <20260930152429.610827278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit cca7d3e30bf30333314e31bc70b9a739f1342167 ]

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
[ Replaced f2fs_folio_put(dentry_folio, false) with f2fs_put_page(dentry_page, 0) for the page-based API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -298,6 +298,7 @@ start_find_bucket:
 
 		de = find_in_block(dir, dentry_page, fname, &max_slots, use_hash);
 		if (IS_ERR(de)) {
+			f2fs_put_page(dentry_page, 0);
 			*res_page = ERR_CAST(de);
 			de = NULL;
 			break;


