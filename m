Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E249221FAC;
	Tue, 12 Aug 2025 17:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020883; cv=none; b=hRqBb1R2ekEMVNVtK02+pFzqmLusXYgtU0zU6M7hsKq/qrOOStBpcm8Bw2mnjTjYXsXbuea58t7h3EeVjawHySQldZsJayO6Fuv4LRL+J4+cYbteNykictqoCpUZNajPDRo9wPtJ2cBZQfWxsxbYubns6a84L4ayWLFR3k2qobo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020883; c=relaxed/simple;
	bh=7tidhfcmoeoPyPNCJ18b+b4uc0cRwCGgeURsEqmlUa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGAxg7LDeckURC0lffbEF7KBLVITm8SfQ+J+F4CESHRCteuZSPZ2Gc/f5QSOnnC0bBfYvZHnxX5Mjxa4GthDrMRazBtX+JXMWd2bAoLGI62Z7pOjcT0efPq1y+OnDR9hBFYwSrhqvL0MK4LT8+D3UbuT3PcugEP9N3erSlIk2zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLWcPArV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLWcPArV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F12C4CEF0;
	Tue, 12 Aug 2025 17:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020883;
	bh=7tidhfcmoeoPyPNCJ18b+b4uc0cRwCGgeURsEqmlUa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLWcPArVDAbV7WLbVLNy3VRgxGAdwQbxuXBswVeTC5mwWSR/xhIZyZScHzm4PqQ4n
	 4jPnW/40Rxf8emPsroCLOdBeauxep0maxbDZCpiHyj+3i5K0XugJlyA7Z8Kk0JBlWT
	 Z3BPmelzSK4ps2rsvml2TuHZj1BMtOur/8wHgU5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/262] hfs: make splice write available again
Date: Tue, 12 Aug 2025 19:26:39 +0200
Message-ID: <20250812172953.463921841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 4c831f30475a222046ded25560c3810117a6cff6 ]

Since 5.10, splice() or sendfile() return EINVAL. This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250529140033.2296791-2-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 61ed76d10392..6a89f22d8967 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -697,6 +697,7 @@ static const struct file_operations hfs_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= filemap_splice_read,
+	.splice_write	= iter_file_splice_write,
 	.fsync		= hfs_file_fsync,
 	.open		= hfs_file_open,
 	.release	= hfs_file_release,
-- 
2.39.5



