Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4E08F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD78C4339C;
	Mon, 13 Feb 2023 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676299997;
	bh=SXgf2nm3QiTx8rvcpjPMpEs7JRR4WOOI6pWQhkk4SE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19W7as+R7mUPgwsS2X+kkLVEQCDvEFOKCf+Ct2Lzz7+1oAEL6BB4l5xyJbHm78FuW
	 xGkQ6N0PdrbOxi7MfPUybColVvNbCy4rjlJcd2STIomidKtVo+VrN1DK3oiPt6yjav
	 TANhiq4Ik6sDwKu3S6oWGWzcTjKRkfWD7nXiIjqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	"Erhard F." <erhard_f@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Michal Suchanek <msuchanek@suse.de>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/114] of: Make OF framebuffer device names unique
Date: Mon, 13 Feb 2023 15:47:39 +0100
Message-Id: <20230213144743.394615178@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 241d2fb56a18473af5f2ff0d512992a996eb64dd ]

Since Linux 5.19 this error is observed:

sysfs: cannot create duplicate filename '/devices/platform/of-display'

This is because multiple devices with the same name 'of-display' are
created on the same bus. Update the code to create numbered device names
for the displays.

Also, fix a node refcounting issue when exiting the boot display loop.

cc: linuxppc-dev@lists.ozlabs.org
Fixes: 52b1b46c39ae ("of: Create platform devices for OF framebuffers")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Link: https://lore.kernel.org/r/20230201162247.3575506-1-robh@kernel.org
[robh: Rework to avoid node refcount leaks]
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/platform.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3507095a69f69..6e93fd37ccd1a 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -526,6 +526,7 @@ static int __init of_platform_default_populate_init(void)
 	if (IS_ENABLED(CONFIG_PPC)) {
 		struct device_node *boot_display = NULL;
 		struct platform_device *dev;
+		int display_number = 0;
 		int ret;
 
 		/* Check if we have a MacOS display without a node spec */
@@ -556,16 +557,23 @@ static int __init of_platform_default_populate_init(void)
 			if (!of_get_property(node, "linux,opened", NULL) ||
 			    !of_get_property(node, "linux,boot-display", NULL))
 				continue;
-			dev = of_platform_device_create(node, "of-display", NULL);
+			dev = of_platform_device_create(node, "of-display.0", NULL);
+			of_node_put(node);
 			if (WARN_ON(!dev))
 				return -ENOMEM;
 			boot_display = node;
+			display_number++;
 			break;
 		}
 		for_each_node_by_type(node, "display") {
+			char buf[14];
+			const char *of_display_format = "of-display.%d";
+
 			if (!of_get_property(node, "linux,opened", NULL) || node == boot_display)
 				continue;
-			of_platform_device_create(node, "of-display", NULL);
+			ret = snprintf(buf, sizeof(buf), of_display_format, display_number++);
+			if (ret < sizeof(buf))
+				of_platform_device_create(node, buf, NULL);
 		}
 
 	} else {
-- 
2.39.0



