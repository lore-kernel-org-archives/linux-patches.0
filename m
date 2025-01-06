Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397FFBA34;
	Mon,  6 Jan 2025 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179099; cv=none; b=SOP3hqVnts8g953I8xGvwjH1S8moBTppChCddQ+BE8n9ylWT+N7CFl0vwpa67AGXEJdZyrweIY4GyXu8GgC1bm6MfMHTp5RDcw/b13ZFI7ZaSqRinZRJYDn1qZ3YzYFJ0Dw3ZEqyhJ/8ldAhB6y58WWVRwVnwrCMMkcfqPx1qB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179099; c=relaxed/simple;
	bh=qDl9ms0F4w2tKOzOraDqnEJ7qwuqQnLfJIvKZeKOdLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNTcEgKM31FXsncsNIDXzDVH4SRgjO5M5hHpNx5OV7crT+kU5mhkN8jzm3ZSzCGpsTpt+zLwAhVMtiJz9B3LqwSGQ2k4Rlf5D2C65T4WMEKRLm6U+oFh0g5jiHf92g/Pmco9uoezG+cUz08awaqGzFsy+WHQuBoRM4Wx3UAq3v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sv8OLmjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sv8OLmjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AA9C4CED2;
	Mon,  6 Jan 2025 15:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179099;
	bh=qDl9ms0F4w2tKOzOraDqnEJ7qwuqQnLfJIvKZeKOdLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sv8OLmjhUVhLVp3GDaPgXoFsTOul5I/FFuF346dw2ihGzHcd4lborBV80pNkH1PAV
	 0GxmKKM2bqYxhp62sLsZzpbxlqmzXN1d1pWe42EykfdYPDL+RQhIaRr+K7pjFJAMdM
	 Kew9byxrZCDJhRIJpTKFD5/J8dhuCOs2T8Nw1Wwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 27/93] NFS/pnfs: Fix a live lock between recalled layouts and layoutget
Date: Mon,  6 Jan 2025 16:17:03 +0100
Message-ID: <20250106151129.730529105@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1165,7 +1165,7 @@ pnfs_prepare_layoutreturn(struct pnfs_la
 		enum pnfs_iomode *iomode)
 {
 	/* Serialise LAYOUTGET/LAYOUTRETURN */
-	if (atomic_read(&lo->plh_outstanding) != 0)
+	if (atomic_read(&lo->plh_outstanding) != 0 && lo->plh_return_seq == 0)
 		return false;
 	if (test_and_set_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags))
 		return false;


