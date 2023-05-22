Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83704171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EBAC433EF;
	Mon, 22 May 2023 19:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784881;
	bh=480gBQqDgjGiJwXu8XZAfLNAGDrkNRLQuLgTyrE6pKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIbMkO+9xmJ5Wy3jSRO4k+s88+/vm7JnzKuwqMRDTrcdOzc474JdB2jCcdv063c7m
	 lki4yn1N3AyHy1au3QLN+nsF766938lAAdWsymbSufDtEY3up7W4Tv0G8I3v5eZUJl
	 UdMe6Yg+YZdlM/0YnIdD2ptdAxhKcJ4w/Uourwxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 233/364] media: pvrusb2: fix DVB_CORE dependency
Date: Mon, 22 May 2023 20:08:58 +0100
Message-Id: <20230522190418.525921476@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
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

[ Upstream commit 53558de2b5c4f4ee6bfcfbe34e27071c2d0073d5 ]

Now that DVB_CORE can be a loadable module, pvrusb2 can run into
a link error:

ld.lld: error: undefined symbol: dvb_module_probe
>>> referenced by pvrusb2-devattr.c
>>>               drivers/media/usb/pvrusb2/pvrusb2-devattr.o:(pvr2_lgdt3306a_attach) in archive vmlinux.a
ld.lld: error: undefined symbol: dvb_module_release
>>> referenced by pvrusb2-devattr.c
>>>               drivers/media/usb/pvrusb2/pvrusb2-devattr.o:(pvr2_dual_fe_attach) in archive vmlinux.a

Refine the Kconfig dependencies to avoid this case.

Link: https://lore.kernel.org/linux-media/20230117171055.2714621-1-arnd@kernel.org
Fixes: 7655c342dbc4 ("media: Kconfig: Make DVB_CORE=m possible when MEDIA_SUPPORT=y")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/pvrusb2/Kconfig b/drivers/media/usb/pvrusb2/Kconfig
index 9501b10b31aa5..0df10270dbdfc 100644
--- a/drivers/media/usb/pvrusb2/Kconfig
+++ b/drivers/media/usb/pvrusb2/Kconfig
@@ -37,6 +37,7 @@ config VIDEO_PVRUSB2_DVB
 	bool "pvrusb2 ATSC/DVB support"
 	default y
 	depends on VIDEO_PVRUSB2 && DVB_CORE
+	depends on VIDEO_PVRUSB2=m || DVB_CORE=y
 	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
-- 
2.39.2



