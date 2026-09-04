Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23262378838;
	Fri,  4 Sep 2026 06:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501836; cv=none; b=scR9L1wQ5TSQnLR9dl1AK0ww7bZWA+HhLn823t6AH7o6P9ZMA6QpwfshEHvFgtU9lsG+gERLCkV+Kz+AVzwBsgHMuu3ecuP0gr6ctBZBQiDGWvQ/s71Cj+KzjEx/4VHjWWzgO6fvOSLZu3e4zb3/MEMIu52N4lZC5oBsDxOK+04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501836; c=relaxed/simple;
	bh=mA/HFg2L+osLKcBeDO3xoJrRJyOVNSzZnfLDvmxOD6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPbiLRWoyut9t8HfgBrFlDKY9uAd7ulL/gJoyToPPfq5jeiNOp7X+CqEe3K2DYQVv90CMJH5YCT93XhcAhYvN8gamB1Q84nMj2XWZFtz4L0Xr1XQCu8tpSuyWpWyHUhIeWMBc+tfx0Od+yiC1lQiSJOODAwBqt2MRIkmeg1LC/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhQ9BgLv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhQ9BgLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B2E1F00A3D;
	Fri,  4 Sep 2026 06:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501834;
	bh=e2ci8G6aljnLUCqaLbli/SxEJOht7p72ZyY4+AIRI2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhQ9BgLviRL1Efv19QKdyoErO5ZNQjRVGHgttGr1GfPq5WErxwvt/0+FPbjAlJfH/
	 nfo+2n+XL48NLrKQCPY/hHwgjOzwxDaRsc6lFzSxF05m08L3dDA5NE1nHleBoPs/A7
	 GzHfHARg3hYsvs4lfrM2dD2p6XheF9WC53yCJyBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.18 550/552] udf: Fix i_lenExtents truncation on 32-bit kernels
Date: Fri,  4 Sep 2026 07:01:47 +0200
Message-ID: <20260904045803.066315416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit a5a5ed23b1340ff0f32a14a7ca8585f7c4e9b2e2 upstream.

In udf_do_extend_file() the total extent length is rounded up to a block
boundary with:

	iinfo->i_lenExtents = (iinfo->i_lenExtents + sb->s_blocksize - 1) &
			      ~(sb->s_blocksize - 1);

i_lenExtents is a __u64, but sb->s_blocksize is unsigned long.  On 32-bit
kernels unsigned long is 32-bit, so ~(sb->s_blocksize - 1) is a 32-bit
value (e.g. 0xfffff800 for a 2 KiB block) that is zero-extended in the AND,
clearing the upper 32 bits of i_lenExtents.  For UDF files whose total
extent length exceeds 4 GiB this truncates i_lenExtents when the file is
extended, corrupting the tracked extent length.

Cast the block size to 64-bit before forming the mask.  64-bit kernels are
unaffected.

Fixes: 48d6d8ff7dca ("udf: cache struct udf_inode_info")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Link: https://patch.msgid.link/20260722082425.213311-1-zhanxusheng@xiaomi.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -532,7 +532,7 @@ static int udf_do_extend_file(struct ino
 			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
 		iinfo->i_lenExtents =
 			(iinfo->i_lenExtents + sb->s_blocksize - 1) &
-			~(sb->s_blocksize - 1);
+			~((u64)sb->s_blocksize - 1);
 	}
 
 	add = 0;


