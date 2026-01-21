Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279C33559EE;
	Wed, 21 Jan 2026 18:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019998; cv=none; b=OvdTRP3tTJ4j/7E2r7qtkHnPCLWm9RJqG4T5wHb26laagYcvITAwi4LcjixhfFGFUsrPwHa/vBYXzYhx2F0TKP8AZfHxcSyaADtAxDguYisemsjy3OHblp7aGlkwC+b6VmI5PU4HcQ9LrO83rkHcrA5YGPhqVfYb9g37BwdhDoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019998; c=relaxed/simple;
	bh=kB8tY/Y9/wUkgFHtlE3dt2gID8S3uPuG7xWBaB+VdNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cK+4hFB4+Pt4suKLu0LQM+cOx50eFOigSqiwT7IVejJsDHsbXqKPe1B6g53hQd/8dJCEvHSS3p9TjC8Ejs2sCNGqoo7p8tw9Zmzmh09QKLb/XlQ6Re532a8eOvt2pi1fdZgvPmAJlTBDRlr9i9H8Q3VxLHUdx/hHRmNX2VxeGSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASi7XMnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASi7XMnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BA0C4CEF1;
	Wed, 21 Jan 2026 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019998;
	bh=kB8tY/Y9/wUkgFHtlE3dt2gID8S3uPuG7xWBaB+VdNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASi7XMnhPry71g2UbD4ALQhwX+qx4SIqqCEFpkoqj8pMdQ0Syqa+hJDEko0tl04za
	 M0TTfmDF52U3nI47nKSn5oXsUd0uNtxBr+JeJi7ObriCX77FDvf5Yr9TCChQWfaCsu
	 8a6IMDmDp3d1R5xBjb6qefI971o+IfCJJiQ74Y6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.18 004/198] Revert "gfs2: Fix use of bio_chain"
Date: Wed, 21 Jan 2026 19:13:52 +0100
Message-ID: <20260121181418.701421776@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 469d71512d135907bf5ea0972dfab8c420f57848 upstream.

This reverts commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941.

That commit incorrectly assumed that the bio_chain() arguments were
swapped in gfs2.  However, gfs2 intentionally constructs bio chains so
that the first bio's bi_end_io callback is invoked when all bios in the
chain have completed, unlike bio chains where the last bio's callback is
invoked.

Fixes: 8a157e0a0aa5 ("gfs2: Fix use of bio_chain")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/lops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -487,7 +487,7 @@ static struct bio *gfs2_chain_bio(struct
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(prev, new);
+	bio_chain(new, prev);
 	submit_bio(prev);
 	return new;
 }


