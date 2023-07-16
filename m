Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C788F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54E4C433C7;
	Sun, 16 Jul 2023 20:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540641;
	bh=SBj9yeZaNjFgb0nWw2iiJ6T4HKXt1T/B3qdNRcQm6VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1o1rdrh0jmh3LXgDjoOOlsUI3kVF2P5z/OYaVwWKBO38F+NhaplkAWC8PwsU22PC
	 UaHKrp+4C5NxE/3RXk2WdCEFlsL5Pe18PkuV/o8VL9gfJ7cdnm5hYa/BL2ytb/G8JM
	 LmOGn86M+fIUDy7O+QmDm7h9eNTY0WP/umwZfm0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Umang Jain <umang.jain@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 408/591] staging: vchiq_arm: mark vchiq_platform_init() static
Date: Sun, 16 Jul 2023 21:49:07 +0200
Message-ID: <20230716194934.469206169@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index dc33490ba7fbb..705c5e283c27b 100644
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



