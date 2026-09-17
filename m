Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4D04E73D5;
	Thu, 17 Sep 2026 15:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660726; cv=none; b=mUB68HojwR7g4bujBeWGPEK1IQmXjHtoFZqKnVZZP6Qog0rgq1Eplf0dlHfbKGSG3zUz8E4WimjQHXWNoN+5XMXTcFE2YvdPo0GIhT4U0tkrDufu/zY8ZwUMeUuvHZrk+IQkm44Q66n4Sjv/NQ15CT7P1aLAUlIjmldLlpgk4Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660726; c=relaxed/simple;
	bh=UxuB6Axo7WYJMUsK0qHZpZRlgLoVzRLzJgNyrPdA8C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnLnqIglAqQpWvnrqsx3m859/8ytLrTuawhYzgHAtJlWwO2FFT16XhwGYvURu+oHAkPCfn6/s+Begf8MnTWa/NzuneR1mgeF59+xyHPaG0lPJO2kmnofo1BzP3XpS3t6RclqTfWBhO9oImAKEhzJ2nQ6F9XLXbkvYYkPFIcwA8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGVyoCBX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGVyoCBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68B81F000FF;
	Thu, 17 Sep 2026 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660724;
	bh=mc3FpkHT//HjumOIF51u/6giytIwcQAZnCwNq6l4eWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGVyoCBXoYhU3j92QBo+PFGPATMMfyqv+bnzFlk2bAFeDqVacpaIDekLIbkBF8Ksq
	 4/SfPBGrYxqe8Uu5S68NglIYfYCRCI8brBFZLjK8t+W1vZUaz4LUmTtDkd/M5ep7qz
	 nbiwi642fIQR4ZorfKtKol8bt0XZ1DHORSwa1Zx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 687/733] xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent
Date: Thu, 17 Sep 2026 16:16:35 +0100
Message-ID: <20260917151409.916218222@linuxfoundation.org>
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
@@ -344,7 +344,17 @@ xfs_xmi_validate(
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
@@ -403,6 +413,13 @@ xfs_xmi_item_recover_intent(
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
 


