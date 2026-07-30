Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067773750CF;
	Thu, 30 Jul 2026 15:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423837; cv=none; b=Y1z6YpseI84AjQpd/yQJu2BgXABHPJR0DrbaCVFrvbpihzHHRrILb/q1IFAETnB1/0rbZhYTOic606EvY1ev9P2C9p9iv2CCUh9UpqfxDirBNj5f22/j6kk4pP3OufBMhKWVEfQ7hSsIy5IZZaMpDY7mUkTeVa0uKTwDADb1dMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423837; c=relaxed/simple;
	bh=E2LovC923qJrHmu7lc55kcTzpS0kVl06U9ideJ0tke4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sa1/Tf/IRsHO/XL89L0+AOrnWhWw4YC1erGwkaHtuOODqWo9ZsXY7Y5pfZ7vNJuOTaHOktUkSQHMyHJs9cuNyKkUrMgetZe8CfFSkf26BCVTd892MJna1o9W+Z3m0MQehfu0wviCG3E4MjcH9gCfd1ZmyvXgQ03UR+dF/tEl3yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRxba45Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRxba45Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AA51F000E9;
	Thu, 30 Jul 2026 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423835;
	bh=6pNWC2/lCw+Tvs19BUATlFp+N4eUhDNZ3yK7ka4OWE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRxba45Q6PDoOFmgIWxWk3qlly0qaqWhHSk0RyXMEc0uoDb7wulj4k+/ZM8/b04Od
	 hoZOoXK5z8QMc/tzO7l1q7x1vMAt6QZntK9Eq3U1340piWjI6b9r/wX0AqBxCZZ/4i
	 Tumz4KzLWbBbtn8bzr0AkB2wQkZbMtGRsSwRG32s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	You-Kai Zheng <ykzheng@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 184/675] btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8
Date: Thu, 30 Jul 2026 16:08:34 +0200
Message-ID: <20260730141449.052339786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 8e710bbb688e04..fb89c5c37eb045 100644
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



