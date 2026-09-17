Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D242E4D17AB;
	Thu, 17 Sep 2026 18:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671215; cv=none; b=p6WaltZjc/VxIHD4egcqIrw1OYfiaXxrqXY8mLfVMnlOJdGcAhPjLxnny61XFLy30+UMeoUgTooNzq5UKJcVYzrcKTzwdzqJGPcvKb/KDzy6sTi5NUw7r6oGTqhn67H14k7+YTbWCSbyjiJTnoC6XTw6uj5ipsgPzEQ0LAjIWgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671215; c=relaxed/simple;
	bh=KDAORS9IbujS2/llbuVAodmitHQRw3/KsM/kzrgA2eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W49t4eh8chspi95koULaeNfOg5h9SLfOh8WBdj9ur5qQ41VLCAvoI8EkLWGITJzGBgWBVEwp+pQpdif7l5dW9aZp2GTkyvmFb8r9FpA2ToP3M5Z8pxT8jbX59pgg6+bdKkxevwQGpUh1+k++iBSbFG7UyCnCPPOrv/zMpV3C3ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InvOm5Ef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InvOm5Ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63491F000FF;
	Thu, 17 Sep 2026 18:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671213;
	bh=i0+FsMBixerbg991Gkzr8ih1gKttxNeBshRtTn9pk+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InvOm5Ef/QcWVtmfylns22imAF4InOuzVCiRbpiMgzSGL4O1Ea5Q7jA0tOF93gmie
	 y2vwRREBvsgyqzU16ToymAHoRAaHFCtwU+224gy9CIBiBAhgU8imCM6hEcPRbteuJG
	 XiMUhL6rxX7kK87s39ry3pkilNHCSOMciqk22MYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0903/1102] xfs: preserve owner on in-memory btree creation
Date: Thu, 17 Sep 2026 16:14:06 +0100
Message-ID: <20260917151603.273952035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 5287e56cba3be4a64bff9f73bce5964fda2590dc upstream.

LOLLM points out a minor bug where a higher level function creating an
in-memory btree is required to pass in an owner number, but the creation
function erases that.  In-memory btrees are ephemeral so this really
doesn't matter except for debugging.  But let's fix this papercut.

Cc: stable@vger.kernel.org # v6.9
Fixes: a095686a238352 ("xfs: support in-memory btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree_mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -118,6 +118,7 @@ xfbtree_init(
 	struct xfs_buftarg		*btp,
 	const struct xfs_btree_ops	*ops)
 {
+	unsigned long long		owner = xfbt->owner;
 	unsigned int			blocklen = xfbtree_rec_bytes(mp, ops);
 	unsigned int			keyptr_len;
 	int				error;
@@ -134,6 +135,7 @@ xfbtree_init(
 
 	memset(xfbt, 0, sizeof(*xfbt));
 	xfbt->target = btp;
+	xfbt->owner = owner;
 
 	/* Set up min/maxrecs for this btree. */
 	keyptr_len = ops->key_len + sizeof(__be64);


