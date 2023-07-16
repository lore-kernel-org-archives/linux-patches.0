Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D158F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27787C433C8;
	Sun, 16 Jul 2023 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538811;
	bh=LtB4ShNcEktL5ObqaI938kmMHXVJy7/UkxlXMxx2PeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kgv4dS8UpaGgf4ozgzZetT6FC4RO9e7UNeUTWzT9C2I1q4GM/3j10TGhyQG4nMuPV
	 qs/fb9Nx9hECs7ja+jaATMxCadS06e9YAtZpkhUv2c94Wy4MAb1wfk+NZrA4yyKXMH
	 Te1IzpZBYGnZYhoAxVJyqkdDGs74GyXUv0TjHdwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Umang Jain <umang.jain@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 584/800] staging: vchiq_arm: mark vchiq_platform_init() static
Date: Sun, 16 Jul 2023 21:47:17 +0200
Message-ID: <20230716195002.655402134@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit e152c58d7a48194d6b530d8e004d650fd01568b6 ]

This function has no callers from other files, and the declaration
was removed a while ago, causing a W=1 warning:

drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c:465:5: error: no previous prototype for 'vchiq_platform_init'

Marking it static solves this problem but introduces a new warning
since gcc determines that 'g_fragments_base' is never initialized
in some kernel configurations:

In file included from include/linux/string.h:254,
                 from include/linux/bitmap.h:11,
                 from include/linux/cpumask.h:12,
                 from include/linux/mm_types_task.h:14,
                 from include/linux/mm_types.h:5,
                 from include/linux/buildid.h:5,
                 from include/linux/module.h:14,
                 from drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c:8:
In function 'memcpy_to_page',
    inlined from 'free_pagelist' at drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c:433:4:
include/linux/fortify-string.h:57:33: error: argument 2 null where non-null expected [-Werror=nonnull]
include/linux/highmem.h:427:9: note: in expansion of macro 'memcpy'
  427 |         memcpy(to + offset, from, len);
      |         ^~~~~~

Add a NULL pointer check for this in addition to the static annotation
to avoid both.

Fixes: 89cc4218f640 ("staging: vchiq_arm: drop unnecessary declarations")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Umang Jain <umang.jain@ideasonboard.com>
Link: https://lore.kernel.org/r/20230516202603.560554-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 90a3958d1f297..aa2313f3bcab8 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -415,7 +415,7 @@ free_pagelist(struct vchiq_instance *instance, struct vchiq_pagelist_info *pagel
 	pagelistinfo->scatterlist_mapped = 0;
 
 	/* Deal with any partial cache lines (fragments) */
-	if (pagelist->type >= PAGELIST_READ_WITH_FRAGMENTS) {
+	if (pagelist->type >= PAGELIST_READ_WITH_FRAGMENTS && g_fragments_base) {
 		char *fragments = g_fragments_base +
 			(pagelist->type - PAGELIST_READ_WITH_FRAGMENTS) *
 			g_fragments_size;
@@ -462,7 +462,7 @@ free_pagelist(struct vchiq_instance *instance, struct vchiq_pagelist_info *pagel
 	cleanup_pagelistinfo(instance, pagelistinfo);
 }
 
-int vchiq_platform_init(struct platform_device *pdev, struct vchiq_state *state)
+static int vchiq_platform_init(struct platform_device *pdev, struct vchiq_state *state)
 {
 	struct device *dev = &pdev->dev;
 	struct vchiq_drvdata *drvdata = platform_get_drvdata(pdev);
-- 
2.39.2



