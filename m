Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41C3215710;
	Thu, 12 Dec 2024 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025768; cv=none; b=gR6Mb1GIUjRKvaXCKIJmZzCSVcjc/dc+pVD4rOpbT3xwrDRgYy7PNw6Ei/wg1Kec5wE8V6tpKVHK6QN7rpVMagthdBH+K0RICGkJs9VUWV4TXEQuPd5GbdsuBGxZwbkJNfsyUH1LW57Q1RcXvBaI7xgZ3/INpG6DORut4/cC+uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025768; c=relaxed/simple;
	bh=snVZxWQQzPywS8swnHcNGKC8tkHpvYUS9F+2B0JBcHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhJL6LJmhC2FLDG/7PPWArLqMbnOm39y98/VdyV8XFx/TD+N5zP1b6EMrPyfAVW0CjHQSl3poEik40s2QgJIVoNYdMLxPltlCz2jRi5jHctPzWc+7MCDUR/sA/yiVIYDkyiJIFfiM8R5JtKcR/9yEnYDkljehrtpi+ewwrGO6Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Owlkurx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Owlkurx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC3DC4CECE;
	Thu, 12 Dec 2024 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025768;
	bh=snVZxWQQzPywS8swnHcNGKC8tkHpvYUS9F+2B0JBcHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Owlkurx1mu3UminEal5VCWrlMpBsqwMOBov3j7khqx6P6VNHfat8hjcEwKKK4IxDe
	 YzzZ/+KYWs2AvTF/4oEWbM2/F/sIo+JEec4DC2HOVptQqKVymZEUeVgD+sUf6MeS/Y
	 SskoW8GvLy8P89MN7vunek4whxGRx/TMLo3Jqeac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+65fa06e29859e41a83f3@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 282/321] jfs: array-index-out-of-bounds fix in dtReadFirst
Date: Thu, 12 Dec 2024 16:03:20 +0100
Message-ID: <20241212144241.119851365@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit ca84a2c9be482836b86d780244f0357e5a778c46 ]

The value of stbl can be sometimes out of bounds due
to a bad filesystem. Added a check with appopriate return
of error code in that case.

Reported-by: syzbot+65fa06e29859e41a83f3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=65fa06e29859e41a83f3
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 077a87e530205..bd198b04c388f 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3382,6 +3382,13 @@ static int dtReadFirst(struct inode *ip, struct btstack * btstack)
 
 		/* get the leftmost entry */
 		stbl = DT_GETSTBL(p);
+
+		if (stbl[0] < 0 || stbl[0] > 127) {
+			DT_PUTPAGE(mp);
+			jfs_error(ip->i_sb, "stbl[0] out of bound\n");
+			return -EIO;
+		}
+
 		xd = (pxd_t *) & p->slot[stbl[0]];
 
 		/* get the child page block address */
-- 
2.43.0



