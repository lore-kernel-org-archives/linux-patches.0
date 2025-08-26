Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4E61F55FA;
	Tue, 26 Aug 2025 12:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213140; cv=none; b=aVISsbivOnMxBS+sm47nuOGbgOOTmwm7nbMLCNZv1iVNY+G063NIlx6YRhKv+ENs/9IUZup1p8zbWNoOIJlCxKn1YIlA0uJ+pQVIzjFdR4S8QsTcn4EdAD2VcHm6KiNidf1pbssYLvWIG4RrjOlZ0MIHD2vVGw2/rB5Hj4R2YY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213140; c=relaxed/simple;
	bh=r9uInVgCrSvbg5Ywdlv0e0wCV+DBsK3+GixbqTl/G8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk+EeUQx2YcZZyBV/kxMSNeUSoeS7uVosY7U06HRy4JSeaxc7Y+3lYy+ppaIt3p6CQLRhT6a+kta/+AyHqQ+XHwgVekp9o6lne3tFS3k1aoOypMFbDV6sjNJvtOg+832KeC22LOvZYgdCrhl7heKMC4X+/I6lND4Xzn1masatdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1uSJgiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1uSJgiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E33C4CEF1;
	Tue, 26 Aug 2025 12:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213140;
	bh=r9uInVgCrSvbg5Ywdlv0e0wCV+DBsK3+GixbqTl/G8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1uSJgiSguRMam77vtuO13ZwaTxchLBx/rYg1mM5FOe2IaLM0jL4WX8I01wtRQ6GI
	 4mBKLQgLadqUOLgKWllflTLdDpYmh/8oSODDeFdAKbnpKfKvnOOmLUlAzdOJPOSXkl
	 kK6EndtGLRH2LeAZlNp9wSopQs4d6Hw+tSYtHdyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 237/587] jfs: upper bound check of tree index in dbAllocAG
Date: Tue, 26 Aug 2025 13:06:26 +0200
Message-ID: <20250826110958.963427356@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Arnaud Lecomte <contact@arnaud-lcm.com>

[ Upstream commit c214006856ff52a8ff17ed8da52d50601d54f9ce ]

When computing the tree index in dbAllocAG, we never check if we are
out of bounds realative to the size of the stree.
This could happen in a scenario where the filesystem metadata are
corrupted.

Reported-by: syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cffd18309153948f3c3e
Tested-by: syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com
Signed-off-by: Arnaud Lecomte <contact@arnaud-lcm.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 5a877261c3fe..cdfa699cd7c8 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1389,6 +1389,12 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 	    (1 << (L2LPERCTL - (bmp->db_agheight << 1))) / bmp->db_agwidth;
 	ti = bmp->db_agstart + bmp->db_agwidth * (agno & (agperlev - 1));
 
+	if (ti < 0 || ti >= le32_to_cpu(dcp->nleafs)) {
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmapctl page\n");
+		release_metapage(mp);
+		return -EIO;
+	}
+
 	/* dmap control page trees fan-out by 4 and a single allocation
 	 * group may be described by 1 or 2 subtrees within the ag level
 	 * dmap control page, depending upon the ag size. examine the ag's
-- 
2.39.5



