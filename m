Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740E538F658;
	Thu, 17 Sep 2026 18:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671418; cv=none; b=moDryv94C82nLLkLLf4moloLKlb1LudsFyhS1nsGiWuLV3xvPeZ+HKQLO7WXTfBqJtbEx9wINEU3jqvl/eJ2KRoOwvH7rSov+fMbM7qxXr0OHDJIHlZH2kT6WtMr7exJnaPcd5JC1I/lK/NQZ0aH0NsaVVqvtRw48hrGHEKCScA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671418; c=relaxed/simple;
	bh=mVsueqEJpouYfRrRgfDrHsWSdirEB5pyln9UtVYhqw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8vxR8HMFy0HR+O3C4ZAUKhU4hCaX4IP/+iML/9qMFdI9vPtyJ98K/fwV2z0dCZmLv+jqZlMN59nzdF8VW49a7SRoIgWdT8yvt0TQv+UeSXSrgoptZDffFqVZA/2qdxEJXMxvlw1cd71l6PjD2QI/XPTx+bgnGv1DUJAe3oROBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXJ67Ee9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXJ67Ee9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F021F000FF;
	Thu, 17 Sep 2026 18:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671417;
	bh=elnJlpizr7PHcJ+NtqUhpuGN6Km92um8Zt6fGgavmyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXJ67Ee9vG0AtIa1mkoucscShVCMAKA3ocvzpDqVEh5EIwBhDGFQMhScgNvcmA0Tc
	 KupwVXdKkqrI44gqxRfj6hfYjs8JzTZfIkIzMl/wKUA5PfSqoXuHvnPXlHcVODOEYQ
	 hOPMCAaF/QFq+I955tlHbANMI4KaGrBtSS+mIby8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0920/1102] xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent
Date: Thu, 17 Sep 2026 16:14:23 +0100
Message-ID: <20260917151603.727827852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit b71ae66863e4320a3b7313b53bb4d65f1718d58b upstream.

LOLLM points out that xfs_xmi_item_recover_intent doesn't actually
restore the isize1 and isize2 fields that were recovered from an
unfinished exchmaps log intent item.  Instead, xfs_exchmaps_init_intent
sets the wrong isize values from the recovered inodes, with the result
that the file sizes are not set correctly when item recovery finishes.
Fix this by restoring isize[12] from the log item.

Cc: stable@vger.kernel.org # v6.10
Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file mapping exchanges")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_exchmaps_item.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -347,7 +347,17 @@ xfs_xmi_validate(
 	if (!xfs_verify_fileext(mp, xlf->xmi_startoff1, xlf->xmi_blockcount))
 		return false;
 
-	return xfs_verify_fileext(mp, xlf->xmi_startoff2, xlf->xmi_blockcount);
+	if (!xfs_verify_fileext(mp, xlf->xmi_startoff2, xlf->xmi_blockcount))
+		return false;
+
+	if (xlf->xmi_flags & XFS_EXCHMAPS_SET_SIZES) {
+		if ((int64_t)xlf->xmi_isize1 < 0)
+			return false;
+		if ((int64_t)xlf->xmi_isize2 < 0)
+			return false;
+	}
+
+	return true;
 }
 
 /*
@@ -406,6 +416,13 @@ xfs_xmi_item_recover_intent(
 	*ipp1 = ip1;
 	*ipp2 = ip2;
 	xmi = xfs_exchmaps_init_intent(req);
+
+	/* Restore intended file sizes from recovered logged item */
+	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
+		xmi->xmi_isize1 = xlf->xmi_isize1;
+		xmi->xmi_isize2 = xlf->xmi_isize2;
+	}
+
 	xfs_defer_add_item(dfp, &xmi->xmi_list);
 	return xmi;
 


