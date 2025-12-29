Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051539460;
	Mon, 29 Dec 2025 16:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025370; cv=none; b=gPL2wU6TRX1V2Dvx2UXhKXyK2rOQ2/eBLSP757qei3a9kQduf/jzJ0ChTAYDyE3K4Yw1+GqqxME6If7xqZJFCcwE+J9UVCc0RP/mSlevxgYdHUx2/mCAEEO5JwfnrY8B7X7tVa9ThcTqCS3Mm4szZ+lwiOjvP0UB32DDUcar0Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025370; c=relaxed/simple;
	bh=vvnGmLg28lIKID5LxFCJNzGf2CPxT4es6g3aK5A0V40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lc1wpJXVXkL9+G+E2DbyQx7uohuieHwL443fNlI2d8i3n7dRcCenGm/uH5JmDsWY7+lrhXEYy2bUKbN7JPNgXnjfO1Ae+A+ix9OtlWxgu8F8NbkFJVdMTcQM6crEcKiGxGTnxFES6rQjWBBNHuFejxakuY49Fun4VLtgyuj0Zvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcnUteZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcnUteZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83380C4CEF7;
	Mon, 29 Dec 2025 16:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025369;
	bh=vvnGmLg28lIKID5LxFCJNzGf2CPxT4es6g3aK5A0V40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcnUteZ/xQmwpmZ1X1FLsg6NkbR/DLmyiR/AApmN/t8ujbHigeMIbbQFQD1wV+4z2
	 WGncsWOCMoGjtM5mFpd6G4yM139Dev6F0xi9mJuLExT3vqyQn6A0H2uSGL90jNTVMH
	 b4lV7ZmxCbYnA2mSa1LCjAGHZj64PNcz0WMbmjwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 189/430] fuse: Always flush the page cache before FOPEN_DIRECT_IO write
Date: Mon, 29 Dec 2025 17:09:51 +0100
Message-ID: <20251229160731.312163001@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Bernd Schubert <bschubert@ddn.com>

[ Upstream commit 1ce120dcefc056ce8af2486cebbb77a458aad4c3 ]

This was done as condition on direct_io_allow_mmap, but I believe
this is not right, as a file might be open two times - once with
write-back enabled another time with FOPEN_DIRECT_IO.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f1ef77a0be05..c5c82b380791 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1607,7 +1607,7 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *iter,
 	if (!ia)
 		return -ENOMEM;
 
-	if (fopen_direct_io && fc->direct_io_allow_mmap) {
+	if (fopen_direct_io) {
 		res = filemap_write_and_wait_range(mapping, pos, pos + count - 1);
 		if (res) {
 			fuse_io_free(ia);
-- 
2.51.0



