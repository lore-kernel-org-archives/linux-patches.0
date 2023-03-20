Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34071C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750A4C433EF;
	Mon, 20 Mar 2023 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325572;
	bh=VqcU0kjoPpaodik/tmc2o/BUXU32GcZs2CiF6oE5zjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fivB+CTQ+WPOvSbaPPbBSrYy00p+A/JmIWgfdYowHrCTw5SsaDdeS+ejKv2UwQWsU
	 bDX4cD3AwqlCcxdid0E5sehjDesW36sAnjUqlXQqO4nYehaHtAJKalIpIvRCpqfDfh
	 g6dSP3kNujLII26yvfh7/wziC+oZNP1vIcPtpY7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Lu <roger.lu@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/198] soc: mediatek: mtk-svs: keep svs alive if CONFIG_DEBUG_FS not supported
Date: Mon, 20 Mar 2023 15:54:02 +0100
Message-Id: <20230320145511.939152502@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roger Lu <roger.lu@mediatek.com>

[ Upstream commit 8bf305087629a98224aa97769587434ea4016767 ]

Some projects might not support CONFIG_DEBUG_FS but still needs svs to be
alive. Therefore, enclose debug cmd codes with CONFIG_DEBUG_FS to make sure
svs can be alive when CONFIG_DEBUG_FS not supported.

Signed-off-by: Roger Lu <roger.lu@mediatek.com>
Link: https://lore.kernel.org/r/20230111074528.29354-8-roger.lu@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 00526fd37d7b8..e55fb16fdc5ac 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -138,6 +138,7 @@
 
 static DEFINE_SPINLOCK(svs_lock);
 
+#ifdef CONFIG_DEBUG_FS
 #define debug_fops_ro(name)						\
 	static int svs_##name##_debug_open(struct inode *inode,		\
 					   struct file *filp)		\
@@ -170,6 +171,7 @@ static DEFINE_SPINLOCK(svs_lock);
 	}
 
 #define svs_dentry_data(name)	{__stringify(name), &svs_##name##_debug_fops}
+#endif
 
 /**
  * enum svsb_phase - svs bank phase enumeration
@@ -628,6 +630,7 @@ static int svs_adjust_pm_opp_volts(struct svs_bank *svsb)
 	return ret;
 }
 
+#ifdef CONFIG_DEBUG_FS
 static int svs_dump_debug_show(struct seq_file *m, void *p)
 {
 	struct svs_platform *svsp = (struct svs_platform *)m->private;
@@ -843,6 +846,7 @@ static int svs_create_debug_cmds(struct svs_platform *svsp)
 
 	return 0;
 }
+#endif /* CONFIG_DEBUG_FS */
 
 static u32 interpolate(u32 f0, u32 f1, u32 v0, u32 v1, u32 fx)
 {
@@ -2444,11 +2448,13 @@ static int svs_probe(struct platform_device *pdev)
 		goto svs_probe_iounmap;
 	}
 
+#ifdef CONFIG_DEBUG_FS
 	ret = svs_create_debug_cmds(svsp);
 	if (ret) {
 		dev_err(svsp->dev, "svs create debug cmds fail: %d\n", ret);
 		goto svs_probe_iounmap;
 	}
+#endif
 
 	return 0;
 
-- 
2.39.2



