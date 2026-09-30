Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209693B2FDC;
	Wed, 30 Sep 2026 17:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791109; cv=none; b=Ds9RnPn89i4GqxVxie6uBYQU3QXjOPKBQq1vmgEF+qFDXbkCyRLgo0I8V9qXUJApwmX5t3RFudWc+tL4Kpoo9zwkXo40BuW53q7ydZ7sxx9jebSoze/2IyWcUPduFAgp0n/eEyQ1fz83M4ob1bliUP4GfxjL7FUZ/OyMfvIEUGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791109; c=relaxed/simple;
	bh=LudNcacUUr7qxiQCJiXhLYVkfJtYl0RbLRkTPA+O574=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DV+RxsuRgmVSfA2fkJGYFl2zuuECTW4s1N10L+0cTGVUqTlXYVDmUU+89dEHy0lO9Ro2y8+K80GUcB+fX7T/IW7n+M2EF9oFS7KnkjqxXv3KW4w1/fDZpXJjngTWix3p8RlwE11e8lRV66u7T2mEWwp5Ioxg6vLtMl6FRZjN+es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0ZjU4Wd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0ZjU4Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D12B1F00898;
	Wed, 30 Sep 2026 17:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791108;
	bh=uV9KJx/KsPhkymTGZX0PA/uE+P/tAKk5gzGejkPnEOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0ZjU4WdpvpxI2LfzrkT2wQmQJ8DzaiTmtPnGFf+1DktN0J8yyk1W/Hur8CJxvhpg
	 kK7Y6R5MvjpxxP0SHhojGr1Gtp+WJXqtz1QK6NmFMiUyFIGI8ZzZcXEKLa9yZpi1P4
	 DIpqpZX5WGgfOvNuOWou1KvW1PB/mH8sdqirEUak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/752] xen/gntalloc: validate grant count before allocation
Date: Wed, 30 Sep 2026 17:20:58 +0200
Message-ID: <20260930152402.278604909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index edb0acd0b8323..e95dd0b9b6ba9 100644
--- a/drivers/xen/gntalloc.c
+++ b/drivers/xen/gntalloc.c
@@ -275,6 +275,7 @@ static long gntalloc_ioctl_alloc(struct gntalloc_file_private_data *priv,
 	int rc = 0;
 	struct ioctl_gntalloc_alloc_gref op;
 	uint32_t *gref_ids;
+	unsigned int limit_snapshot;
 
 	pr_debug("%s: priv %p\n", __func__, priv);
 
@@ -283,6 +284,12 @@ static long gntalloc_ioctl_alloc(struct gntalloc_file_private_data *priv,
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
@@ -295,14 +302,16 @@ static long gntalloc_ioctl_alloc(struct gntalloc_file_private_data *priv,
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



