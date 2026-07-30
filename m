Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3A045FFD6;
	Thu, 30 Jul 2026 16:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427480; cv=none; b=u9+FOE5jThuIbfAOj3Tv4s+Z9yUIqH8XMmja2TJ+c1V7rv6Sb2yIyPLGBYt19JuBD7Wv7gbzNKbauHGKyJ94yAn5WvToqBsehf28sm13Y9iukP1HcptPH7ulOxgWNQShc6i9qv0UkA78GY7lFHgLCsymHAujP1w3T8cm1eAEjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427480; c=relaxed/simple;
	bh=PCbi0GME3/rrIpxjaIGd7sQCj1tmh+ot8UapWnE+TC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhyG15ET4FZYUvqsL+Ka3QDbZs2r7MhmAkRyHz8HHzFd4Mit9ATx2QXM7qFtBQzk1cLCUDTjd/uICVtaI5g4V+lKJm8xFMXb0iiwS0AcSlWBshjpu0gTkiiFvh+rly9Brq2610XgL8fxj88Y+WbhjZJUGYjsXqqyapzHgcDpXL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtNSvRLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtNSvRLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3881F000E9;
	Thu, 30 Jul 2026 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427479;
	bh=K3pUkomOOZP0auiMc8gPc5pC68SLLdtXutfmluF/hWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtNSvRLrV55zzG+jjVt+INfnpapvzDmnc4xy9VM2gDZFS1nqiy2we6IcMbwpBfyYb
	 Guyge/HA9jnKwDWuR7hbb3g1h/eEdIJNOF+KnpTC//iltL6VhaWS2S9UvJp48dsnQ7
	 GCjBWy9soWJvzD8YlDp/AR7/yQ8Qbr1Bi2ZPiL2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	You-Kai Zheng <ykzheng@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/484] btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8
Date: Thu, 30 Jul 2026 16:10:27 +0200
Message-ID: <20260730141426.282206588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 7b499b90bb779e..9c921ae7c9187b 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -595,7 +595,7 @@ struct btrfs_ioctl_search_args_v2 {
 	__u64 buf_size;		   /* in - size of buffer
 					    * out - on EOVERFLOW: needed size
 					    *       to store item */
-	__u64 buf[];                       /* out - found items */
+	__u8 buf[];                        /* out - found items */
 };
 
 /* With a @src_length of zero, the range from @src_offset->EOF is cloned! */
-- 
2.53.0



