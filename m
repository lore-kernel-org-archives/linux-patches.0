Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9BF344DBD;
	Sat, 12 Sep 2026 19:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241707; cv=none; b=Nlq/b4hoCeCdDikEE9Rmhpihxt5zkSQYFUMwQBD8WQ8ydTh0cplFwku4KshCEVc9aVHBCy+2TLeG+SVIg6SRtCZhWf4MsIMhQf1DdwA/OQhcibplraBXcvTv7IYFn2qzoeY7Xel59FPpkVxrjixLasl6g48YK6vTXISmFKKzv8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241707; c=relaxed/simple;
	bh=ptwVUqkMrL2aveEmtWwNSRdo+SD2qyi8DaXVy+D9+5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u23YOaMiI0TxulQUNVghjylKC+/Ys2e/805DRcfs1aaEoaHDdNt46QoRTmxR19XYbXV/3lTFvKah+E0IGETKk7cqFHD1zhauqF8XpPQSwv/uXHxwH8Q0Ri0/c2Rdv1VexfIKVJebCJF1XIy3Uyc9jGlNqxxe87Bf/bpA0JPTXH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg8OZIZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg8OZIZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925ED1F000FF;
	Sat, 12 Sep 2026 19:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241706;
	bh=DLUCI81BuvPFzFLj7EHZfIx+04dz7nJJgoE3L65GbGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zg8OZIZt/qw/PD/YfwSmm3rqkdNHHp/b0mZgFcf1f2sTx1flun9SyZuI6pCvTJNPZ
	 JEMD67Ir4cbD0jfsS8YwNKAq+wPTcq9ePVwXMavAapN92GGn3IvxCDPdMbeMkgB+SU
	 ambRjG/LSjEv/bbpV8Kc8QqHk6gepIuf42mZe00A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 189/798] udf: Fix i_lenExtents truncation on 32-bit kernels
Date: Sat, 12 Sep 2026 08:56:57 +0200
Message-ID: <20260912065521.384033844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -510,7 +510,7 @@ static int udf_do_extend_file(struct ino
 			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
 		iinfo->i_lenExtents =
 			(iinfo->i_lenExtents + sb->s_blocksize - 1) &
-			~(sb->s_blocksize - 1);
+			~((u64)sb->s_blocksize - 1);
 	}
 
 	/* Can we merge with the previous extent? */


