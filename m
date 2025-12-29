Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BFA3321CA;
	Mon, 29 Dec 2025 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025837; cv=none; b=noIF14B5DqwwKxU6QkDqDDxHYZANr8yGgQeC7sEJ34zlzXYVB3ANNao0A0jt3ykyTTx5tI5F3kXD8iCG++j6kAJAU1QUFsK8dVb4TzJn575JTHnLjAYOlH4Bcvb8RkxLCGCASkyegSZvlXFEXkKFMOlq0YDuMSkliHd7G0ReqMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025837; c=relaxed/simple;
	bh=Kj2p07vfCbiYeBRMmTTJ9xanA4olI4QGT4g0cGQX8S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uau9wkS1NPxdcj7RH9CaGnobVFG58CmgkWZfUbQGfpKDfhTTc1+ehVdPiuBBHEq6ATxFobDch/Xd5NnZDO8ky/OkwP5u/u7TWAqmG/UcHEXpGfxU+bxDF8b3pH4zJr94T2FA4nr5LBj0t+l3uXUFYJF7ytusrto75O9/VNk+wXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKExWdTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKExWdTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36CAC4CEF7;
	Mon, 29 Dec 2025 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025837;
	bh=Kj2p07vfCbiYeBRMmTTJ9xanA4olI4QGT4g0cGQX8S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKExWdTbmxekv1VR7weKkx4Itt1db2kltRB4tmy85cBRWmKi82PeK9yh9rAQeIS3l
	 ZjLnOrKvI1ryWr8ILk20HoTJarRRq7nnNBnLhkGREb/qIoBSqECkYxn/fkYGJyd1v9
	 Eo3DqFmm7zuM6GEW+WeXSm5fLZ41mnp2cHZA2Z+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 355/430] xfs: fix stupid compiler warning
Date: Mon, 29 Dec 2025 17:12:37 +0100
Message-ID: <20251229160737.391433537@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f06725052098d7b1133ac3846d693c383dc427a2 upstream.

gcc 14.2 warns about:

xfs_attr_item.c: In function ‘xfs_attr_recover_work’:
xfs_attr_item.c:785:9: warning: ‘ip’ may be used uninitialized [-Wmaybe-uninitialized]
  785 |         xfs_trans_ijoin(tp, ip, 0);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
xfs_attr_item.c:740:42: note: ‘ip’ was declared here
  740 |         struct xfs_inode                *ip;
      |                                          ^~

I think this is bogus since xfs_attri_recover_work either returns a real
pointer having initialized ip or an ERR_PTR having not touched it, but
the tools are smarter than me so let's just null-init the variable
anyway.

Cc: stable@vger.kernel.org # v6.8
Fixes: e70fb328d52772 ("xfs: recreate work items when recovering intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -737,7 +737,7 @@ xfs_attr_recover_work(
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
 	struct xfs_attr_intent		*attr;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
-	struct xfs_inode		*ip;
+	struct xfs_inode		*ip = NULL;
 	struct xfs_da_args		*args;
 	struct xfs_trans		*tp;
 	struct xfs_trans_res		resv;


