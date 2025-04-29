Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9964021ABC1;
	Tue, 29 Apr 2025 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948607; cv=none; b=DeisaS0oWJO0dKBvs0DNgkrdDUGdq0Us1EN4vkPmckrpjvDT6YKWmFnhif8O4qbdnzQtm74ZUA/AtH7QhjP4t5zb9a4ioyXrey7OTGkEJPxztRErGReyog/zABn+oXEv81GtRd8O1RqAFy2Ehib9CgkCCfJNbnBxW9KgZN0xkTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948607; c=relaxed/simple;
	bh=yMh1Fa6zxC5vSfxbSwdNSNqrAxlS54bqiP9nkdY7gMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvTprqmxuxkJ/9I5gSBWjgPlNqr9dhm1kZKrUwUNvtzLl5pLI+7qubYwJamC8Hqc2+Y9WR/Nj1zT5Ks4ctnpk8mi4X62HayQczb/UDruyTVV0i18WEiLYOz9fSVDpb7+4obhH3VxtWdv7Qa6y3A/cm4r9OMc2Hji0Prp91inSvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6qQbuyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6qQbuyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20264C4CEE3;
	Tue, 29 Apr 2025 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948607;
	bh=yMh1Fa6zxC5vSfxbSwdNSNqrAxlS54bqiP9nkdY7gMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6qQbuyyXYshMTwk9HY+8HxA1wFu6WGJW7uFTrDpqy5s1a9hiZ6en8Tu1A4Vy1let
	 dCeDCFOZFkcrAq1c87vnIlzHMApNCBDUXM99QIdN3XURKK4ncd/x5OCGj3rZSWPnON
	 A9tU2sAacmWs8JEdJQtGMQwrXvX99aG2nY/c4/uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+7c808908291a569281a9@syzkaller.appspotmail.com
Subject: [PATCH 5.15 028/373] jfs: add sanity check for agwidth in dbMount
Date: Tue, 29 Apr 2025 18:38:25 +0200
Message-ID: <20250429161124.286771032@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit ddf2846f22e8575d6b4b6a66f2100f168b8cd73d ]

The width in dmapctl of the AG is zero, it trigger a divide error when
calculating the control page level in dbAllocAG.

To avoid this issue, add a check for agwidth in dbAllocAG.

Reported-and-tested-by: syzbot+7c808908291a569281a9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7c808908291a569281a9
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 99e9885cbb444..cd6ba0c96d77b 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -204,6 +204,10 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_aglevel = le32_to_cpu(dbmp_le->dn_aglevel);
 	bmp->db_agheight = le32_to_cpu(dbmp_le->dn_agheight);
 	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
+	if (!bmp->db_agwidth) {
+		err = -EINVAL;
+		goto err_release_metapage;
+	}
 	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
 	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
 	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG ||
-- 
2.39.5



