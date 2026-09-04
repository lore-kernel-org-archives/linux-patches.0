Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2841F3F9F2F;
	Fri,  4 Sep 2026 05:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498673; cv=none; b=ZdTQ/8QMOV3+XVJTSfq0zKNnMVCIC0e9nydUOhASCEDPooQp73+CtBm/Ylzta75YgtfMszSvGPnPt+Jt/31cAKCT2pHUnsXXR3oDHUgQ7myC4bT1NJOYCRZ6l9MhcZ8kyUKGKNuarlfQUzdjAhROfrvAsLD69/hnr64lhJVCOVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498673; c=relaxed/simple;
	bh=2FEO6Furku7b7+cRFWJ9PDQj1JUvBSaan4XGc5VEPxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dy44iNPJCIfEyCf5FQautBk7KO2V+d6MdzVnpFrlef2bEGBHG3z88p8D631RTi2faUDMoE2k/9RYMXsvAdjhhDnJyxyjdmCidVVA2dgSPCSVVBYGMHocxd3JsycgyuZ22pGG4IXk2BExCdIOgnOlDT3Jol6N/BdhsZQkxe8Pj2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+dzBWQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+dzBWQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA091F00A3F;
	Fri,  4 Sep 2026 05:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498672;
	bh=4ioRaornOt0M6ZHYZB4FNOk1ufEF39r8am3zLOs6rnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+dzBWQuC6iIXAe3IFnNP9gE0PLg7pvA8orj/FeM1F+gjaub458DzOYc/vW3+CNTZ
	 TF0aA4B+Dph0YD4AvKljIjlqgh+fLXgxz6Q/A05JbsILC5KEfGWVeWBloSN4P+tVgp
	 UCHo+ri0AL5OHONXSr393FZ0ptf9/7Qk6Nf3HfLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Menninger <tmenninger@everpuredata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 7.2 146/713] pNFS: Fix EBUSY check in pnfs_layout_need_return
Date: Fri,  4 Sep 2026 06:51:54 +0200
Message-ID: <20260904045807.100091839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -1389,7 +1389,7 @@ pnfs_layout_need_return(struct pnfs_layo
 		return false;
 	return pnfs_mark_layout_stateid_return(lo, &lo->plh_return_segs,
 					       lo->plh_return_iomode,
-					       lo->plh_return_seq) != EBUSY;
+					       lo->plh_return_seq) != -EBUSY;
 }
 
 static void pnfs_layoutreturn_before_put_layout_hdr(struct pnfs_layout_hdr *lo)


