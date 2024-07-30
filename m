Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF9A1A76A1;
	Tue, 30 Jul 2024 17:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360284; cv=none; b=sUH2jyhXViaOtzpad5/I6L7vRSHgrkTLMgwr7DpvBcmzNyUiIiQNle1eBhtbBXmWwEOJ6IGjj8cnyVVdszrp+19d8MJTGApqiLUCR1/V5sbLkNnGp9EzBaajni5CRydd8yIU0oU4Ev41QSrL5RURFWBiBd3+ZXSP8fzhrIW6oTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360284; c=relaxed/simple;
	bh=6edjGVvVG/DyUtvoqodck3o+OWKJ2ajGYueAU7ERVpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4ejGI8Lc/EIPJwzdFiQUFSf3LpwaBbhjJqJaJJ1Tlg22Omwr/cQmhK1a+BZAVSpv1Hpb0Rkir7ooIG+vkVrFWkECLnep7g8XWC75n6KJcyEX15b0RJ6D7vHWVgo1i97bbAQsb6U+/SBflt8wyIfzIvmBR7BxYlMvcJcRnp4J1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wg3mS6Ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wg3mS6Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDB9C32782;
	Tue, 30 Jul 2024 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360284;
	bh=6edjGVvVG/DyUtvoqodck3o+OWKJ2ajGYueAU7ERVpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wg3mS6UilX0Xn6hC/Im6qEMQnDBT209hw8GaNv1iHVxVGLNefpgPj0rhqz/e0yRkw
	 WiI0aPt6iQ1UBCGMsUNdHMzzfhsL5Yd6gs3e4Sj8WqXEOUda2wErFt6bvmJ/6WIzgW
	 okuhGRJpKRjcPEWSzYqm8Dx/uj+GAa02T2Balb88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <v-songbaohua@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.10 652/809] f2fs: fix to force buffered IO on inline_data inode
Date: Tue, 30 Jul 2024 17:48:48 +0200
Message-ID: <20240730151750.630494801@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 5c8764f8679e659c5cb295af7d32279002d13735 upstream.

It will return all zero data when DIO reading from inline_data inode, it
is because f2fs_iomap_begin() assign iomap->type w/ IOMAP_HOLE incorrectly
for this case.

We can let iomap framework handle inline data via assigning iomap->type
and iomap->inline_data correctly, however, it will be a little bit
complicated when handling race case in between direct IO and buffered IO.

So, let's force to use buffered IO to fix this issue.

Cc: stable@vger.kernel.org
Reported-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -825,6 +825,8 @@ static bool f2fs_force_buffered_io(struc
 		return true;
 	if (f2fs_compressed_file(inode))
 		return true;
+	if (f2fs_has_inline_data(inode))
+		return true;
 
 	/* disallow direct IO if any of devices has unaligned blksize */
 	if (f2fs_is_multi_device(sbi) && !sbi->aligned_blksize)


