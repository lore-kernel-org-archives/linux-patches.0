Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B65223DD0;
	Mon, 23 Jun 2025 22:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716696; cv=none; b=Ig8wN1Dlfs9lmR6YE3Sc+rsOpqzZID2nz732GcZjH7Y9o5EmK/vA5IOUUsz50bAOdza3ZwIc5Rk6jrbCEREI/UkE26WvaJjK3Z8G7OSpTwFPSLqOfUB3NbtfdcMSj9JfNs9PLaeoLWQ8/OV+Ra5BjZJz+dKipnCNEeLJlwbf1gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716696; c=relaxed/simple;
	bh=64DdmRDep2/J5c25ywEIlI4US9613S01avGLzV/yo7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlG7D+kL7RyW9Q1q/wfrs+WjjGYMfIRuvWf78n2Fzn/xpK+ffaYw49+YbeqGr6Z+ry+lGK9y46x7MWnTIQlC2RXXVuNy9qzXi88xKV7xdp+zYUs+BNpCyFa5ZNhUnTxu1OqFlzg0uGfWUuj6cb6xIxLHj0rwFex2rkzif4AWaFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgpGS5l3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgpGS5l3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4B3C4CEEA;
	Mon, 23 Jun 2025 22:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716696;
	bh=64DdmRDep2/J5c25ywEIlI4US9613S01avGLzV/yo7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgpGS5l3zG2jTBWXzqCvTpqe5y9LcXfs34AHIAkTXbLWcq136dWsQD6Bpp9GtqrZn
	 cSGqcnvhIP8U1uCPDywIVP9TnvFLR79O0zsMx6F+GyPs+oAjZvGs6sFALgsf55qWnX
	 Xhm+kJCuJV45WQ1KPWztZUx271GAV+sUf16OINYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <rsahlberg@whamcloud.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 548/592] ublk: santizize the arguments from userspace when adding a device
Date: Mon, 23 Jun 2025 15:08:26 +0200
Message-ID: <20250623130713.478170477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index dc104c025cd56..8a482853a75ed 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2710,6 +2710,9 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
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



