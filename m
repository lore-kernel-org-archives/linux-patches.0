Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD2A882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05F2C433D2;
	Fri, 10 Mar 2023 15:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461140;
	bh=n1qF7fzpWNzZ5zZTD0zbhX1zKEYefHOlgum6rwpaJD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBBcF261wdvQQPdr7sEDkIHkwkEY0z8rrvmyMQBq9VZGNJmHJqBnuYW7VHs0AKV4C
	 uhwlG9hSNCuIZ9rM8gpvluT0A5zbGIW6cMSvphz86mYGh9nODNA8dD/0ZAH+t/rcEp
	 wxVL4XoqDJqaH+5sBuEr3L5S1cB5NAl3XfUmfASI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Hua <hucool.lihua@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/136] watchdog: pcwd_usb: Fix attempting to access uninitialized memory
Date: Fri, 10 Mar 2023 14:42:41 +0100
Message-Id: <20230310133708.250752485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Hua <hucool.lihua@huawei.com>

[ Upstream commit 7d06c07c67100fd0f8e6b3ab7145ce789f788117 ]

The stack variable msb and lsb may be used uninitialized in function
usb_pcwd_get_temperature and usb_pcwd_get_timeleft when usb card no response.

The build waring is:
drivers/watchdog/pcwd_usb.c:336:22: error: ‘lsb’ is used uninitialized in this function [-Werror=uninitialized]
  *temperature = (lsb * 9 / 5) + 32;
                  ~~~~^~~
drivers/watchdog/pcwd_usb.c:328:21: note: ‘lsb’ was declared here
  unsigned char msb, lsb;
                     ^~~
cc1: all warnings being treated as errors
scripts/Makefile.build:250: recipe for target 'drivers/watchdog/pcwd_usb.o' failed
make[3]: *** [drivers/watchdog/pcwd_usb.o] Error 1

Fixes: b7e04f8c61a4 ("mv watchdog tree under drivers")
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20221116020706.70847-1-hucool.lihua@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/pcwd_usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 1bdaf17c1d38d..8202f0a6b0935 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -325,7 +325,8 @@ static int usb_pcwd_set_heartbeat(struct usb_pcwd_private *usb_pcwd, int t)
 static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 							int *temperature)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	usb_pcwd_send_command(usb_pcwd, CMD_READ_TEMP, &msb, &lsb);
 
@@ -341,7 +342,8 @@ static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 static int usb_pcwd_get_timeleft(struct usb_pcwd_private *usb_pcwd,
 								int *time_left)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	/* Read the time that's left before rebooting */
 	/* Note: if the board is not yet armed then we will read 0xFFFF */
-- 
2.39.2



