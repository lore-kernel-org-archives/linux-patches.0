Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9290717730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD76C4339B;
	Mon, 15 May 2023 18:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684174008;
	bh=qUwQsvNznCDDRqWvbe412XaoqyGTuAfKS9745Akftf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kC+NpcvyjoCuVwbTR+I1iaY1MmL1uXbQ0JwsB1FIE1mArJ8NyLfq0aVfFHCmt+FB4
	 b5uOvMBELEQleTp3JhBfdiAEcKpX6m1UgpJHNJ1G9D+l1ytsTItHZUSyeUl/QloY5v
	 LP5VaPNbRTm0ANdVj8vPWGNB9sOF9UFx3xgKIsHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Joel Savitz <jsavitz@redhat.com>
Subject: [PATCH 5.4 278/282] firmware: raspberrypi: fix possible memory leak in rpi_firmware_probe()
Date: Mon, 15 May 2023 18:30:56 +0200
Message-Id: <20230515161730.708685864@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

commit 7b51161696e803fd5f9ad55b20a64c2df313f95c upstream.

In rpi_firmware_probe(), if mbox_request_channel() fails, the 'fw' will
not be freed through rpi_firmware_delete(), fix this leak by calling
kfree() in the error path.

Fixes: 1e7c57355a3b ("firmware: raspberrypi: Keep count of all consumers")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221117070636.3849773-1-yangyingliang@huawei.com
Acked-by: Joel Savitz <jsavitz@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/raspberrypi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -261,6 +261,7 @@ static int rpi_firmware_probe(struct pla
 		int ret = PTR_ERR(fw->chan);
 		if (ret != -EPROBE_DEFER)
 			dev_err(dev, "Failed to get mbox channel: %d\n", ret);
+		kfree(fw);
 		return ret;
 	}
 


