Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ED624A06D;
	Wed, 25 Feb 2026 01:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982869; cv=none; b=SyMU2MF4Ng3V+btRgG1kdhRz27WxPLUercblOBR2Z809kbdF66J9bDA3u0IVvl/i842ItGKg2+7QNsNx6NRcHL9+ZsNgX67GbnPGBP7GJxlna/afHqkC3OzRrhW3K06DoL+9XTMnemX6G9Iq3mLI/FciHGKHfSD92waDgThZY54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982869; c=relaxed/simple;
	bh=5zXYXOiRcstfDP86JLWjXPOjTpuVHLEQ2CwBrjo56Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiTDd3702jnsFlqyduCYAGp+NTbudEVT/UbcTCdp/EQ0kazdzNarVwp7WraAEFDTj30d6qQB7zWgiEVuoIeH/EKkouxOW2EMlVC1SomZs9OuhUQqFkqFUSI/+AxIYa9aqR5R25vXaxPKpbaQGMZDf3Q/TeNbTQrPBXtNvfJ3C6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXF53Xxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXF53Xxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBFDC116D0;
	Wed, 25 Feb 2026 01:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982869;
	bh=5zXYXOiRcstfDP86JLWjXPOjTpuVHLEQ2CwBrjo56Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXF53XxmHAlWVJuU56QoGcr+bidmJuHKjJL2rU6LKg9J55BR0D4AO3S/EUAhNbYXU
	 iAJCDDqQcl6r07gYC5fOMC7RDNRnxs5SwpaJ69WddtlmOHhXZncvH+GYkg4DXNugJs
	 lfjGYSIBM92hfytbGUz/4GYxB79wX+YuiekC/XCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Govindarajulu Varadarajan <govind.varadar@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 055/781] ublk: Validate SQE128 flag before accessing the cmd
Date: Tue, 24 Feb 2026 17:12:44 -0800
Message-ID: <20260225012401.054339019@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Govindarajulu Varadarajan <govind.varadar@gmail.com>

[ Upstream commit da7e4b75e50c087d2031a92f6646eb90f7045a67 ]

ublk_ctrl_cmd_dump() accesses (header *)sqe->cmd before
IO_URING_F_SQE128 flag check. This could cause out of boundary memory
access.

Move the SQE128 flag check earlier in ublk_ctrl_uring_cmd() to return
-EINVAL immediately if the flag is not set.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 6000517645e12..0ce0e537fb850 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3786,10 +3786,10 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	    issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
-	ublk_ctrl_cmd_dump(cmd);
-
 	if (!(issue_flags & IO_URING_F_SQE128))
-		goto out;
+		return -EINVAL;
+
+	ublk_ctrl_cmd_dump(cmd);
 
 	ret = ublk_check_cmd_op(cmd_op);
 	if (ret)
-- 
2.51.0



