Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E312F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9CFC433D2;
	Wed, 12 Apr 2023 08:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288844;
	bh=/PTpr3PXJyhRBqFSQo1gHIjAiiw7J80Bkyf7OiUV9cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D61kwfUdwZUVJwtg7buE00IbN+C3cbaTZx30CeP+F9s60mnPGM2x/mp/G+fDky2X8
	 YVk59d+alMDyvuRiPNp4fVr/yRPeQlJGrdyM36VIbLbV4Ieyc+WFavzGfnf/CLfoYt
	 FsRaFDHCStRWnO4v+Tas7tZckhAX/fDhqVSP7ZFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/164] platform/x86: think-lmi: Fix memory leaks when parsing ThinkStation WMI strings
Date: Wed, 12 Apr 2023 10:32:40 +0200
Message-Id: <20230412082838.483295436@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit e7d796fccdc8d17c2d21817ebe4c7bf5bbfe5433 ]

My previous commit introduced a memory leak where the item allocated
from tlmi_setting was not freed.
This commit also renames it to avoid confusion with the similarly name
variable in the same function.

Fixes: 8a02d70679fc ("platform/x86: think-lmi: Add possible_values for ThinkStation")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/lkml/df26ff45-8933-f2b3-25f4-6ee51ccda7d8@gmx.de/T/
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230403013120.2105-1-mpearson-lenovo@squebb.ca
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 4e738ec5e6fb8..70c4ee254c43a 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1459,10 +1459,10 @@ static int tlmi_analyze(void)
 			 * name string.
 			 * Try and pull that out if it's available.
 			 */
-			char *item, *optstart, *optend;
+			char *optitem, *optstart, *optend;
 
-			if (!tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID)) {
-				optstart = strstr(item, "[Optional:");
+			if (!tlmi_setting(setting->index, &optitem, LENOVO_BIOS_SETTING_GUID)) {
+				optstart = strstr(optitem, "[Optional:");
 				if (optstart) {
 					optstart += strlen("[Optional:");
 					optend = strstr(optstart, "]");
@@ -1471,6 +1471,7 @@ static int tlmi_analyze(void)
 							kstrndup(optstart, optend - optstart,
 									GFP_KERNEL);
 				}
+				kfree(optitem);
 			}
 		}
 		/*
-- 
2.39.2



