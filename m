Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A1B3597E;
	Mon, 23 Jun 2025 22:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716466; cv=none; b=AzAhgW10pTPwgTebiB3yQbCBVx9EUNsmLEn5NaqxUNi++yM7eHyvb0Z3diJrmQGWcGS0vyXp0uBPbe+zyG8mcnjDGNtcyzscUbmohPxCQlEXh0bax4oL53ksVy3ov7GFGmMCFw6jYmMavCUPddHkiPGwYbMG1ceTUgQ6Yynbh8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716466; c=relaxed/simple;
	bh=PBlBPuMpOtfTCaqFq9PTyk6q1o9hvVF4acKqG/1jogo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8I9AEYwIPHinWNsExELs73kaBBgn81DqQoHtjQxHGiyEdEwrRftvQ96flaZxzgLE5iWgUFbu8IWisRPF6EM7J77r4GnTbiBKQU4KFL/XbqYU0UGb3nJ1OtBCwGSDUpc1lcufvQ02hby7+z84DqgdgVp7xgR5OB8jPTWAhHs0Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXM21QKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXM21QKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE71C4CEEA;
	Mon, 23 Jun 2025 22:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716466;
	bh=PBlBPuMpOtfTCaqFq9PTyk6q1o9hvVF4acKqG/1jogo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXM21QKVnpU4IAqI14My2luKbgXa/P3sf7iy7OTZpN5/Da7cNyJ/eQKNZnha5fTke
	 ao2/oz6Ynug+p3PUDTnJkxKGo9QgsX7QCsYVo5D3T5+El/SvW+Xp8crZHL0LI81k62
	 Oyan2wHp27OVeHNjy1CJMdR5fek4jeGkEEAJPx/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <rsahlberg@whamcloud.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/290] ublk: santizize the arguments from userspace when adding a device
Date: Mon, 23 Jun 2025 15:08:46 +0200
Message-ID: <20250623130634.878848937@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 95095500f93af..df3e5aab4b5ac 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2323,6 +2323,9 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
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



