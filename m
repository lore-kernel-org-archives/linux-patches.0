Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9B257269C;
	Wed,  9 Sep 2026 14:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964363; cv=none; b=hYaHZU/MRIyL0j4lDMbw55S+gediug05eih0HgXiXW1l9fIMLJ3IaeQ7bfvaDDw36zblVQyW2Q3aicFqJszB76x0FvHbDZxG87ziQKuZHe0x13UUFWzno7vsiuV8pgsyE8pv122ibGkrDlagtyo7OnX4wuRxJexLmPOqmuNK7uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964363; c=relaxed/simple;
	bh=nCosLcBHAetCOUpr8ylhNWeYM0Y5s8fWYDK6opiTQv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDLXL1hlGndWzuHXFDhbDDn8SM2TmG+z9usB5S6pOzo6wgi5v2J1GkVca/AqV6vdJv/FP5lOlDviH+sHMTNUlMmNZB39PcB4b73IZiLx70/UsblP2Tm2mnIr5vYR+WTSQ92e3wikLvwkh04FspQWYRjw64UnSpZ8oMlzl6k7ydw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKLb+cvg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKLb+cvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CDB1F00A3A;
	Wed,  9 Sep 2026 14:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964361;
	bh=YH2QpFzecfHwxMlWsZgmoDBm6Lj6G9Sj9zC1WVJjIww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKLb+cvg8ij78pvbdR5poCIbAnh1JA9ExGHYY1UjS545lAGDeUrUhQy8LuZXXObCK
	 DLB4iZEmowdf4Fvc3dKJw8kxmJRUarSDBjqOIi5bIimcg79W7hjmGO1v27osj3gXjl
	 sb1kJVcFyMi0m15Som+JPGGAFQ3YRMBmdb3PTFYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 364/583] f2fs: fix to off-by-one issue in f2fs_zero_post_eof_page()
Date: Wed,  9 Sep 2026 15:40:49 +0200
Message-ID: <20260909134250.651321223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit b2205d3cfd6c76fd5c5443ee9fdb498cfb0e1c66 upstream.

Otherwise, it will drop one more page after new_size which is not
necessary.

Cc: stable@kernel.org
Fixes: ba8dac350faf ("f2fs: fix to zero post-eof page")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -49,7 +49,7 @@ static void f2fs_zero_post_eof_page(stru
 	if (lock)
 		filemap_invalidate_lock(inode->i_mapping);
 	/* zero or drop pages only in range of [old_size, new_size] */
-	truncate_inode_pages_range(inode->i_mapping, old_size, new_size);
+	truncate_inode_pages_range(inode->i_mapping, old_size, new_size - 1);
 	if (lock)
 		filemap_invalidate_unlock(inode->i_mapping);
 }


