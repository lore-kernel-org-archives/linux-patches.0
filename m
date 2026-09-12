Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC30933F59A;
	Sat, 12 Sep 2026 12:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215086; cv=none; b=mYESqNWWj0a9i4LpFrKF0WnfejMPLFn9zcFluoyrR3JGN4uXDumhbg0pphYlfGPvNJOd+eeE304Aazzi5oWPRfVp3rkwk2PcYrCOvhqldzr94A4sBQ0zeAqmwlwjt+gqb8H7v4KdH5u9LUkDdmIdlVDR0kwSYETnlYoXoyD3up0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215086; c=relaxed/simple;
	bh=vFv3rhImh1FUgQWOKNvuNfAvfXuPvMJQ+lSWfuPZYfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H30IHgoaGbksVQt794ysnOsTNFEWdIxmZVwe4T3iYs+c7MjcVi9RyR22s7G4zHj8Tc4bhDfm1p9NTPV6cZ+62ojpYzESMEgR7pXWF22spQ9wdOe8g27ju+LPwFWrn2Y5QBy/vY8P3c+ay6Dm2fM8bN5IdQPHeHFnW8fO912V0RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7j7Cf0S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7j7Cf0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08361F000FF;
	Sat, 12 Sep 2026 12:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215085;
	bh=laWDT5Jry/cwcaDzwio3e9JCSUT8qG5GMvdbdFPGjck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7j7Cf0SvikljbxXqw+yuYQo1HVdX0DgBpaJE1UZe1cDagO0t3SIHW9BoePuV+AbP
	 P1/LGeq4o8vpDwUPa9E0x5CS6tQgRf+q0ZZcfTONWwBIyvP81e0aRXoIpqIC+gZkhK
	 afsTV1LIZETHqIotcqbZvmoNeePhcXuTdG+48AZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0458/1376] bus: mhi: ep: Fix device refcount leak in the error path of MHI device creation
Date: Sat, 12 Sep 2026 08:48:04 +0200
Message-ID: <20260912065617.738388678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2f58ad0f14b65..fd1d7c84fb1c5 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -1340,14 +1340,19 @@ static int mhi_ep_create_device(struct mhi_ep_cntrl *mhi_cntrl, u32 ch_id)
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



