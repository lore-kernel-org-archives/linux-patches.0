Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE28372B4B;
	Fri,  4 Sep 2026 05:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500582; cv=none; b=P10+GMAJYRb3wq7vNeIZ6KlrgLRw3kmSO90O4+j6F1ENU1pNcFwa6DKhLKrnBNPJR28upPuh5rw8yo9NcOjMhY824Kaj6Yoywl/Y0c/TK/FT05m/VxmeZfeQlU7IBrqnOCTi+nLnpT8RBZM9k1KusUxmXycsJ+a7dVAPZiABxhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500582; c=relaxed/simple;
	bh=8jlie4cRIB0hjcpUmSJ93rocpuO7k2nNp+xNPVSg4sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWXQ/9raVOmtjQU0+OgCJvrFL8WOeVy10QVUzN3uZY01HXmYhxht5DTxw8f83/oFCRfB6NgVZWfvmEN2rx2jHB2E3V0jg/+3PF1fpVm49zqKLcPz28tp1U6Ll5ue4Jo7Pef7N/Xml359fQPPR8id31U/Aaq6Ob0cF/WqOTEloi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvEOpmLs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvEOpmLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559181F00A3D;
	Fri,  4 Sep 2026 05:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500580;
	bh=oqL33Zc/1gSzLWA35MFPPXWfrBeagV1pT/exrteqFqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvEOpmLsebfr+QyO5rEiBa7AlKrX/RrZO9OQhmjOz4HFOzFOP8D8gkamjPYwvvq03
	 UR79Pa3AUCsuu5EFcmb1RtgPmO5iNoMEeMIQxoqNjvvPX2KlkgclVgvMRwuHylCBOP
	 hbG4Vj6NGL/MCeiCpWZ4wooFWdS5Cz8L6jdaaLt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Menninger <tmenninger@everpuredata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.18 106/552] pNFS: Fix EBUSY check in pnfs_layout_need_return
Date: Fri,  4 Sep 2026 06:54:23 +0200
Message-ID: <20260904045750.311927864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


