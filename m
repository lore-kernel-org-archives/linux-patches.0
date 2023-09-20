Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF52A6FBD
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23649C433CB;
	Wed, 20 Sep 2023 12:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213181;
	bh=tHA3nmvQaNgnPUJC4dgXnEr3daCQt4cMjCe4slt0XWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjnvldajks4Y5FU88+WUSxZpFTcDXSbpV+YxcwbctLqNNU5sxb6/5TCf1Zla67iKc
	 SOM1TDfxanvARBx7cMt2tD7lK02AyN3yUsS0DocnuMG0qiBsyMCCCjxZ7eHghIpjVx
	 tQ9UPiF8Gf9N7adwStKACvIujdXFpVBr64AuoCyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/367] HID: logitech-dj: Fix error handling in logi_dj_recv_switch_to_dj_mode()
Date: Wed, 20 Sep 2023 13:29:28 +0200
Message-ID: <20230920112903.578940006@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 6f20d3261265885f6a6be4cda49d7019728760e0 ]

Presently, if a call to logi_dj_recv_send_report() fails, we do
not learn about the error until after sending short
HID_OUTPUT_REPORT with hid_hw_raw_request().
To handle this somewhat unlikely issue, return on error in
logi_dj_recv_send_report() (minding ugly sleep workaround) and
take into account the result of hid_hw_raw_request().

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 6a9ddc897883 ("HID: logitech-dj: enable notifications on connect/disconnect")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20230613101635.77820-1-n.zhandarovich@fintech.ru
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index a663cbb7b6832..0c2aa9024b878 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1212,6 +1212,9 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 		 * 50 msec should gives enough time to the receiver to be ready.
 		 */
 		msleep(50);
+
+		if (retval)
+			return retval;
 	}
 
 	/*
@@ -1233,7 +1236,7 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 	buf[5] = 0x09;
 	buf[6] = 0x00;
 
-	hid_hw_raw_request(hdev, REPORT_ID_HIDPP_SHORT, buf,
+	retval = hid_hw_raw_request(hdev, REPORT_ID_HIDPP_SHORT, buf,
 			HIDPP_REPORT_SHORT_LENGTH, HID_OUTPUT_REPORT,
 			HID_REQ_SET_REPORT);
 
-- 
2.40.1



