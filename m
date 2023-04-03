Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE386FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C77C433EF;
	Mon,  3 Apr 2023 14:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532299;
	bh=XUlcWoUW+KDtBHjGCUOL1/ueJjtMd/b3JHYVLsv9gCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huNucVfyJehMidx47euTjxQxKOOGZkUYc5xoa5wI0xDZnjMfXc9lC4ZImjGDbewGw
	 PGlb+ZZAJYmMAw3RSnXXfQyREWXj2x2DoNEBqrQvflcUR1lVZVC2DIn4RUZwHlhR2Y
	 FrQAKfPkT3oiow7wYWctRgNhzUtbRgPkuI93jbRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/99] platform/x86: think-lmi: Add possible_values for ThinkStation
Date: Mon,  3 Apr 2023 16:08:53 +0200
Message-Id: <20230403140404.263734739@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
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

[ Upstream commit 8a02d70679fc1c434401863333c8ea7dbf201494 ]

ThinkStation platforms don't support the API to return possible_values
but instead embed it in the settings string.

Try and extract this information and set the possible_values attribute
appropriately.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230320003221.561750-4-mpearson-lenovo@squebb.ca
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index b7428f5ec4c4c..c9ed2644bb8a6 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -943,6 +943,26 @@ static int tlmi_analyze(void)
 			if (ret || !setting->possible_values)
 				pr_info("Error retrieving possible values for %d : %s\n",
 						i, setting->display_name);
+		} else {
+			/*
+			 * Older Thinkstations don't support the bios_selections API.
+			 * Instead they store this as a [Optional:Option1,Option2] section of the
+			 * name string.
+			 * Try and pull that out if it's available.
+			 */
+			char *item, *optstart, *optend;
+
+			if (!tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID)) {
+				optstart = strstr(item, "[Optional:");
+				if (optstart) {
+					optstart += strlen("[Optional:");
+					optend = strstr(optstart, "]");
+					if (optend)
+						setting->possible_values =
+							kstrndup(optstart, optend - optstart,
+									GFP_KERNEL);
+				}
+			}
 		}
 		/*
 		 * firmware-attributes requires that possible_values are separated by ';' but
-- 
2.39.2



