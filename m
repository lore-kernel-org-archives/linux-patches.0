Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215451;
	b=TDu9/HyboSRyHkA6WZeZYzKZSg30SjnetGh9s/ZSAEc6yIBM92ZqCYFKaTCtbty/BpKB
	 cE0d8kVcOFFEMykTs4cQSOiuNsYZ75i3Is8e4DEll32DRFVVfFTu0AVFJqdFXjY/cdNiJ
	 s7kxhYhKiKND/gp8Wq4OWlS8mHPCHe2vdQwqb3M+5Qe91v+LbakM2qYsldTIk65bNv8X2
	 8WO7FioaCU9sE6eoGZ4+MPYrzqUnw7XMGWW9+O+93jvsob1OwAoM2faN68DfA8rFJYqot
	 7QGfDgKg+pGas4+nKm0uYOJOn5ftqYz0jVFaOOX54+QGoy1lp1iUHkUeNefH55XZSlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wwKbcC9qzeYxbnvRlgtrrD+bwTPpBIAot0JBOKxX3hw=;
	b=G9QbIvG6oLywqkex3T+mihynqokug03wQ4iKjHuoJHjv/ENenBhbTfnoS9uSwisH0oO1
	 Ev2yuv2OWGZvbSG76srpZlBLV45SAD8wdsNW0TcDqJJvSYi8as2M3uWad88fLD4Fq0lXm
	 R0VlfZ9o58dRe2Jf9nk2LGD7l9vypcnmx5RbBhK/9Ft2AsH5whZSonDl+d/I+9dgdzO+W
	 djbO2S5MeGMhKGjYPuOP5ciHqLxH/EBWfastffTWS9fgYat4m00TsL6al3hOezPBdhJyd
	 dNOAJbDdAwdkQSxbUQDXNpA1D6dOzchBOAQmDp0FoW5y7bDKzdCywWDE75W/4K30jwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OI8PB2mK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF382606A31C;
	Wed, 28 Oct 2026 19:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OI8PB2mK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D53F1F01825;
	Wed, 28 Oct 2026 19:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215450;
	bh=wwKbcC9qzeYxbnvRlgtrrD+bwTPpBIAot0JBOKxX3hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OI8PB2mK5jFa9zof1Bta/Jlir+YIm2QWgv48aSy4pZIge+RGaO0Pt8E9WtENzXm64
	 fASMTgGH38ywnGsOO//Odm/GE8cdtIYcr5SEcEvzT/PThCyfUq4g0lI9WzfIEic+VW
	 SOxEGk+4zZEi3pDYOyup5AApRarxRGzclxPmi66Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1214/1887] ocfs2: add suballoc slot check in ocfs2_validate_inode_block()
Date: Wed, 28 Oct 2026 17:55:10 +0100
Message-ID: <20261028170527.035741954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit fe7a283b39160153b6d1bd7f61b0a9d5d44987a8 ]

In 'ocfs2_validate_inode_block()', add suballoc slot check similar to one
in 'ocfs2_get_suballoc_slot_bit()', thus preventing an out-of-bounds
accesses for 'local_system_inodes' in 'get_local_system_inode()'.

Most likely this fixes
https://syzkaller.appspot.com/bug?extid=a77d690840e60bc2ddd8 as well.

Link: https://lkml.kernel.org/r/20250826095106.666980-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=900962ac9bf1860033f2
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 452a8467be81 ("ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 5d9da67e9ba5b..b9ef61113e07d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1577,6 +1577,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
+	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_suballoc_slot));
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.53.0



