Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA178F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836E7C433EF;
	Mon, 13 Feb 2023 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300691;
	bh=djkS+fw6pffDl6zyDCj0Ly/uhMddCt4GfjwcvfoIPp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPyIsEUWFLtkc2RumHECmY4gRGdOGdwPlc9FFi9Rpi/HguqIbvBg0jzm08IJfrql1
	 vorbMdvJzp7m3nF8gXrBgcQiulOHvfWZ0ck4ZZr+HQFBqEyfQ1XvFNRk3B9TikY6hE
	 7PPRc9IL/EvCEMre7/nlMIoSrEMIpijtLaD6Z8+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/139] bonding: fix error checking in bond_debug_reregister()
Date: Mon, 13 Feb 2023 15:50:57 +0100
Message-Id: <20230213144751.803263160@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qi Zheng <zhengqi.arch@bytedance.com>

[ Upstream commit cbe83191d40d8925b7a99969d037d2a0caf69294 ]

Since commit ff9fb72bc077 ("debugfs: return error values,
not NULL") changed return value of debugfs_rename() in
error cases from %NULL to %ERR_PTR(-ERROR), we should
also check error values instead of NULL.

Fixes: ff9fb72bc077 ("debugfs: return error values, not NULL")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/20230202093256.32458-1-zhengqi.arch@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index f3f86ef68ae0c..8b6cf2bf9025a 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -76,7 +76,7 @@ void bond_debug_reregister(struct bonding *bond)
 
 	d = debugfs_rename(bonding_debug_root, bond->debug_dir,
 			   bonding_debug_root, bond->dev->name);
-	if (d) {
+	if (!IS_ERR(d)) {
 		bond->debug_dir = d;
 	} else {
 		netdev_warn(bond->dev, "failed to reregister, so just unregister old one\n");
-- 
2.39.0



