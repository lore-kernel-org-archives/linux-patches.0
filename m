Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431733DE43B;
	Mon,  4 May 2026 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904221; cv=none; b=PUpnniMdjBEmDCqtVeqQRPR2PTC9qn7+0Gu9LEAxcES8DcTPJj+ISUn/gGgNMEt7Z6AO7VgdxBAhsU9h0Ejj3mfypCDpdSmj9F1GMQoA2UTNj/Ri5sKa4ukJS5KtBUf8GM121y2eCD/Z8+GCKG2Rfs1I+17f+oXkyQe4N0OmP9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904221; c=relaxed/simple;
	bh=vbzzOETG/ZidjaxGGRdAMV0h2OAHA7KnacP8Jc+Bft4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPlpIljH9I4KBFV0LvZi0luMuKWkyfF5CErQQGtirFWu9cgh2NO7AzsrKfU2xl0w6ly/UwCaZ9KAELrEooXz805CXBUYsoMURj5r1+XyjS8isnNQc2WdUjv58MzsDC28V6yS2yIf0euuNUtbTUg2jVLCS479mTYFPxNw9fexPkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hi+qLoJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hi+qLoJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF26DC2BCB8;
	Mon,  4 May 2026 14:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904221;
	bh=vbzzOETG/ZidjaxGGRdAMV0h2OAHA7KnacP8Jc+Bft4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hi+qLoJQsSUa1Rv9OFtiqzgJVKUTw5XWSy2MBrX/tNqyi8K/iJBBhHLw+vlWCDCkM
	 OiCmksSe5/+P7h822QrvvufevwzrVY2TIKEIEck2Qh7P5YlaMYlTg+VpT9IixIwzCg
	 Ju1JQEjUhscHDVwGN6O+Pyfs51Kgna7Z2NNrtaq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.18 197/275] ext4: fix bounds check in check_xattrs() to prevent out-of-bounds access
Date: Mon,  4 May 2026 15:52:17 +0200
Message-ID: <20260504135150.395208390@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit eceafc31ea7b42c984ece10d79d505c0bb6615d5 upstream.

The bounds check for the next xattr entry in check_xattrs() uses
(void *)next >= end, which allows next to point within sizeof(u32)
bytes of end. On the next loop iteration, IS_LAST_ENTRY() reads 4
bytes via *(__u32 *)(entry), which can overrun the valid xattr region.

For example, if next lands at end - 1, the check passes since
next < end, but IS_LAST_ENTRY() reads 4 bytes starting at end - 1,
accessing 3 bytes beyond the valid region.

Fix this by changing the check to (void *)next + sizeof(u32) > end,
ensuring there is always enough space for the IS_LAST_ENTRY() read
on the subsequent iteration.

Fixes: 3478c83cf26b ("ext4: improve xattr consistency checking and error reporting")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260224231429.31361-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260328150038.349497-1-kartikey406@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -226,7 +226,7 @@ check_xattrs(struct inode *inode, struct
 	/* Find the end of the names list */
 	while (!IS_LAST_ENTRY(e)) {
 		struct ext4_xattr_entry *next = EXT4_XATTR_NEXT(e);
-		if ((void *)next >= end) {
+		if ((void *)next + sizeof(u32) > end) {
 			err_str = "e_name out of bounds";
 			goto errout;
 		}


