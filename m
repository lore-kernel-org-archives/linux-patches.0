Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DF017C77;
	Mon, 14 Oct 2024 14:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916954; cv=none; b=q7J0Kg6ss8/HPPYL/OVfbCc3H6ryPIOef+P1VfaCWYoMcOsDtNeDYgR72A7aLKhOrvUQTpMsT91TVxvzO0LW401DaPrBnXAiIA5AHmG9ZmP1LngNSoDU1F74eeg9gcP2HfzCvEckS9sbTJjBW+/Ynd8xqdBcm6TVieO7O3X0/ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916954; c=relaxed/simple;
	bh=U1Q7bXgu9ewmONYD0NId9IaXaFIcs5u95GqfyjpG8rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpEwEdnmQIyLcWCzcgwxy0PppY03kBhvRgw+Y/2QUGKHya3pITl8IYWuvs/FCwmy3Ins2qcTgwb8vYcqt0A49DVR51fmts2xl4L6c5oGE4HKRipLpLjl7FohzPoyeqTad5QSPSgyNnscp6PHBdM+hWw7/1EatkLVFugO8NBGQ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWykj3Qa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWykj3Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B1EC4CEC7;
	Mon, 14 Oct 2024 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916954;
	bh=U1Q7bXgu9ewmONYD0NId9IaXaFIcs5u95GqfyjpG8rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWykj3QakThAwAGUT3lThif5f9g0IOnS7drjtc/GPuiWe37qWKA079hXgXZAa20f0
	 837gMRISs2Dx1jHYdTroU+wPAu92SUAxGguDy15rPahlHab17vzJMgJlg6Uydd7SzR
	 AcPUYVpLM3D9sgyxgdoTO4km4rrSYgb7hH6Usy+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/213] ntb: ntb_hw_switchtec: Fix use after free vulnerability in switchtec_ntb_remove due to race condition
Date: Mon, 14 Oct 2024 16:19:45 +0200
Message-ID: <20241014141046.063387683@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixin Wang <kxwang23@m.fudan.edu.cn>

[ Upstream commit e51aded92d42784313ba16c12f4f88cc4f973bbb ]

In the switchtec_ntb_add function, it can call switchtec_ntb_init_sndev
function, then &sndev->check_link_status_work is bound with
check_link_status_work. switchtec_ntb_link_notification may be called
to start the work.

If we remove the module which will call switchtec_ntb_remove to make
cleanup, it will free sndev through kfree(sndev), while the work
mentioned above will be used. The sequence of operations that may lead
to a UAF bug is as follows:

CPU0                                 CPU1

                        | check_link_status_work
switchtec_ntb_remove    |
kfree(sndev);           |
                        | if (sndev->link_force_down)
                        | // use sndev

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in switchtec_ntb_remove.

Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index d6bbcc7b5b90d..0a94c634ddc27 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -1554,6 +1554,7 @@ static void switchtec_ntb_remove(struct device *dev)
 	switchtec_ntb_deinit_db_msg_irq(sndev);
 	switchtec_ntb_deinit_shared_mw(sndev);
 	switchtec_ntb_deinit_crosslink(sndev);
+	cancel_work_sync(&sndev->check_link_status_work);
 	kfree(sndev);
 	dev_info(dev, "ntb device unregistered\n");
 }
-- 
2.43.0



