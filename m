Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30EF8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7D3C433C9;
	Sun, 16 Jul 2023 20:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539820;
	bh=HsEDN0Hn+BPdg4Xsp0RUVvHd7VBJF3z+Rgt39NP/ejE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nb2ySytIjXyroX3CtZujgdvreBeXBFbW7r16oLGzhakj8aQ0QC1Jw4VdAqzQTrCJp
	 6ELimD3KyN2ZDp6VDW7hfA/LG7c5kQcM1q1NrdJhcLe/jMS3eLaVqpmbrxTRlXsHmK
	 CNeWA3YrVTiDGGZdJodr5q8ZnUOhBeU5UZsctcrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/591] drm/bridge: it6505: Move a variable assignment behind a null pointer check in receive_timing_debugfs_show()
Date: Sun, 16 Jul 2023 21:44:43 +0200
Message-ID: <20230716194927.596321115@linuxfoundation.org>
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

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 0be05a75de2916421e88e0d64b001984f54df0bd ]

The address of a data structure member was determined before
a corresponding null pointer check in the implementation of
the function “receive_timing_debugfs_show”.

Thus avoid the risk for undefined behaviour by moving the assignment
for the variable “vid” behind the null pointer check.

This issue was detected by using the Coccinelle software.

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Link: https://patchwork.freedesktop.org/patch/msgid/fa69384f-1485-142b-c4ee-3df54ac68a89@web.de
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 99123eec45511..292c4f6da04af 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -3085,7 +3085,7 @@ static ssize_t receive_timing_debugfs_show(struct file *file, char __user *buf,
 					   size_t len, loff_t *ppos)
 {
 	struct it6505 *it6505 = file->private_data;
-	struct drm_display_mode *vid = &it6505->video_info;
+	struct drm_display_mode *vid;
 	u8 read_buf[READ_BUFFER_SIZE];
 	u8 *str = read_buf, *end = read_buf + READ_BUFFER_SIZE;
 	ssize_t ret, count;
@@ -3094,6 +3094,7 @@ static ssize_t receive_timing_debugfs_show(struct file *file, char __user *buf,
 		return -ENODEV;
 
 	it6505_calc_video_info(it6505);
+	vid = &it6505->video_info;
 	str += scnprintf(str, end - str, "---video timing---\n");
 	str += scnprintf(str, end - str, "PCLK:%d.%03dMHz\n",
 			 vid->clock / 1000, vid->clock % 1000);
-- 
2.39.2



