Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A374BEE43;
	Sat, 12 Sep 2026 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229311; cv=none; b=f/5R1xthfKTlBrpPDQFrjEad9CbgM2KcAFKDwZQM0JiyU0t9DUmzRpwtP/rRLTVPL/bNBOxQajnpJ28SJOjlEBbPSK0YeGqUpW5AKM0hW2M/fFT4S6VJO8TSvwQTEcBoBOImS5iW7GbmQwL/WxeuZF6llU+1RB1A2qjjczdthxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229311; c=relaxed/simple;
	bh=nTK2YUCh7fGYnUcPGy5wYepnLhW8242giVCeOeLc5dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4IdqPpvuuwBAkac+QLYCkIrPQNh9UOR4kukcR5lcuedPtOYvHtURytnC3C1tykkzM8kndXaRb1ZzOxcZNmnlJ77if0X0zxSqt9/k5e+x9heQ5lIlC5mdW+7iFfGfMWD/9TJKmnTkxvXNRfamXC7O6Sh3HyugvizNN9OXwfZXVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6xGhnP/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6xGhnP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA651F000FF;
	Sat, 12 Sep 2026 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229310;
	bh=BP+C2VGchlAo1D4N9WXMzbNLEXqppjIh5T0IKyI3ego=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6xGhnP/+69QQ2t9ocWUzMoEnD86DuKYdAIEJJv2rJ/qmPudBk3vfpmNuTcpmAAtr
	 eNsPt2o1Qbu+KtHE2EFED0YJFcWJYhAXjPNykKKG6R7DivNHXzf6ho0vroKVkNwV98
	 +fZWSrUbfRPxmaFLJnvdgfVRNQxEbw46UCJXcVzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0565/1191] bus: mhi: ep: Fix device refcount leak in the error path of MHI device creation
Date: Sat, 12 Sep 2026 08:54:53 +0200
Message-ID: <20260912065600.938120349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 6f12862600bb70e599a614d706a095ea5f8f9858 ]

mhi_ep_create_device() takes one device reference for the UL channel and
another for the DL channel after allocating the transfer device. These
references are normally released by mhi_ep_destroy_device() before the
device itself is removed.

If dev_set_name() or device_add() fails, the error path currently drops
only one reference. The remaining channel references keep the device
from being released and leave the channels associated with a device that
was never registered.

Route both failures through a common unwind path that drops the DL
channel reference, the UL channel reference, and the initial reference
from device_initialize().

Fixes: 297c77a0f273 ("bus: mhi: ep: Add support for creating and destroying MHI EP devices")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260603195142.2189386-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index bb2935b08941a..49c58cec35110 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -1278,14 +1278,19 @@ static int mhi_ep_create_device(struct mhi_ep_cntrl *mhi_cntrl, u32 ch_id)
 	ret = dev_set_name(&mhi_dev->dev, "%s_%s",
 		     dev_name(&mhi_cntrl->mhi_dev->dev),
 		     mhi_dev->name);
-	if (ret) {
-		put_device(&mhi_dev->dev);
-		return ret;
-	}
+	if (ret)
+		goto err_put_channels;
 
 	ret = device_add(&mhi_dev->dev);
 	if (ret)
-		put_device(&mhi_dev->dev);
+		goto err_put_channels;
+
+	return 0;
+
+err_put_channels:
+	put_device(&mhi_dev->dev); /* DL channel reference */
+	put_device(&mhi_dev->dev); /* UL channel reference */
+	put_device(&mhi_dev->dev); /* device_initialize() reference */
 
 	return ret;
 }
-- 
2.53.0



