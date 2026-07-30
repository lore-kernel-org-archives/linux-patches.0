Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68784442134;
	Thu, 30 Jul 2026 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425670; cv=none; b=Ms+iRv2Qb19ESMIOTrScYKRGS0zR4KA0IHFlOheuVdPVmCqokELYMTovgDIIAbBR8u6/p1Kk51F5HF47JX6AsaquHs6Frix+PvJO1dFOiThp0S5DlWlg3FgGAFSXJe84hJjZtMyZZhYlJoiOdOULWaWeWKECWB9H3e06wDHIGHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425670; c=relaxed/simple;
	bh=x6+TNkT+mXkSSqLOSIOwgdf2KXeYTnnm9ImVQyrOYeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVvV7gk9HN1+V31qfSjQUVYDyP6OJQEWOAYcVa+P3CWf2WYY+eIiJxHCLxyH+m5dhMm30r3FiuTxLgq69L7x0a8V4NqfZ7szZG0d84/Zg173koQs7c7X1b+OGa2DX3k9c3B9/nOF/rhEb0iDybuU5ThpxLJylAEy0EALKY1tOGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U67a+swv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U67a+swv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FE51F000E9;
	Thu, 30 Jul 2026 15:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425669;
	bh=eXAeEyk9MCz0/YbGaISe4XxeEEOkLGDqCRqODFH++uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U67a+swv1bYJOIDaS9zjFXOtriwIVMgcU2flu1f7C5BdanjUT4z3dBBZ9/mZQdR9a
	 0EQ9vtbClz4F2gUNr0s3AbXCybLDTJJj0iU2ucZiy0xsEYoF9mF1Sku6Q39TUo4OZl
	 oWFFFF+sRP76Gn9R58LTCe9kB0xTxn9cQrjPdxB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	You-Kai Zheng <ykzheng@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/602] btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8
Date: Thu, 30 Jul 2026 16:09:03 +0200
Message-ID: <20260730141439.150784566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: You-Kai Zheng <ykzheng@synology.com>

[ Upstream commit b95181f3929ff98949fa9460ca93eccebbf2d7fc ]

The variable-sized buffer buf in struct btrfs_ioctl_search_args_v2 is
declared as __u64[], but it holds a packed byte stream of search results,
where all offsets into the buffer are in bytes.

Declaring buf as __u64[] makes it easy for user space to write incorrect
pointer arithmetic: adding a byte offset directly to a __u64 pointer
scales the offset by 8, landing at byte position offset*8 instead of
offset.

This recently caused an infinite loop in btrfs-progs: the accessor read
all-zero data from misaddressed items, which fed zeroed search keys back
into the ioctl loop and spun forever. The issue was worked around at the
time by disabling TREE_SEARCH_V2 entirely in btrfs-progs (d73e69824854:
"btrfs-progs: temporarily disable usage of v2 of search tree ioctl").

The kernel side already treats buf as a byte buffer, so change the
declaration to __u8[] to match the actual semantics and prevent similar
misuse in user space. The change is ABI compatible: both the structure size
and alignment are unchanged.

Fixes: cc68a8a5a433 ("btrfs: new ioctl TREE_SEARCH_V2")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: You-Kai Zheng <ykzheng@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index cdf6ad872149cd..8c5490c6ff99db 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -597,7 +597,7 @@ struct btrfs_ioctl_search_args_v2 {
 	__u64 buf_size;		   /* in - size of buffer
 					    * out - on EOVERFLOW: needed size
 					    *       to store item */
-	__u64 buf[];                       /* out - found items */
+	__u8 buf[];                        /* out - found items */
 };
 
 /* With a @src_length of zero, the range from @src_offset->EOF is cloned! */
-- 
2.53.0



