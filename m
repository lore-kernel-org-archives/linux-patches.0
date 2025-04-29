Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F3D24E4AD;
	Tue, 29 Apr 2025 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945182; cv=none; b=NrFMZ1rSAa1EbUe5YfPNpBDfUTZ418rxv0NKsFSGaV+/a6pEKqqqU3f/kX4/a8f5Q2708fsfbVUN5JjaRUfZMF7Xhc5OKM8wd/u85/KsUwWpXBJobtWigUIaKXKvcCHqBHU/VXqJtFDWUwQaGUONeTv64loNkIi1aTogNA0nzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945182; c=relaxed/simple;
	bh=t/o0brppmoptkL4MQ8yJrqWlGJ1fdhYv4IJI1VQcx5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHCn6zWsOEnHucQ207tf8lcjEjYTTQP+XZ7fWOBZVqooty3KTxbi3vp0PSu/PgyiWFgVraXJANalB93SnDcIvwfXMkJ25zmcNT282SRyGnSpOZOYaq/KlCeWCSozNMr9BKaFnD8z5xNg/yUyOskG5F8M4Glt6/2ESHW6jw4TblU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5S1CQcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5S1CQcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A2CC4CEE9;
	Tue, 29 Apr 2025 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945180;
	bh=t/o0brppmoptkL4MQ8yJrqWlGJ1fdhYv4IJI1VQcx5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5S1CQcqvTScLV06tMD3r9qAHhjUaS6SH5p//TAGFnrJwcm0Tc6EAT3ndNHDUbK/V
	 49amY9est6YE0hUVZ0Xqk49F5w1xErFTNzBJnXRqA1U3exKu+ttWZp/WFNfnFVCpKV
	 6OeYgafwxEarnebfQSYKLSATvlyCVGl9sHiatY0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+7c808908291a569281a9@syzkaller.appspotmail.com
Subject: [PATCH 5.4 020/179] jfs: add sanity check for agwidth in dbMount
Date: Tue, 29 Apr 2025 18:39:21 +0200
Message-ID: <20250429161050.225187189@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d4e26744b2005..d161bbafe77f6 100644
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



