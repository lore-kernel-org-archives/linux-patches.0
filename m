Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3B7263C6A;
	Thu, 17 Apr 2025 18:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914093; cv=none; b=juJMxKyIK5Uof/xo0+KK8VRRHFLqTVFCYQwTv3+EGUb1L3U049Xn4l/j321khuwe8GFU2c7YwswkEIcSbUOXQlzHqob20OXhw3xVWplz5XJN0nIz383qsAEpUDtUOo5JMOnmlKVPKOhX60ZH5lGfOQXPPe14f0Lq3oVP+sXuzhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914093; c=relaxed/simple;
	bh=cO0IvsLQJIFnLC5vEhIVSES92VykaoqsV2eYmSjyVT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9NHZ1y507hsoItNpzJS1Gj7tWD1mFnYZwysmdYfz5+irGtnPJFJwKf9/zgt0oOSFeQrSrPLdFslFJx/0Fhljny2bipuKWxYJnq3f6l5xC26leK8YTWTdRus64ITrj5ODt5PrwQLPMCwbNfwciifFUhUd2eLWSshpvhkHZYIo0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zI4PNG2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zI4PNG2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7985DC4CEE7;
	Thu, 17 Apr 2025 18:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914092;
	bh=cO0IvsLQJIFnLC5vEhIVSES92VykaoqsV2eYmSjyVT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zI4PNG2aqjogQpd3P3QdLBzvwep+T9GfmFyK5zQt2DpPpYV1WX1sfZNZyDJF+7Itv
	 5emppuAVY1iMpdtkkSCBLcOLBtri9FFPBg23pIYPrsWWV9f6PCWrGhFFpbkSdLxvBu
	 qtOMmlp2YCDRZw40+U43LD4u1RDk2HgUqp+VVZa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+7c808908291a569281a9@syzkaller.appspotmail.com
Subject: [PATCH 6.13 103/414] jfs: add sanity check for agwidth in dbMount
Date: Thu, 17 Apr 2025 19:47:41 +0200
Message-ID: <20250417175115.581346734@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 9ac1fc2ed05bc..0e1019382cf51 100644
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



