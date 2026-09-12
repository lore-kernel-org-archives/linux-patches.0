Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A964837C0E2;
	Sat, 12 Sep 2026 09:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206965; cv=none; b=mMkHm/8WfWz3RafDsENRQnv6gsC3ZHVUYzKnkYwEiwSTFZa0mtV9RmRtgESWKkmiukw1pMXseWhfhVecp7uIptbKPseG778MgK8QEAz/G3dUG2oSeEYMI+tgnvNc7RVqcGCqSH8lv/XOwD0xTfi69E7MDXkpkNRC3x2oc+Hfp8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206965; c=relaxed/simple;
	bh=4dDSwIsDfhSACDglTgvuYXx+KDkJTNT4hWQsIoaFPfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdtGzQF5rZgM1Bs9LGgHpd/8pWi7gI+63HZka9SvElIqIQQIDTbitQn1dygQQpMNo4htTKcJt9cJNIZHj8K6FL617K5KJ43c5VslIvmITmN5/hpjzksEhaP0O+UAYBWsQT/JPSzGe7uhql+DA6mQvoLT7N6Fn15bsPaBK9txqoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWU7+9u8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWU7+9u8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389E51F000FF;
	Sat, 12 Sep 2026 09:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206964;
	bh=CW+IXAV+Cb7WMLr7dz874/+L2h1OmTiylJU4MAOyK00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWU7+9u85GgqyvssV+iJUQBdHSSlzr3w8iRDRUqKYiqdw2RsJOwzPauZPVH26PZw3
	 H6zSGkq10hgqK2QSq/GnKEqTI4jPg0hyWyXxFP6l4T930mbtGj1G5ewRHIlX0Nu1Kf
	 d8W4DnD5AQKEUFrIcpESl4kmZfbhg1cjizEhooqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0278/1518] bus: mhi: ep: Fix device refcount leak in the error path of MHI device creation
Date: Sat, 12 Sep 2026 08:40:47 +0200
Message-ID: <20260912065629.772009186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



