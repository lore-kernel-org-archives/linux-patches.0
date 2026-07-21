Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DE046C4BC;
	Tue, 21 Jul 2026 18:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659556; cv=none; b=KD53Rs3K6948dfWDF297XsOqy+c5j2aa1SNKDaTxPy6Ng2NIwf8Akjes+z/OymwhguR+zCBGINZ434fYDbfKS3tfrc34ZKVP9n0JG66YdTKYs12GkyP27ZqBB2oSGm0yEKxsHvnGX7AhQvOLPsxB8epPxtqzUqinknHk7TVseVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659556; c=relaxed/simple;
	bh=exrlSg41hyU/+GvJTlvXwMLRVLdWFczwKZJ6NvxCTyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZ5stG553BeKUQLmgaP/DjdfAPDTQPp4eTkel4smNDfHRDMewAvmqKW9icMyi+qEy4flPrfxCrEbg5MNFSb0y5jJsRGx+No64J6NK4/rwE6NvmMP7eMpzKjABaiZSfyFLDjmUPbj136j0NQdjBhz7N1VBgEEZitF6Iaa3Ydw1w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL3yf7Qd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL3yf7Qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D7D1F00A3A;
	Tue, 21 Jul 2026 18:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659555;
	bh=nlanCATwccGgltkq8V0UvHp05+qJLsQ8kixyMT9goZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eL3yf7QdVcTOnGVOkb1xMIHA88YxHF9/OMs5h7BTQaqieLOOcqrSK9xff8IHS/W6g
	 9fjtjXXgNl3l+SWM053L0cgIAYi/dZCfLQXbi9DyHbeB4uuvA7ZPf7aEu4y74Nox2Y
	 sEgKfEupqXqj1hJZzu6IGGXjTl9hQGphx9zXQ204=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1564/1611] xfs: initialize iomap->flags earlier in xfs_bmbt_to_iomap
Date: Tue, 21 Jul 2026 17:28:00 +0200
Message-ID: <20260721152550.641469421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 327e58826eb72f8bae9419cf1a4e722b57c85694 ]

Otherwise we lose the IOMAP_IOEND_BOUNDARY assingment for writes to the
first block in a realtime group, and could cause incorrect merges for
such writes.

Fixes: b91afef72471 ("xfs: don't merge ioends across RTGs")
Cc: <stable@vger.kernel.org> # v6.13
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -113,6 +113,7 @@ xfs_bmbt_to_iomap(
 		return xfs_alert_fsblock_zero(ip, imap);
 	}
 
+	iomap->flags = iomap_flags;
 	if (imap->br_startblock == HOLESTARTBLOCK) {
 		iomap->addr = IOMAP_NULL_ADDR;
 		iomap->type = IOMAP_HOLE;
@@ -147,7 +148,6 @@ xfs_bmbt_to_iomap(
 		iomap->dax_dev = target->bt_daxdev;
 	else
 		iomap->bdev = target->bt_bdev;
-	iomap->flags = iomap_flags;
 
 	/*
 	 * If the inode is dirty for datasync purposes, let iomap know so it


