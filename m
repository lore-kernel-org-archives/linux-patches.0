Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760E728E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF24FC433C8;
	Wed, 20 Sep 2023 11:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211071;
	bh=aTe3aYHJpMErQl9nLOlwP5+qC0Zz9ckDR14B387/OHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtn0duR2H4R3nAoMK3LnDS39yfHa+2wYO2j4Xw6DeKjXtNcPpowq+i7qomPLHSuS1
	 PYgG2daxd6XRKq31OtYSnWNHEAVkjUqQMcaOE4DGUlOOfU4wHXJ4kTxJRMQMJjkJ62
	 +Um8gZzLhFmRDRDOlbF+Ec7L+jBwHLh4YQPLc45c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/139] drm: gm12u320: Fix the timeout usage for usb_bulk_msg()
Date: Wed, 20 Sep 2023 13:30:31 +0200
Message-ID: <20230920112839.204916808@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 7583028d359db3cd0072badcc576b4f9455fd27a ]

The timeout arg of usb_bulk_msg() is ms already, which has been converted
to jiffies by msecs_to_jiffies() in usb_start_wait_urb(). So fix the usage
by removing the redundant msecs_to_jiffies() in the macros.

And as Hans suggested, also remove msecs_to_jiffies() for the IDLE_TIMEOUT
macro to make it consistent here and so change IDLE_TIMEOUT to
msecs_to_jiffies(IDLE_TIMEOUT) where it is used.

Fixes: e4f86e437164 ("drm: Add Grain Media GM12U320 driver v2")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230904021421.1663892-1-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/gm12u320.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm12u320.c
index 7441d992a5d7a..8b0a9059d3fdd 100644
--- a/drivers/gpu/drm/tiny/gm12u320.c
+++ b/drivers/gpu/drm/tiny/gm12u320.c
@@ -69,10 +69,10 @@ MODULE_PARM_DESC(eco_mode, "Turn on Eco mode (less bright, more silent)");
 #define READ_STATUS_SIZE		13
 #define MISC_VALUE_SIZE			4
 
-#define CMD_TIMEOUT			msecs_to_jiffies(200)
-#define DATA_TIMEOUT			msecs_to_jiffies(1000)
-#define IDLE_TIMEOUT			msecs_to_jiffies(2000)
-#define FIRST_FRAME_TIMEOUT		msecs_to_jiffies(2000)
+#define CMD_TIMEOUT			200
+#define DATA_TIMEOUT			1000
+#define IDLE_TIMEOUT			2000
+#define FIRST_FRAME_TIMEOUT		2000
 
 #define MISC_REQ_GET_SET_ECO_A		0xff
 #define MISC_REQ_GET_SET_ECO_B		0x35
@@ -388,7 +388,7 @@ static void gm12u320_fb_update_work(struct work_struct *work)
 	 * switches back to showing its logo.
 	 */
 	queue_delayed_work(system_long_wq, &gm12u320->fb_update.work,
-			   IDLE_TIMEOUT);
+			   msecs_to_jiffies(IDLE_TIMEOUT));
 
 	return;
 err:
-- 
2.40.1



