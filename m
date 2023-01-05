Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E018494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 13:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57E8C433EF;
	Thu,  5 Jan 2023 13:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923942;
	bh=ekaNhfdppCHtWyCxuz2IMweIRM+SE/hGj17+uDFVQx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBeQVSwK+dH+f3tfBANO5uuaovgO6Ub+FwlGWLFmJuWSeE12WRz/QL5+ijSOm95bV
	 zhgoEeb6o/cvPyXJ/DtPUW9W6+6Mxpc99QGqj4HbtCGW9X2cPLvh6/YH61duYxJ/Vf
	 /j1ze41f4c8EWV27LS6xahHZhoXcZagTicmfOS4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hoi Pok Wu <wuhoipok@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 182/251] fs: jfs: fix shift-out-of-bounds in dbDiscardAG
Date: Thu,  5 Jan 2023 13:55:19 +0100
Message-Id: <20230105125343.128936243@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hoi Pok Wu <wuhoipok@gmail.com>

[ Upstream commit 25e70c6162f207828dd405b432d8f2a98dbf7082 ]

This should be applied to most URSAN bugs found recently by syzbot,
by guarding the dbMount. As syzbot feeding rubbish into the bmap
descriptor.

Signed-off-by: Hoi Pok Wu <wuhoipok@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a46fa0f3db57..0ca1ad2610df 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -211,6 +211,11 @@ int dbMount(struct inode *ipbmap)
 		goto err_release_metapage;
 	}
 
+	if (((bmp->db_mapsize - 1) >> bmp->db_agl2size) > MAXAG) {
+		err = -EINVAL;
+		goto err_release_metapage;
+	}
+
 	for (i = 0; i < MAXAG; i++)
 		bmp->db_agfree[i] = le64_to_cpu(dbmp_le->dn_agfree[i]);
 	bmp->db_agsize = le64_to_cpu(dbmp_le->dn_agsize);
-- 
2.35.1



