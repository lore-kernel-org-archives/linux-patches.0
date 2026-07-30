Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EA643F0B5;
	Thu, 30 Jul 2026 14:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423476; cv=none; b=t7SYi3f7BWMvWtT42q1anMIWFaPLQzBSWne7bsXFXjAUvMbXyIguOChhZa+9NS/1znXlRR5m2dqO5dYPcW0xOGCh/JaksCPvg5tYCoch4xuPj3lYkP0FaFm17HbaYVPo1HufZlnoeyEIIc3v2H2EftHBDuI3BbTKonZU12HB2GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423476; c=relaxed/simple;
	bh=zgk2SGIE+Rs45MurQF/lbfe0Z+SM2diDLCK5hoTk9f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AApyFnObgAJJc/1uS/FlKnC4OiNquOfoZuXFvdv1VZSaAp7r9Igm6ROirZArwNdul/jYuJP9eI5WBuzfsX74DyKuiH2vpyC3x3ygZ5Ag2po/9DL4cnweubv6vPkX01Zfwv8EKENn5UO4E9ZMXx05YihgbzGSBmJgc0FVCnFLDWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rohUhbpD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rohUhbpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07921F000E9;
	Thu, 30 Jul 2026 14:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423475;
	bh=hssXK85lZPgmf4h1kHkPMZn+e0FtQee82GGt6qKB8GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rohUhbpDZBdxoZ9m40FkCUNlcAsiqbC4v8prt3DlYdnmRsygUrmR16elF96ZkKIrq
	 0RQwrAGNhttDSPz7TwAuTxF0qyQa5EVev8dtYLFlA2gAxX6M4T34GMVbYlZ5sMy+4M
	 Jh42HNT1oarYZUNzqxQbGBXsY+G10Iggugo2Ly6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Junxi Qian <qjx1298677004@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/675] fuse: fix writeback array overflow when max_pages is one
Date: Thu, 30 Jul 2026 16:06:00 +0200
Message-ID: <20260730141445.760803706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Junxi Qian <qjx1298677004@gmail.com>

[ Upstream commit c3880a7b10e487e033dc6f388bda118436566f7a ]

fuse_iomap_writeback_range() appends one folio pointer and one
fuse_folio_desc for every dirty range that is merged into the current
writeback request.  The merge decision checks the byte budget against
fc->max_pages and fc->max_write, but it does not check whether the folio
and descriptor arrays still have another free slot.

This is not sufficient for fuseblk, where the filesystem block size can
be smaller than PAGE_SIZE.  With writeback cache enabled and max_pages
negotiated as one, contiguous sub-page dirty ranges can fit within the
byte budget while spanning more than one folio.  The next append can then
write past the one-slot folios and descs arrays.

Split the request when the number of already attached folios has reached
fc->max_pages.  This keeps the folio/descriptor slot accounting in sync
with the send decision.

Fixes: ef7e7cbb323f ("fuse: use iomap for writeback")
Cc: stable@vger.kernel.org
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Link: https://patch.msgid.link/20260506122415.205340-1-qjx1298677004@gmail.com
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 79d1b502e73195..585dd90361b654 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2140,7 +2140,10 @@ static bool fuse_writepage_need_send(struct fuse_conn *fc, loff_t pos,
 
 	WARN_ON(!ap->num_folios);
 
-	/* Reached max pages */
+	/* Reached max pages or max folio slots */
+	if (ap->num_folios >= fc->max_pages)
+		return true;
+
 	if ((bytes + PAGE_SIZE - 1) >> PAGE_SHIFT > fc->max_pages)
 		return true;
 
-- 
2.53.0



