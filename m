Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BEC405C3F;
	Fri,  4 Sep 2026 06:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502063; cv=none; b=bi/9B7j0axHNdN9vuM8f+E+3WkkogcNwbuzVTuy9h0v+kT31iDIPbQABrJhIijKQmwRMULuc4LKjpRkgkhWWplLqfwPRUmwtTL1FCzOpiAAXRHos2X1tFsidpseSeeEYRjxlnuWF9HAhIF04icpkxFFe+QIO9d6fr7uoNU2bcqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502063; c=relaxed/simple;
	bh=+/Ntl2X1YrpSeHkH2sNEC6K+vbSOyUnJ2mOqvr+Phxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhnyvdHWIqEvVlsipc9kphmEGuJj9kYh4gQZbkM4YgwS8/Ud6wapxqVYbZUrbWG6+IgQaPVUzWu11jnMxmYFdk4wkzc/N/1a0G91ZZZ4ZXV5PiqBX/vamuysXeN72LADJdSI5pkDjxHdt/8MjWpsa/s/gcltoPiB/haQBaUGzeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v81LTNWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v81LTNWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC8F1F00A3D;
	Fri,  4 Sep 2026 06:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502062;
	bh=RTSsqVpQRsJuLnOe2E3z9n8K67f/v1INUBf1knYyYWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v81LTNWRNlTQpswYn5ycX/wCsffP6u6eMAiF4hd8X8Ki4uisMAlVywrJoxzflMwZo
	 Gw4PhUP1J1vPovlbJsGhxbvk3EVemb+SVRp52OaJqMo2NN8jeTashRc4MPeT9af0wz
	 F/I8jSx/vYhVQ8q4CG9VDp+Oh2ix1984VA/3Y+Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Menninger <tmenninger@everpuredata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.12 075/403] pNFS: Fix EBUSY check in pnfs_layout_need_return
Date: Fri,  4 Sep 2026 06:57:58 +0200
Message-ID: <20260904045736.540021819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Tim Menninger <tmenninger@everpuredata.com>

commit 20358201777496fd0bb7b4336fcb4d3fc13cad28 upstream.

Commit 41d0a8ead9720 ("NFSv4/pnfs: Add support for the
PNFS_LAYOUT_FILE_BULK_RETURN flag") replaced
pnfs_layout_segments_returnable() in pnfs_layout_need_return() with a
direct call to pnfs_mark_layout_stateid_return().

The old helper checked the return value against -EBUSY, but the
replacement compares against EBUSY. Since
pnfs_mark_layout_stateid_return() returns negative errno values, the
-EBUSY case is never detected.

Fix the comparison in pnfs_layout_need_return() to check against -EBUSY.

Fixes: 41d0a8ead9720 ("NFSv4/pnfs: Add support for the PNFS_LAYOUT_FILE_BULK_RETURN flag")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Menninger <tmenninger@everpuredata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1402,7 +1402,7 @@ pnfs_layout_need_return(struct pnfs_layo
 		return false;
 	return pnfs_mark_layout_stateid_return(lo, &lo->plh_return_segs,
 					       lo->plh_return_iomode,
-					       lo->plh_return_seq) != EBUSY;
+					       lo->plh_return_seq) != -EBUSY;
 }
 
 static void pnfs_layoutreturn_before_put_layout_hdr(struct pnfs_layout_hdr *lo)


