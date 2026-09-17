Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7206D4E4C56;
	Thu, 17 Sep 2026 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666856; cv=none; b=P5dkWTET9OfyiymRF33rtCFtjml2CWJjPKjfmZn3CeoR/d9ZVZkEzaPm78pCWyogCMft1mdYWM99jeBwwflnUJV5LNdPZdxRVRsTaX1BtnrGpatwjL9wykWZ2ZTyJtW8z+uBAy6+2vm9/NjkKVdpr2kdsuLfBVF1Sp1RzvrGEd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666856; c=relaxed/simple;
	bh=3BzXHbK0fPnSc1C12vLOmmU//I8av9OpxbY4VUPsTys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDbZe/xOiwrd1xoTLrX38emfY4bSBKDe87BmwYQc4BB/P/DmGaPphcfx6uD6JSOihgNdEDnATi7gxW2efUGD942V/e4DqnOBrf+IOqTyaXnHZbxV9FeTfszi6H9lWR+MS+qkua+He5H66s9O+oPOIwR+QGg1IUl8b2VAh58q7A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9am2HKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9am2HKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6319F1F000FF;
	Thu, 17 Sep 2026 17:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666854;
	bh=YxbQxpSjFSMCWnLy+7V7v4z5W7W8wtrY7aAthgqCrWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9am2HKFkE/s0Dlj453/oENhLygvKwpkMEhvGnUAaSQujIb1yuoHS6ROAMQ7iMFw1
	 RN8ToHt1sF4Svgl+uhrHoRE3J4GeYMHQv5zTr4XJoACbigUWt0UXLFE6WAkoEY4+A+
	 mYCDH6BO6f3m90c68Fr0oyxkrh96uHivViOdIjpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1109/1250] xfs: fix reclaimed page accounting in xfs_buf_free
Date: Thu, 17 Sep 2026 16:15:04 +0100
Message-ID: <20260917151622.255979649@linuxfoundation.org>
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

From: Eric Sandeen <sandeen@redhat.com>

commit 4164b1e3d728c7cc05e0c1171068aa046542ecc3 upstream.

To obtain nr. of pages in "size" bytes, we need howmany(size, PAGE_SIZE)
not howmany(size, PAGE_SHIFT). This over-reports reclaim by orders of
magnitude, up to 4096x on a 64k page system.

Fixes: e2874632a621 ("xfs: use vmalloc instead of vm_map_area for buffer backing memory")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -111,7 +111,7 @@ xfs_buf_free(
 	ASSERT(list_empty(&bp->b_lru));
 
 	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
-		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
+		mm_account_reclaimed_pages(howmany(size, PAGE_SIZE));
 
 	if (is_vmalloc_addr(bp->b_addr))
 		vfree(bp->b_addr);


