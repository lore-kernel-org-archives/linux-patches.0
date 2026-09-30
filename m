Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2FB3F926D;
	Wed, 30 Sep 2026 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784689; cv=none; b=V83f3XFMHlerQrs8mktxVq75s6PtzIWl1KKXrxsM5cAYVZbMd+Io2XiSi3K38V+4QYfe/6UD27A5o7mI88RUC0ohnAk5rS84fBnacrSB1J/h3w+gPuB9cTJZc/l4HtosMoVcby9jFvbua69dg4FF2mZdg/c7X6CFxf1t9eXaaAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784689; c=relaxed/simple;
	bh=UVO+7IFjTU0lgukVLyyb1ygvJU/SLbXvuvChDvdc7oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvCcu7k66MuqyLQGAW+LG/E55ZOx/6cnDiAiUY7v+st/Q5lWyI1RHwdtTjiyeQt9HFeZRy88NbdqJ0/CaBF2ZvVCkA/H1Y+APnV9rPyjA8LrlWBdXloYNDxK38Yp3RHm0gF8NZZHX2JEsZd94QdIqLlxrjpLHl+JHLcsjeDcfiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnWWhLjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnWWhLjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF65F1F00898;
	Wed, 30 Sep 2026 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784683;
	bh=sD0WESOvP6lZMpOPMDB0BTDOHu7v5UJLcv7a/ta/2TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnWWhLjpp9OthiNaf3x3FAl6K6XR8/73wc6Ws2XSWRgeU68j8vQMHw6cqZt24uwWy
	 hEdf5OiGT9y8QJh5JFvYUToBNEVEI6Z+if1GEoOySLuLSN3Wech1z+NyD2F07PKXqQ
	 zqdQtvtd6xrqrOFtXY33G+rbytjDmKte4rTZT0Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/982] xen/gntalloc: validate grant count before allocation
Date: Wed, 30 Sep 2026 17:16:17 +0200
Message-ID: <20260930152421.970837980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 2299822f3f466b5dcad2377bf63986199f881a6b ]

gntalloc_ioctl_alloc() allocates the grant-id array before checking
whether the requested count fits within the global grant limit. Counts
above that limit cannot succeed, so reject them before the
user-controlled allocation reaches kcalloc().

Use a subtraction-based check while holding gref_mutex so adding the
requested count cannot wrap. Also cast the count before advancing the
per-file index so the page-size multiplication is performed in 64-bit
arithmetic.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260626223805.43781-3-alhouseenyousef@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntalloc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/gntalloc.c b/drivers/xen/gntalloc.c
index a15729beb9d1b..22747fa4bbb89 100644
--- a/drivers/xen/gntalloc.c
+++ b/drivers/xen/gntalloc.c
@@ -272,6 +272,7 @@ static long gntalloc_ioctl_alloc(struct gntalloc_file_private_data *priv,
 	int rc = 0;
 	struct ioctl_gntalloc_alloc_gref op;
 	uint32_t *gref_ids;
+	unsigned int limit_snapshot;
 
 	pr_debug("%s: priv %p\n", __func__, priv);
 
@@ -280,6 +281,12 @@ static long gntalloc_ioctl_alloc(struct gntalloc_file_private_data *priv,
 		goto out;
 	}
 
+	limit_snapshot = READ_ONCE(limit);
+	if (op.count > limit_snapshot) {
+		rc = -ENOSPC;
+		goto out;
+	}
+
 	gref_ids = kcalloc(op.count, sizeof(gref_ids[0]), GFP_KERNEL);
 	if (!gref_ids) {
 		rc = -ENOMEM;
@@ -292,14 +299,16 @@ static long gntalloc_ioctl_alloc(struct gntalloc_file_private_data *priv,
 	 * are about to enforce, removing them here is a good idea.
 	 */
 	do_cleanup();
-	if (gref_size + op.count > limit) {
+	limit_snapshot = READ_ONCE(limit);
+	if (gref_size > limit_snapshot ||
+	    op.count > limit_snapshot - gref_size) {
 		mutex_unlock(&gref_mutex);
 		rc = -ENOSPC;
 		goto out_free;
 	}
 	gref_size += op.count;
 	op.index = priv->index;
-	priv->index += op.count * PAGE_SIZE;
+	priv->index += (uint64_t)op.count * PAGE_SIZE;
 	mutex_unlock(&gref_mutex);
 
 	rc = add_grefs(&op, gref_ids, priv);
-- 
2.53.0



