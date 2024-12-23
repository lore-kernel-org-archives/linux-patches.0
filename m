Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05531B3943;
	Mon, 23 Dec 2024 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970079; cv=none; b=FjrFOmhC5vy/Mp4NUKHjyT2UJA+0AgX4CRxRl22LYrFnGkxjMm0HPCMlcLGIythFp2DvFBeTtsSTeRRWFXoFKT6hahu+0cOfjyqniWTTkyTovy+G2sBA1y7Ttk2K560838mrBlKU4aPeaursHU2PYnoJUJhg3aUbUCmaAE7kTPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970079; c=relaxed/simple;
	bh=4u0pgSurh8SPjCMiS3+ocJr+rEK+R6UjREaj39scb8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzwHwVA4chhawdFRQ21F3+A42hLWfXJ6FPfsuMzozCOOth/Dow39tc6+Ukl4KC7/0jdtcRduP4vBKWQ2jnMqGCegBlQoAqYCkUqdJjfGnEVpFCMHrQ3c/1U5ciWbwhF+9fVBLIdXhqI2X2xm2fBbwk4C3SSUVDR/jj1drFedbIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqIifsAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqIifsAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4CFC4CED3;
	Mon, 23 Dec 2024 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970079;
	bh=4u0pgSurh8SPjCMiS3+ocJr+rEK+R6UjREaj39scb8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqIifsAnL1KRN0MAR934f82Ilou7c64Kvo6N1jfKKQSU3E4JIFXS0tghJ0nrg4psV
	 lK9wz2zhaCoXHeGxfXlm4PZ4w0YpaWMUrNK5UhHqQVZdnbVAE4CWseGHtlpHEbWEjc
	 W2cuAaNBVoUiIOVK5OG5A7VUWr+UALUPazIhwwzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.12 138/160] NFS/pnfs: Fix a live lock between recalled layouts and layoutget
Date: Mon, 23 Dec 2024 16:59:09 +0100
Message-ID: <20241223155414.130334920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 62e2a47ceab8f3f7d2e3f0e03fdd1c5e0059fd8b upstream.

When the server is recalling a layout, we should ignore the count of
outstanding layoutget calls, since the server is expected to return
either NFS4ERR_RECALLCONFLICT or NFS4ERR_RETURNCONFLICT for as long as
the recall is outstanding.
Currently, we may end up livelocking, causing the layout to eventually
be forcibly revoked.

Fixes: bf0291dd2267 ("pNFS: Ensure LAYOUTGET and LAYOUTRETURN are properly serialised")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1308,7 +1308,7 @@ pnfs_prepare_layoutreturn(struct pnfs_la
 		enum pnfs_iomode *iomode)
 {
 	/* Serialise LAYOUTGET/LAYOUTRETURN */
-	if (atomic_read(&lo->plh_outstanding) != 0)
+	if (atomic_read(&lo->plh_outstanding) != 0 && lo->plh_return_seq == 0)
 		return false;
 	if (test_and_set_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags))
 		return false;


