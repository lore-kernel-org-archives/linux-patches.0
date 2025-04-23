Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D0F19E966;
	Wed, 23 Apr 2025 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420369; cv=none; b=p75srTf+9PcAM0G7+pcBrKRVq28alV8oCHmhAU2ze1Wtkt0ApEeu3q/U7Z/ylLiVHtJ/CuA3XHzpcJGSm7DU+Z2aewLnWSWrh8hNCk/nXUn47hwilNlOk2FwFJ44ROfGt7MTyTFqTsvKo5qF0fWsLj7ah6uo7ZyCVsxBfUl4KU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420369; c=relaxed/simple;
	bh=4rY9WfqfIKX65IrnJBHB7DVAl4a2KQ/OUfgSygckTKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ee9Ne8uAxMwdrv5w05Uaw4iUHT7zzgShuXUoEBAQGA5/URHGa92Ga+Dv85DEEPzmZVqCPWkITaim5jSnyW71D0ifs70J2NfoqtcJoO2y8WZ2ZZ6LipBQyxvrcWE4P4LLZxhSrLhHwWUXfz+tf0BF1ON3i2xegAeEDsN7TDw1TsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1n47474Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1n47474Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A226C4CEE2;
	Wed, 23 Apr 2025 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420368;
	bh=4rY9WfqfIKX65IrnJBHB7DVAl4a2KQ/OUfgSygckTKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1n47474QG+qIl+pT+wXR3uNCm+oqtdveYpU7NtSHZ7jGBX4m6H50OvvEPpq5YOfrL
	 M2DEu4smj8/pPpIWKH6RtSQMa39fKtR+6rFiDV+oFq/2DHU/gHuRfSi+EVnvIyELRa
	 cKQMKzWLqzNyuZxtW3MqVLXmwGVvBRKixJBnPDyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+7c808908291a569281a9@syzkaller.appspotmail.com
Subject: [PATCH 6.1 041/291] jfs: add sanity check for agwidth in dbMount
Date: Wed, 23 Apr 2025 16:40:30 +0200
Message-ID: <20250423142626.075120003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 11b6be462575c..5e32526174e88 100644
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



