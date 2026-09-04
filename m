Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53BB422556;
	Fri,  4 Sep 2026 06:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503000; cv=none; b=aP4kNemzBFlb7RHjISb0IJWRnnRSeqiwwk7eMqpi8kSsgttu/6xTiFsS0wjgBPNrwtJkdnOXiYGAwyrVZ4krYH07BGr9X1mtI5sAC9VH9bMZvUkqzDSSEvB6xKpBXQ8SMB7kXdgs/7Uljm9vUIwq0yFnBY2pUs8rJ5OHYbfwoCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503000; c=relaxed/simple;
	bh=eymuiFrGEcZcW3bxoEDOAbZMWEpzo8ZTJY+3HKk5bAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQZiZZ23lx976MpFnXgw5x3oM0PteMRAEzXftZXlP3utyzcbL5e/pWvq+2+YgjpD2V1PUYk2jMoe5Lwjf/gUHeKarBZ8BK0IIMK2rDn6czCHXsYs8RP/nwqz1UB9LB+U24owKKIhXbGN8GgbAk+W+DQNrMnKx1dUlSp8DaJZHL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0yvo9Et; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0yvo9Et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2231F00A3E;
	Fri,  4 Sep 2026 06:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502998;
	bh=+/FyqgDdnYHmGpilXejjvc3iq46ZcKBurgAvAf3F4VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0yvo9EtGvA4ASGzJM8l+DFJ+RXMbMZGil2GuAsW4ZNRN2JpCGQinjXQ0T5NPqocf
	 11zqw9F8Z+3+OUBLo7o12l8UtYbVWTE3lP47GG5ACib/1zwFXDdgjyXBTmVSNReDMj
	 Bco3+7ytjSP6WlgtDRsu8Fizto13sY2ADYoUUQic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.12 402/403] udf: Fix i_lenExtents truncation on 32-bit kernels
Date: Fri,  4 Sep 2026 07:03:25 +0200
Message-ID: <20260904045743.920401942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -525,7 +525,7 @@ static int udf_do_extend_file(struct ino
 			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
 		iinfo->i_lenExtents =
 			(iinfo->i_lenExtents + sb->s_blocksize - 1) &
-			~(sb->s_blocksize - 1);
+			~((u64)sb->s_blocksize - 1);
 	}
 
 	add = 0;


