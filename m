Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D383A48E9;
	Thu, 17 Sep 2026 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660773; cv=none; b=HVWsH2ll9gvlsyTwe+76Atfkv+j/CjFNrYXjgSmSNalfKP1WEvaqjsoVXehz4papkTx1H2NKjt3rRvUwo0Igcm5UZigew/bHnafJ7a0qSt33/JvsRgp1KKd9mAtd0ITz5CDGVBXIrbho8eA+lZfSXSumjWw6WSukT6HbgsHqWSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660773; c=relaxed/simple;
	bh=qO0gGcko0vNbgHe9PmSOodoCTfMWtzAPK/ywfyF7SsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZfP2dNplsoWCEfP8bHlqaRaQ2ONtZ/6YVXiyiVo3aZYcWu5goIJyy13DT+kKtkLSNZcMXtIFDzuu99qsAKI3onw6gA4HYEjYoPNsL6bMKlwPDATL47D/ALjRA4CyMf66AVpx0+92NYq0leZhzoqv6BAHoCIrcf6qTFosnm1oRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmC90Why; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmC90Why"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F24B1F000FF;
	Thu, 17 Sep 2026 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660771;
	bh=5QNJSSnW/9bfpaSjY2r43VVdVndTI4TrlNswkoyCyHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmC90Why8UtCXom68JvHl6tD/WfKrY6SAsCv0KGa8aBu2ySuOAcX0XrDNtjmBtaqB
	 vAL2snJkFMuQ/EjIm2f0r1PXXdYpwE/6GDeL4uuNkgVCdS882LBOPJ0/9irEfsbXUs
	 ROjVCHETu6hXDoCURflxLwLO0KI0d/EC0g0giLkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 665/733] xfs: fix reclaimed page accounting in xfs_buf_free
Date: Thu, 17 Sep 2026 16:16:13 +0100
Message-ID: <20260917151409.262789020@linuxfoundation.org>
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
@@ -108,7 +108,7 @@ xfs_buf_free(
 	ASSERT(list_empty(&bp->b_lru));
 
 	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
-		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
+		mm_account_reclaimed_pages(howmany(size, PAGE_SIZE));
 
 	if (is_vmalloc_addr(bp->b_addr))
 		vfree(bp->b_addr);


