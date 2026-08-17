Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F60C23AB9D;
	Mon, 17 Aug 2026 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979225; cv=none; b=WHqzCXzo5+wudb98vjKR4Aals0TM/5EzsZJouUmvMB4ljJyQUUUuh85YYuyah0cA9363MGe04jXodr3VOnLZbYvDDWbULB7DNMdjJfkV6WXFXmOilyU7QLMSw2jt4K/NsF4zZ4F30q0giAG04XF4OIKIcETrMYBbVpebZ7YLdX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979225; c=relaxed/simple;
	bh=hhR5lv6DGK/DIenfYoLdHLTwfIqxeMEixfTgCeLP4lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTVSX4XmxmihQyZlTlmTWE1+WVDOHYm2N1VItCWcJsYhqMLkRRiQ7UHnuZAxOcbumzIIFHLDa2LsPMCbfKmSAu3Wtmx9qbYHLmHf0KTGSvWHrw8+vl3ExyF/oqO5FEfLJpH2Cnbw86nj1LAd4F0om2FvyPkDPglwyA07+xTnyI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0ztuUFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0ztuUFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E62F1F000E9;
	Mon, 17 Aug 2026 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979223;
	bh=0i49c/91d3m77ZQtzsDLWR9fJJ3Qe2Gmz1fZMbq6y9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0ztuUFzpSWUneL9BxE070GIRD3OLnDWOZOsXCkeXsWcmv3hXe1il8O4aa1iSgbRl
	 AUwXcB7mGFcegqI0NHOCoboKMobEbaztUn8ONSCyyRhS2hYjrdC01S2id3fi8y13bL
	 RW7v89oo+UUKnaUoR9wiTb2+d3nqvxyr6tV3lgHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	You-Kai Zheng <ykzheng@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/609] btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8
Date: Mon, 17 Aug 2026 15:26:48 +0200
Message-ID: <20260817132547.497694217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 24b54635bae90f..7b9e199de89286 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -568,7 +568,7 @@ struct btrfs_ioctl_search_args_v2 {
 	__u64 buf_size;		   /* in - size of buffer
 					    * out - on EOVERFLOW: needed size
 					    *       to store item */
-	__u64 buf[];                       /* out - found items */
+	__u8 buf[];                        /* out - found items */
 };
 
 struct btrfs_ioctl_clone_range_args {
-- 
2.53.0



