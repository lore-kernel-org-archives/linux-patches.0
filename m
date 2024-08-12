Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A63183CA6;
	Mon, 12 Aug 2024 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480564; cv=none; b=FXC7Sbdah98Bjmhra75eQBKTTyVGupXp3siN2hbhoTll0B8Ni7drFXWRKArTb08CQBLyIhIVvehbuQerDDwScF91YEwXA/Mh8OOhzzaaS4ITMxlvlXeeoHfCEovBRWXogry2z2sLPH62zsFmNghsIxIfZnhKbBX5XmC3aUlRi+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480564; c=relaxed/simple;
	bh=xnzNiaZS+KfZxEOv6maPm52YBqqozf2y4uMHgn2fb+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bo5g42ttDZXV2KSzFvx3cYpM5MZQFRN/LGWeOItROV//Hi7K6+g6kh8wXg4JC5D3BVRTbeBe1lC0l6FskvaFSmsWOCHmpzqh6dyA1+dvYl+lpaiatCkXfUMtCSAb7nx0bOgrg5oL9kBrZ7NJ+uNZ0eqCXJ9DdxcWrv+1Cj4cNNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fY8s73W3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fY8s73W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADA5C32782;
	Mon, 12 Aug 2024 16:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480564;
	bh=xnzNiaZS+KfZxEOv6maPm52YBqqozf2y4uMHgn2fb+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fY8s73W3Lms53yculP8Z3peg6//5erafNeFe+sL9A+2F9IBxgdmyuWd0udlfvzqtd
	 qNw27uqMe1Z3yRUIoZMVX+6eoeG3/RLHKMA6okpH2yjpy1jn0STX+51C4eWsH/2Kry
	 PCq7nGcRDiLwscoNfJgm19+Pg+/EZVX12cNPb4Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam James <sam@gentoo.org>,
	Alejandro Colomar <alx@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 235/263] btrfs: avoid using fixed char array size for tree names
Date: Mon, 12 Aug 2024 18:03:56 +0200
Message-ID: <20240812160155.530099513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 12653ec36112ab55fa06c01db7c4432653d30a8d upstream.

[BUG]
There is a bug report that using the latest trunk GCC 15, btrfs would cause
unterminated-string-initialization warning:

  linux-6.6/fs/btrfs/print-tree.c:29:49: error: initializer-string for array of ‘char’ is too long [-Werror=unterminated-string-initialization]
   29 |         { BTRFS_BLOCK_GROUP_TREE_OBJECTID,      "BLOCK_GROUP_TREE"      },
      |
      ^~~~~~~~~~~~~~~~~~

[CAUSE]
To print tree names we have an array of root_name_map structure, which
uses "char name[16];" to store the name string of a tree.

But the following trees have names exactly at 16 chars length:
- "BLOCK_GROUP_TREE"
- "RAID_STRIPE_TREE"

This means we will have no space for the terminating '\0', and can lead
to unexpected access when printing the name.

[FIX]
Instead of "char name[16];" use "const char *" instead.

Since the name strings are all read-only data, and are all NULL
terminated by default, there is not much need to bother the length at
all.

Reported-by: Sam James <sam@gentoo.org>
Reported-by: Alejandro Colomar <alx@kernel.org>
Fixes: edde81f1abf29 ("btrfs: add raid stripe tree pretty printer")
Fixes: 9c54e80ddc6bd ("btrfs: add code to support the block group root")
CC: stable@vger.kernel.org # 6.1+
Suggested-by: Alejandro Colomar <alx@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Alejandro Colomar <alx@kernel.org>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/print-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -14,7 +14,7 @@
 
 struct root_name_map {
 	u64 id;
-	char name[16];
+	const char *name;
 };
 
 static const struct root_name_map root_map[] = {


