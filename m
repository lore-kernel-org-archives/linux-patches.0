Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54585322A2D;
	Mon, 18 Aug 2025 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524050; cv=none; b=pcvW+6ml4GLTRI1lugWnumwK3KRslk15nK8tKzbqwoPwIGjTDOrUmD9DxjA4cgPBmXDti35SThXMYXi+BmJLGFr0ilnv/TRzAgj9SwUASRED0W0S4hkNzL2nSnQ1Xzi4dEVwYqNS8SjI5Hy5gXakuYF6lVvCJMEjIh7NLlJroXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524050; c=relaxed/simple;
	bh=W7EyGiPL7J883A3lmg/0BRBuOiO7KZuKl6IMk9V30hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfjn08kwkfQWHDfwiXPLxQIverGHapokjyo4vb3fNPMbmo4Z+mzH77+0Bt+vSVgIbQKUQIMkpxA5YFAt6/CNqbN/3LM0BOoDBVcPIWkLHz1rLgAG9RoV8cYJeHA4HOXw0mBNkiIC0QubX5EU806nrp8HOY+m8QQfFwaYxfXWnTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1T15JjJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1T15JjJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01B4C4CEEB;
	Mon, 18 Aug 2025 13:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524050;
	bh=W7EyGiPL7J883A3lmg/0BRBuOiO7KZuKl6IMk9V30hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1T15JjJDP31ZhhRwoTYkhCIwC/dA4N9L2//uPySV10WqMcbcAr7XEY37UxwEJ4zVh
	 cqcQcw11VSMZ5KANGlllp1SKeOapgcoziJdaNh8WKF1d9mlH+yHgd4XOoSNkY7koig
	 t0tL3yJuebxrEYdfTasPyqh2sTeUgZoOOmQV0dKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 352/515] jfs: upper bound check of tree index in dbAllocAG
Date: Mon, 18 Aug 2025 14:45:38 +0200
Message-ID: <20250818124511.972568734@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



