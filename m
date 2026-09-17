Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B3A4F392B;
	Thu, 17 Sep 2026 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660619; cv=none; b=Ldg9GNAQVeZY4wu7lHGEXdnRmDlzPU+LN8UuIU+wT/tx7RFjAZAKaoQ6C+98MWPJjIaOIKOdGRvv6ZFpE5OKVYwAmjg5Mov1QygDwB9VZbFnCr8OHiKSzASel7Qk0RxXRFtoQIIyJO5kAujn8dB60LSlip/4UPpp/teBkZWz1Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660619; c=relaxed/simple;
	bh=j9OqSdh249UYMidq5BazGbNIhBXalIIWOzXSGQA/nto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BazIH04vnfOixiXGmfjz4OsbzgV3RojkL/3bjFNpM2ihqD8D1cQ23gFvuE06yrV/1toNdOszROqkIf2tpWGaPqx7Fvkyrm+TKIUbg28enL8oTqlYLC5Ls6Wet0LcuC7axqJA7ZD1CVpVN3xkVKqJ1lIQtmqBbxc9YVL33zwfq9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLxBRQj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLxBRQj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B261F000FF;
	Thu, 17 Sep 2026 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660617;
	bh=sfFMFpbCxwQAsWMMlK0z0VVxTBt6VD8si13SNQS9x3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLxBRQj4lARz7pAjHG/j2tlCt74xVFYbW3Iox2lp275uKZIiERHW+MCy8VRgRa9Tg
	 XlZv1bLQdtL1a8asZtBpA/9x9uAoJIq8+a0T3iClW1eOr9RkgtxG/sm1pyFpSuodKT
	 TaDZx/PucFIycjQlw8BAUWWjJQ/uakT85Lp+aZfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 651/733] xfs: preserve owner on in-memory btree creation
Date: Thu, 17 Sep 2026 16:15:59 +0100
Message-ID: <20260917151408.851532590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
@@ -117,6 +117,7 @@ xfbtree_init(
 	struct xfs_buftarg		*btp,
 	const struct xfs_btree_ops	*ops)
 {
+	unsigned long long		owner = xfbt->owner;
 	unsigned int			blocklen = xfbtree_rec_bytes(mp, ops);
 	unsigned int			keyptr_len;
 	int				error;
@@ -133,6 +134,7 @@ xfbtree_init(
 
 	memset(xfbt, 0, sizeof(*xfbt));
 	xfbt->target = btp;
+	xfbt->owner = owner;
 
 	/* Set up min/maxrecs for this btree. */
 	keyptr_len = ops->key_len + sizeof(__be64);


