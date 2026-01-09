Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C25432F748;
	Fri,  9 Jan 2026 12:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960505; cv=none; b=LYHTo/3bGOZWq2OGt1B52/hp5QjMidpGAqimwuu1X+Mh2abdNpamVMrrfbWSHYA4EFZRkn1EbZ71FEN4JYnXuNgzvxGAAYTbuPOBLbjhp1Be5Ko4yPOx8m96nKJLjGs40i+svUZkWQhfI3sOXUIBNRbrPw4eWaG8qWtKI0Ganm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960505; c=relaxed/simple;
	bh=qrB7E1zu57GOV34AxW+lFnMnGguO7PUCT8WdouB049k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWY6ai6qw8dztsunVTJkWeIY06iOCFAyCbJmrpP9JB3/FSd1av12AubCubpFeUdAtEKyC5siliZP1UpyoZb1TgQbbLN+mCE9MtYE96rHPm38PNMnvEotMpoAvSvu4eWQrzcgl3ho3MuyRi4bhhHTQPgpcVuo9VWtwcF44yQZTZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syJFGkAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syJFGkAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AF8C4CEF1;
	Fri,  9 Jan 2026 12:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960505;
	bh=qrB7E1zu57GOV34AxW+lFnMnGguO7PUCT8WdouB049k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=syJFGkAbFk4OCHuR+ag+O1kGUfbIob2LAuXYALvVX3hTWcU5z7WyyPyinfCnggE32
	 U/aBYurDoRcAzLVG+sdGdfA6znipRdlzLsym+BB/qzU0Rvef/4KGrpk27P+DVDwV31
	 kwiPdgpkV8t3ICjhMYSWXMAeUwO9QCiRVtudb9O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 395/737] fuse: Invalidate the page cache after FOPEN_DIRECT_IO write
Date: Fri,  9 Jan 2026 12:38:54 +0100
Message-ID: <20260109112148.858008343@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bschubert@ddn.com>

[ Upstream commit b359af8275a982a458e8df6c6beab1415be1f795 ]

generic_file_direct_write() also does this and has a large
comment about.

Reproducer here is xfstest's generic/209, which is exactly to
have competing DIO write and cached IO read.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 1dd9ef5398d7..ae62f47ef004 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1537,6 +1537,15 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *iter,
 	if (res > 0)
 		*ppos = pos;
 
+	if (res > 0 && write && fopen_direct_io) {
+		/*
+		 * As in generic_file_direct_write(), invalidate after the
+		 * write, to invalidate read-ahead cache that may have competed
+		 * with the write.
+		 */
+		invalidate_inode_pages2_range(mapping, idx_from, idx_to);
+	}
+
 	return res > 0 ? res : err;
 }
 EXPORT_SYMBOL_GPL(fuse_direct_io);
-- 
2.51.0



