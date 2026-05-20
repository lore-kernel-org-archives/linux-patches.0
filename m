Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3E933DEE5;
	Wed, 20 May 2026 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300003; cv=none; b=keIIL+uMO71xorZ6gOfMHJnDx7sczMFN9/gb1Q8UBr7FNu08+gkSatjV8GsZ8rhyanK8srPwR2rkfRa1aWnSrZHqRXFNapsf2Cr9PkBCfe9stxqF8GAUvp5cyNkBuQ0Nl4XQtUIJQBY+t5O2hhW7icifn7dK1iKMGvTifMJL6XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300003; c=relaxed/simple;
	bh=VOueD3MKeM8t5bnLz344AMMd+hR6TRhn+gaTEcDCWyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIMDd9ua4JHDAe9YDMIx+XIW5qG+sRXRU3WzyfsOQ1BW+ZobwwMgrJW4JTQCxfoHfapDHflV9KPSaRBVdcx7CFVPOLpetPgLN4+4/ssAhntfYUS9dEaHH0RP2yf6Pe6ExYGztlErgabZzyY17FjddflVqTj514lQR3po/b2sfGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhhdQrHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhhdQrHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1ED1F000E9;
	Wed, 20 May 2026 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300002;
	bh=eLk7cjpeV9lxIbHe7jVLxg3CoXWzkpSVZaVxNhqiwh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhhdQrHbGuZRvWhPuTwNsRiD7WR7bFw2/URt/Z4/yZQyVBbfVOrqnC54SsfaywyzO
	 301VbhouvrDTXvJuW0jQLcHkNfYmbBKSLOLyTMzh6hGRXfUXHzCz9gHnQ0bThb9JV5
	 TSA4RSkJ16/PQMxU3SzUPnukXS2fpDn2Yc9JXSVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/666] erofs: verify metadata accesses for file-backed mounts
Date: Wed, 20 May 2026 18:13:42 +0200
Message-ID: <20260520162111.476779194@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 307210c262a29f41d7177851295ea1703bd04175 ]

For file-backed mounts, metadata is fetched via the page cache of
backing inodes to avoid double caching and redundant copy ops out
of RO uptodate folios, which is used by Android APEXes, ComposeFS,
containerd.  However, rw_verify_area() was missing prior to
metadata accesses.

Similar to vfs_iocb_iter_read(), fix this by:
 - Enabling fanotify pre-content hooks on metadata accesses;
 - security_file_permission() for security modules.

Verified that fanotify pre-content hooks now works correctly.

Fixes: fb176750266a ("erofs: add file-backed mount support")
Acked-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Chunhai Guo <guochunhai@vivo.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 91182d5e3a66c..192c7ed885acd 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -30,6 +30,20 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset,
 {
 	pgoff_t index = offset >> PAGE_SHIFT;
 	struct folio *folio = NULL;
+	loff_t fpos;
+	int err;
+
+	/*
+	 * Metadata access for file-backed mounts reuses page cache of backing
+	 * fs inodes (only folio data will be needed) to prevent double caching.
+	 * However, the data access range must be verified here in advance.
+	 */
+	if (buf->file) {
+		fpos = index << PAGE_SHIFT;
+		err = rw_verify_area(READ, buf->file, &fpos, PAGE_SIZE);
+		if (err < 0)
+			return ERR_PTR(err);
+	}
 
 	if (buf->page) {
 		folio = page_folio(buf->page);
-- 
2.53.0



