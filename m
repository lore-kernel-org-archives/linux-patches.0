Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9156EBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98BCC433EF;
	Tue,  7 Mar 2023 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210628;
	bh=GsLA4w0BvTbWxC+Ki2Sv7W4m/dgFu9wCanHWZ42ARVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iW8iHvjXwQFKrR6/ddsoMXucna+wSxW1qYZ2+kTY1FRYBmMrPZkDECyAHFvZVxdx2
	 DdckNB5Xe8n0cMQYw915QV0V9qQV+rF/EnlFG8e3leE5ZflHko1JCynbSmunFjN9hE
	 Dt9RzpLyLD666BMRX+JF9+holCcpkkq3USnFv370=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0603/1001] media: platform: mtk-mdp3: fix Kconfig dependencies
Date: Tue,  7 Mar 2023 17:56:15 +0100
Message-Id: <20230307170047.683258981@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e3f7feb6d89311f369dd4ad903ea62e45328cdbe ]

The new mdp3 driver uses 'select' to force-enable a couple of drivers
it depends on. This is error-prone and likely to cause dependency
loops as well as warnings like:

WARNING: unmet direct dependencies detected for VIDEO_MEDIATEK_VPU
  Depends on [n]: MEDIA_SUPPORT [=m] && MEDIA_PLATFORM_SUPPORT [=y] && MEDIA_PLATFORM_DRIVERS [=y] && V4L_MEM2MEM_DRIVERS [=n] && VIDEO_DEV [=m] && (ARCH_MEDIATEK [=y] || COMPILE_TEST [=y])
  Selected by [m]:
  - VIDEO_MEDIATEK_MDP3 [=m] && MEDIA_SUPPORT [=m] && MEDIA_PLATFORM_SUPPORT [=y] && MEDIA_PLATFORM_DRIVERS [=y] && (MTK_IOMMU [=m] || COMPILE_TEST [=y]) && VIDEO_DEV [=m] && (ARCH_MEDIATEK [=y] || COMPILE_TEST [=y]) && HAS_DMA [=y] && REMOTEPROC [=y]

This specific warning was already addressed in a previous patch,
but there are similar unnecessary 'select' statements, so turn those
into 'depends on'. This also means the dependency on ARCH_MEDIATEK
is redundant and can be dropped.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Fixes: 9195a860ef0a ("media: platform: mtk-mdp3: remove unused VIDEO_MEDIATEK_VPU config")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp3/Kconfig | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mediatek/mdp3/Kconfig b/drivers/media/platform/mediatek/mdp3/Kconfig
index 846e759a8f6a9..602329c447501 100644
--- a/drivers/media/platform/mediatek/mdp3/Kconfig
+++ b/drivers/media/platform/mediatek/mdp3/Kconfig
@@ -3,14 +3,13 @@ config VIDEO_MEDIATEK_MDP3
 	tristate "MediaTek MDP v3 driver"
 	depends on MTK_IOMMU || COMPILE_TEST
 	depends on VIDEO_DEV
-	depends on ARCH_MEDIATEK || COMPILE_TEST
 	depends on HAS_DMA
 	depends on REMOTEPROC
+	depends on MTK_MMSYS
+	depends on MTK_CMDQ
+	depends on MTK_SCP
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	select MTK_MMSYS
-	select MTK_CMDQ
-	select MTK_SCP
 	default n
 	help
 	    It is a v4l2 driver and present in MediaTek MT8183 SoC.
-- 
2.39.2



