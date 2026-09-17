Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FA04F649C;
	Thu, 17 Sep 2026 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664775; cv=none; b=Dujv8dRfgLnfj2ZPKe1uz7c8i7H4YqaR3vc29FbHukuAbpRxws0Q2DqQwrhxwbWeSCu3NCdQnl5gleR8/Z2wk1KIIH+OU6zk4GwzRzBDKBBnakth/vEGkRpYyb4QXPTE9KFgOyMP2iCL5huxDnk1hYtBOHO+6v6IWIqy8Lfuejk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664775; c=relaxed/simple;
	bh=47cP0CHa6i7n3Xp0pjQz3t3jhyGLePImMi5crl1+5U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOQcVAF1BM/YmafFYC8SfTMHAg3nuzINDYGQGbxg1aC3Fuz3UzfBIYRi7a27jqPA1RpP8/xRYfaGWcK9UDGiOwBWHxxV2Ik7ve+QFzCWdfp4B7s20UObfnEgWzmOGepeaw8HnvdbKoBeEb145EZshcz7ckv0omDhK/dIt1uR/74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uinc8/P4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uinc8/P4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FE51F000FF;
	Thu, 17 Sep 2026 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664773;
	bh=z+1dmb2XqcBZqvuRu3vDZk9LL8RWrNGzS3X37sDhAlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uinc8/P4t7183M7mmcFuvZZ/P03AuRmv11uF7vlPneJ6EkOy1MVixlGO/OPv5iw0g
	 8CdWTHB9XxqcqzRussmady3YI6JkMXvd74bQzoOC6zdI9h4uLaofiQu7iZMqe6WLp/
	 EBCJ0F3izzN5u4RAXv42Lvu0baaQvIUAT/hwmIw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0485/1250] xen/gntalloc: validate grant count before allocation
Date: Thu, 17 Sep 2026 16:04:40 +0100
Message-ID: <20260917151605.113426928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index f93f73ecefeee..462f67dc32751 100644
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



