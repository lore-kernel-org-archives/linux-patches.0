Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2192F32ED40;
	Mon, 17 Aug 2026 13:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973978; cv=none; b=jwH2BYVTsGpfzM/+PlG9eERik8c7fFN0zNY2vDqz0Fo43VU19mDOCQXPsXaGd9Y+Ufa/qDb6tjKnxE5wPHEsmvQY1EXDA4OBZ/dmO0ctPOtaQeHHPQlgiSUdpbGSdYUGm6bkbQGkMWnx4+7iHOeZpdGPqTqfwCP7dRbzRNiYH9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973978; c=relaxed/simple;
	bh=//4zCm/6MK/OJrxBdzgfTsiAg5X293DJMbwyBsza7/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJvgYy1K08uCX0rZE/8gu6jiyXyP73+GcjjS3L1+JxqnzDlSwPDZTG0LacnWkCA34qrGEdJVEeXj0c3MMyH+7uiyjacc/K47deyX6Bs9v99cDWK/QvrJ5NqIPkC1TXi8yKsu7mflMSYD35nsMqBtBx+g2q6h/NEmfeTsmHVUm1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrOcxMD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrOcxMD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B02C1F000E9;
	Mon, 17 Aug 2026 13:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973977;
	bh=XZZju3Fl8B8eVcJ3khpQk1D95pz2gV4Dk4u8Z09bB/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrOcxMD/r0tze7pAh4btF9IQY+KsnYQZCahqn5t3bn47ofWEe1ufFhULT/PXz0Buj
	 fj5wGsjfW+QrCsEPHUsgFPWDINczMGOz2R2HG7/w0QWXKeCQv6hiWAa6T59Qjx1hKX
	 x3xb0WdTLMMaIQd2qzGKEkLPvaEYsgOO4Rl37dPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 047/271] btrfs: lzo: add error message for invalid headers
Date: Mon, 17 Aug 2026 15:29:32 +0200
Message-ID: <20260817132538.667346239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 1cb15b153c636096740519f62040ec6dc3e50aef ]

Inside btrfs we always pair -EUCLEAN error with an error message to
indicate which data is corrupted.

However there are 3 cases inside lzo decompression where there is no
error message for corrupted headers.

Add those missing error messages to show exactly where the corruption
is.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 0fa78ef637de ("btrfs: lzo: reject inline extents without valid headers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/lzo.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 6e4aa22853aba..1531adb117d15 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -552,17 +552,26 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 	size_t max_segment_len = workspace_buf_length(fs_info);
 	int ret;
 
-	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2))
+	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2)) {
+		btrfs_err(fs_info, "invalid lzo header length, has %zu expect (%u, %zu)",
+			  srclen, LZO_LEN, max_segment_len + LZO_LEN * 2);
 		return -EUCLEAN;
+	}
 
 	in_len = get_unaligned_le32(data_in);
-	if (unlikely(in_len != srclen))
+	if (unlikely(in_len != srclen)) {
+		btrfs_err(fs_info, "invalid lzo header length, has %zu expect %zu",
+			  in_len, srclen);
 		return -EUCLEAN;
+	}
 	data_in += LZO_LEN;
 
 	in_len = get_unaligned_le32(data_in);
-	if (unlikely(in_len != srclen - LZO_LEN * 2))
+	if (unlikely(in_len != srclen - LZO_LEN * 2)) {
+		btrfs_err(fs_info, "invalid lzo segment length, has %zu expect %zu",
+			  in_len, srclen - LZO_LEN * 2);
 		return -EUCLEAN;
+	}
 	data_in += LZO_LEN;
 
 	out_len = sectorsize;
-- 
2.53.0



