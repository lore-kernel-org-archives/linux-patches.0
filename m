Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9EA13DBB3;
	Tue, 27 Feb 2024 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043459; cv=none; b=b+Vrhfgxh/EaJatiJbbvULb3C5P0mVO6rfyv0R7SmHHlicjxqXkNrGKa19zlyIplx9qjnDea/32lNbw3V/L7KxTSJrz3idD+548b8REoNGwe9672TNck1exNlfH6B6WBHQouAQkyeXfrOzIJzqAvUxs7dQ4vFHLk6sLT2OniiJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043459; c=relaxed/simple;
	bh=7K22ub2pm2pRUubhPecB/yOnnQLoU+nmdkZB0r44FoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8GtD6U0F8LebkQANDyvkpEcdWBCZRR16jOtjIm5px/lntyWAV+zNg6wzvELks3cjhTrgVh8E728CBJIpEynQzeE0v4NOPf5FCFisjUsY0GqoPA7QZS51g/8CnUKfwHpy10eY5wBSoOjGSLFyFAHOzouhibjeFM6zjTiJ9aB1ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCCYo2XF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCCYo2XF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7CAC43390;
	Tue, 27 Feb 2024 14:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043459;
	bh=7K22ub2pm2pRUubhPecB/yOnnQLoU+nmdkZB0r44FoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCCYo2XFcZJA44X/YBV7OS3Xm6hKVx6yKluWSPm2lT5Z6xfq9gxVaQpEPb76dU5JN
	 QL0xORrnXp5o/yNZH7X/yjSuGn8Ya7mGKHJeSqzMypr4aK4ElQ9/kc5jVAgirFGebN
	 cGFNLuuaf06AwNqS8QmVeC2z6pk7narfO8cJy07s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandeep Dhavale <dhavale@google.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 6.1 116/195] erofs: fix refcount on the metabuf used for inode lookup
Date: Tue, 27 Feb 2024 14:26:17 +0100
Message-ID: <20240227131614.290141081@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandeep Dhavale <dhavale@google.com>

commit 56ee7db31187dc36d501622cb5f1415e88e01c2a upstream.

In erofs_find_target_block() when erofs_dirnamecmp() returns 0,
we do not assign the target metabuf. This causes the caller
erofs_namei()'s erofs_put_metabuf() at the end to be not effective
leaving the refcount on the page.
As the page from metabuf (buf->page) is never put, such page cannot be
migrated or reclaimed. Fix it now by putting the metabuf from
previous loop and assigning the current metabuf to target before
returning so caller erofs_namei() can do the final put as it was
intended.

Fixes: 500edd095648 ("erofs: use meta buffers for inode lookup")
Cc: <stable@vger.kernel.org> # 5.18+
Signed-off-by: Sandeep Dhavale <dhavale@google.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20240221210348.3667795-1-dhavale@google.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/namei.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/fs/erofs/namei.c
+++ b/fs/erofs/namei.c
@@ -137,24 +137,24 @@ static void *find_target_block_classic(s
 			/* string comparison without already matched prefix */
 			diff = erofs_dirnamecmp(name, &dname, &matched);
 
-			if (!diff) {
-				*_ndirents = 0;
-				goto out;
-			} else if (diff > 0) {
-				head = mid + 1;
-				startprfx = matched;
-
-				if (!IS_ERR(candidate))
-					erofs_put_metabuf(target);
-				*target = buf;
-				candidate = de;
-				*_ndirents = ndirents;
-			} else {
+			if (diff < 0) {
 				erofs_put_metabuf(&buf);
-
 				back = mid - 1;
 				endprfx = matched;
+				continue;
+			}
+
+			if (!IS_ERR(candidate))
+				erofs_put_metabuf(target);
+			*target = buf;
+			if (!diff) {
+				*_ndirents = 0;
+				return de;
 			}
+			head = mid + 1;
+			startprfx = matched;
+			candidate = de;
+			*_ndirents = ndirents;
 			continue;
 		}
 out:		/* free if the candidate is valid */


