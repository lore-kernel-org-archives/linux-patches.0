Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBDBDDAB;
	Tue, 11 Nov 2025 01:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824835; cv=none; b=nYW42kbgqMbX8OXP1CcOoHNXYEIuAVp2+oXJ3L7dICoNE6r1Iy8UqKmQmwzl6tZOSKPxIgdJXqmiFTjPIvng2unoU1AqAQR0etB6bd9CxaWt6x73TdkmewNUr+Y3LJpSLIJNf5epfr9cGRyNAWDd1sxCErfLGCUBffMA1yj6YR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824835; c=relaxed/simple;
	bh=0+M0/b+CMFDJNxlNegA1QpVepb9D7MxQ0/NX4ihTh8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/5LtJqwOad/XOA7U/R+tfQpJWabN9nRSdF2K+PydyWG8LpQ1dN0oG6Rys0+//3yGwviMod3lqjjgavuQXi06m4VJIj0XhkYXYQ808jXNxGspjBDJWsxZM/k5+wd5N3jF1OzSQTzTdrAtnteYWgAbg/EdKp+0dTFBVaU+2uYXBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrkRr+cp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrkRr+cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2EEC4CEFB;
	Tue, 11 Nov 2025 01:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824834;
	bh=0+M0/b+CMFDJNxlNegA1QpVepb9D7MxQ0/NX4ihTh8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrkRr+cp0BT4B0VeD9XvyecAFqCHyaI98oCbmb52HwGrVX/ZqgTCyvoftmx3KrePy
	 rljkW806y638TgY7nikNKNuHfWMFt/xPBpGdhRlYHb+g0Gq3YVk8ZNlnLw8UdH4fU/
	 jcHPukJReFqs0+0OSzkygojn1wvZS629L4wFf6VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 581/849] f2fs: fix infinite loop in __insert_extent_tree()
Date: Tue, 11 Nov 2025 09:42:31 +0900
Message-ID: <20251111004550.465190876@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: wangzijie <wangzijie1@honor.com>

[ Upstream commit 23361bd54966b437e1ed3eb1a704572f4b279e58 ]

When we get wrong extent info data, and look up extent_node in rb tree,
it will cause infinite loop (CONFIG_F2FS_CHECK_FS=n). Avoiding this by
return NULL and print some kernel messages in that case.

Signed-off-by: wangzijie <wangzijie1@honor.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/extent_cache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 199c1e7a83ef3..ba0a07bfd3463 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -604,7 +604,13 @@ static struct extent_node *__insert_extent_tree(struct f2fs_sb_info *sbi,
 			p = &(*p)->rb_right;
 			leftmost = false;
 		} else {
+			f2fs_err_ratelimited(sbi, "%s: corrupted extent, type: %d, "
+				"extent node in rb tree [%u, %u, %u], age [%llu, %llu], "
+				"extent node to insert [%u, %u, %u], age [%llu, %llu]",
+				__func__, et->type, en->ei.fofs, en->ei.blk, en->ei.len, en->ei.age,
+				en->ei.last_blocks, ei->fofs, ei->blk, ei->len, ei->age, ei->last_blocks);
 			f2fs_bug_on(sbi, 1);
+			return NULL;
 		}
 	}
 
-- 
2.51.0



