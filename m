Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EDC4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A526C433D2;
	Wed, 15 Mar 2023 12:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882651;
	bh=m16nKKONlBrN+Xu9YyH4FcIDOK1t0bjQJODJG7N3YDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIoRXqeh0bn6Xoe0cbZa83t8gdMi7Lrb8RRw5HpDlvM52JKpRfGc+LNcc4P92p7Jl
	 uTvlA/6m5oBt7LK2PxKuRW/Lgss1NPArXKwxxFkFObkQ1kc+B6QVewKFuRTcYdfm5P
	 HZJK6dBun41K4fvI7xLbU3UwlkTKZSk6ZAhyvmVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/68] ipmi:ssif: Remove rtc_us_timer
Date: Wed, 15 Mar 2023 13:12:13 +0100
Message-Id: <20230315115726.843131232@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 9e8b89926fb87e5625bdde6fd5de2c31fb1d83bf ]

It was cruft left over from older handling of run to completion.

Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index ff93009583ab1..9f1fb8a30a823 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -248,12 +248,6 @@ struct ssif_info {
 	 */
 	bool                req_flags;
 
-	/*
-	 * Used to perform timer operations when run-to-completion
-	 * mode is on.  This is a countdown timer.
-	 */
-	int                 rtc_us_timer;
-
 	/* Used for sending/receiving data.  +1 for the length. */
 	unsigned char data[IPMI_MAX_MSG_LENGTH + 1];
 	unsigned int  data_len;
@@ -535,7 +529,6 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 
 static void start_get(struct ssif_info *ssif_info)
 {
-	ssif_info->rtc_us_timer = 0;
 	ssif_info->multi_pos = 0;
 
 	ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
@@ -627,7 +620,6 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 
 			flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
 			ssif_info->waiting_alert = true;
-			ssif_info->rtc_us_timer = SSIF_MSG_USEC;
 			if (!ssif_info->stopping)
 				mod_timer(&ssif_info->retry_timer,
 					  jiffies + SSIF_MSG_JIFFIES);
@@ -978,7 +970,6 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 			/* Wait a jiffie then request the next message */
 			ssif_info->waiting_alert = true;
 			ssif_info->retries_left = SSIF_RECV_RETRIES;
-			ssif_info->rtc_us_timer = SSIF_MSG_PART_USEC;
 			if (!ssif_info->stopping)
 				mod_timer(&ssif_info->retry_timer,
 					  jiffies + SSIF_MSG_PART_JIFFIES);
-- 
2.39.2



