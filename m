Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BF834EF11;
	Tue,  6 Jan 2026 17:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720088; cv=none; b=bwBfZtWtx/GrjDdwAR7EFB/C32fQHRNgIzVd+p7XHeVXISlo2nYkTOYOIHCHhxDZJNNccPLX+q75W3I7GBxuT9kGOOs4Yhsnj2G4rlMZub52C9V29vSgeBE6aXIbYeeMs8WAsX5zWtwKCQ5N4TiXgFnAv0gbaf70U8lEXf6nnk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720088; c=relaxed/simple;
	bh=dd6+9r/3EufCPWDAfCUPm9kkBsjjEzoWl6dj38G3tAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgKwhysZGeHvFnrxs4rb/X5Kpk78toaFzcv6SHg35KtWczTKJNp1MA55wd+cr80zXpr3OSUU5RrgrG+wWFMx+q5vZkp8KLaqZjHc+qCuhz4oLDVZJLXWu+LnJNx8xO/yw7Xkqps9kjKKtAq2+SIfeD5FmLMAXVA3zhUdJEofWgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpTGaB8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpTGaB8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631B2C2BC9E;
	Tue,  6 Jan 2026 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720087;
	bh=dd6+9r/3EufCPWDAfCUPm9kkBsjjEzoWl6dj38G3tAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpTGaB8bYeXIc5+ej2x4ohZz4eG7NU1xUhYgzq+rx5pDw1/j0fsDLzF/Y0aCJZeAN
	 jW+EerigXKk0OZDFl3O23yin20Sg1KqDeZNxTrMcSAa92e3MtzXDhExhIbMN3qyY//
	 OiUNo+N2O8iisnRygtF/hBzf3VHI7xAXXtLKeZLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/567] fuse: Always flush the page cache before FOPEN_DIRECT_IO write
Date: Tue,  6 Jan 2026 17:58:32 +0100
Message-ID: <20260106170456.137807784@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index a8218a3bc0b4..ec1b235df91d 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1582,7 +1582,7 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *iter,
 	if (!ia)
 		return -ENOMEM;
 
-	if (fopen_direct_io && fc->direct_io_allow_mmap) {
+	if (fopen_direct_io) {
 		res = filemap_write_and_wait_range(mapping, pos, pos + count - 1);
 		if (res) {
 			fuse_io_free(ia);
-- 
2.51.0



