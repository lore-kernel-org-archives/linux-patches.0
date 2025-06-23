Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220692192EC;
	Mon, 23 Jun 2025 22:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717436; cv=none; b=Dp3jz6dTLcYs80qPPkefALRCOdZTLsOzPT7jK5twR6pHHuFVuUegTaTcwv3K2SCdwV/KMXWUJHwg0f3UsJfNFIZZOIpVoLqWO71OyGd1nt8sYqVEQJoJzZVc0qGPnSO9SneVRBYzB8a3d44g5UmElKHSHS5VVjPgJUHt+cB9I2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717436; c=relaxed/simple;
	bh=pRVzdiz1aERjS2hPK93DSL0+HibmYJfBLiK+mcYVuHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPWKynz8B89Zzcg6pIQwVKc6+EBdPLOhd9I8ixNA4PM+p4iwCIArLAuG5ODFWVc75Ge/jZ8jbJKO2qxfZ200PdjXRon6TxlD7GAb2JAnNLGZB8gjv3/hE3Obotpn27ii0ROCjy52fGhBld6Wg0Oa+eyuxGdt3R+RGzxEa+Aj65w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAfUcLcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAfUcLcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C54C4CEEA;
	Mon, 23 Jun 2025 22:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717436;
	bh=pRVzdiz1aERjS2hPK93DSL0+HibmYJfBLiK+mcYVuHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAfUcLcFUmjx8YqAWOD8qihzoUYVmYXR3SnETemFX/tV6IutyT/io6OqdM0PTnaoT
	 ZXJoZtPRYlw//6mgmDg7Qa7H/yjiiZHMHWFTFuxNQ3F2Pogk+1QYxnB5sMHg/y3LNe
	 RsnF1OWmr9FUutYVIB1SsxOZSrhPoQGQOWz3pH2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <rsahlberg@whamcloud.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 387/414] ublk: santizize the arguments from userspace when adding a device
Date: Mon, 23 Jun 2025 15:08:44 +0200
Message-ID: <20250623130651.621997975@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ronnie Sahlberg <rsahlberg@whamcloud.com>

[ Upstream commit 8c8472855884355caf3d8e0c50adf825f83454b2 ]

Sanity check the values for queue depth and number of queues
we get from userspace when adding a device.

Signed-off-by: Ronnie Sahlberg <rsahlberg@whamcloud.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Fixes: 62fe99cef94a ("ublk: add read()/write() support for ublk char device")
Link: https://lore.kernel.org/r/20250619021031.181340-1-ronniesahlberg@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index a01a547c562f3..746ef36e58df2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2457,6 +2457,9 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (copy_from_user(&info, argp, sizeof(info)))
 		return -EFAULT;
 
+	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || info.nr_hw_queues > UBLK_MAX_NR_QUEUES)
+		return -EINVAL;
+
 	if (capable(CAP_SYS_ADMIN))
 		info.flags &= ~UBLK_F_UNPRIVILEGED_DEV;
 	else if (!(info.flags & UBLK_F_UNPRIVILEGED_DEV))
-- 
2.39.5



