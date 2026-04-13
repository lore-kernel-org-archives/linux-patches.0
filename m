Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFFF30C361;
	Mon, 13 Apr 2026 16:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097782; cv=none; b=V/OvczT+4oV6mNodGBtAgXBCQmHzQCezJql4jpnKv3L9d8UCpBg58YOzQUqEpS/lP5GJK6QQxbpGpdboPRIyP4nuZgwlErA0jeYxCeax+v+DLMf93RdbfJxppNP3pF7Ob0HPa8k1fdV5ZKORpxDDb8oPVTW96YVttkXdGUHv9pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097782; c=relaxed/simple;
	bh=GojYHFXf+10jVT6NMzFifPUxj3bcS99DYdcOLwd0sOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=As2eDOwkaAhr4/oprkvYn/XLyQJTOffkM/fp2J7DzN9eiuWZxXg1Ai0/Zg5gWtxa6fRSWCzmaZlzvkaQC8cROywdrdWxoZ/JLBVlvr3fIySJAoqUOduP3MChXBc6pFeRwM4ue1GpKBkltakGEA8mAzOGfZ1nfvOitz028yHvXvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8Q+/2Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8Q+/2Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234FBC2BCB3;
	Mon, 13 Apr 2026 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097782;
	bh=GojYHFXf+10jVT6NMzFifPUxj3bcS99DYdcOLwd0sOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8Q+/2ZhIwQSZMC81Cd2WEpAKYW3IdhJdqXKUSl7mbPlMVEQtILPARC1+aq8h+PH0
	 +4eepwSZuJDxj/iss6CFO21nFZ2mQA29yUhYPsXVRW1oLChqHuRkTViI76iZM34LBd
	 a1ZmzQs5/e6ScPxh64mnDW6tCMYiG6JllWlseH8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48dc1e8dfc92faf1124c@syzkaller.appspotmail.com,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/570] net: usb: aqc111: Do not perform PM inside suspend callback
Date: Mon, 13 Apr 2026 17:56:42 +0200
Message-ID: <20260413155840.634481451@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Z. Ivanov <zlatistiv@gmail.com>

[ Upstream commit 069c8f5aebe4d5224cf62acc7d4b3486091c658a ]

syzbot reports "task hung in rpm_resume"

This is caused by aqc111_suspend calling
the PM variant of its write_cmd routine.

The simplified call trace looks like this:

rpm_suspend()
  usb_suspend_both() - here udev->dev.power.runtime_status == RPM_SUSPENDING
    aqc111_suspend() - called for the usb device interface
      aqc111_write32_cmd()
        usb_autopm_get_interface()
          pm_runtime_resume_and_get()
            rpm_resume() - here we call rpm_resume() on our parent
              rpm_resume() - Here we wait for a status change that will never happen.

At this point we block another task which holds
rtnl_lock and locks up the whole networking stack.

Fix this by replacing the write_cmd calls with their _nopm variants

Reported-by: syzbot+48dc1e8dfc92faf1124c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=48dc1e8dfc92faf1124c
Fixes: e58ba4544c77 ("net: usb: aqc111: Add support for wake on LAN by MAGIC packet")
Signed-off-by: Nikola Z. Ivanov <zlatistiv@gmail.com>
Link: https://patch.msgid.link/20260313141643.1181386-1-zlatistiv@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/aqc111.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 00aba7e1d0b95..81093c4fb8194 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -1400,14 +1400,14 @@ static int aqc111_suspend(struct usb_interface *intf, pm_message_t message)
 		aqc111_write16_cmd_nopm(dev, AQ_ACCESS_MAC,
 					SFR_MEDIUM_STATUS_MODE, 2, &reg16);
 
-		aqc111_write_cmd(dev, AQ_WOL_CFG, 0, 0,
-				 WOL_CFG_SIZE, &wol_cfg);
-		aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-				   &aqc111_data->phy_cfg);
+		aqc111_write_cmd_nopm(dev, AQ_WOL_CFG, 0, 0,
+				      WOL_CFG_SIZE, &wol_cfg);
+		aqc111_write32_cmd_nopm(dev, AQ_PHY_OPS, 0, 0,
+					&aqc111_data->phy_cfg);
 	} else {
 		aqc111_data->phy_cfg |= AQ_LOW_POWER;
-		aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-				   &aqc111_data->phy_cfg);
+		aqc111_write32_cmd_nopm(dev, AQ_PHY_OPS, 0, 0,
+					&aqc111_data->phy_cfg);
 
 		/* Disable RX path */
 		aqc111_read16_cmd_nopm(dev, AQ_ACCESS_MAC,
-- 
2.51.0



