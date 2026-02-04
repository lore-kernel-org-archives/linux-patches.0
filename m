Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19372BE7C0;
	Wed,  4 Feb 2026 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218269; cv=none; b=WCC3rwcfTIPR6f6SJmua226U2FTW5LcscsQ7HfvSYVnkV0zvx4PObmBTvRQRQR/Rp91D0I+G7k53TczRxP8XvbtD/j4TJHUT7/MNOXxXjnkNBc0Fn+Ctub3UQAF5uHckwZLw8qSo0cXnoVhN27JwRa927FqdwDveri/VCbX8+rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218269; c=relaxed/simple;
	bh=jKMBLoMnlPt5A10C8XsZVOMku/VGo4CvTwjx0tN2hak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keykfRTh778CH3+K9+a40vgImMCo3n4mhBX7RPxtwn1JS8CQN0Ete84CMd7VsxJ5PzWiqK5/g1Fo2fvvPOXhSHeJz1hIWdDxajEgBzMMCMFDmnBjm08jjrkSJTmOrFIp52XRv2F42LQPp3My98AfKDsoNrOVZRCf6NbEolihI7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjbNKWHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjbNKWHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65316C4CEF7;
	Wed,  4 Feb 2026 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218268;
	bh=jKMBLoMnlPt5A10C8XsZVOMku/VGo4CvTwjx0tN2hak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjbNKWHh0WCZ1z3KL0FNDm/JK4zALvqUB+zwWBIcPtyGy6NzQwv891xolaRzQN9fe
	 S3GmG7Y8D+PcaZqwBW1h++v1ZXKM5bdy9IxduF+u0hhfl6TwH778XkBznKW0TeR8mV
	 PWmPqOZ+TQH05inIBh0MhZW9oUk1x3625f9bmEkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Yifeng Zhao <yifeng.zhao@rock-chips.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/280] mmc: sdhci-of-dwcmshc: Prevent illegal clock reduction in HS200/HS400 mode
Date: Wed,  4 Feb 2026 15:40:08 +0100
Message-ID: <20260204143918.044596621@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 3009738a855cf938bbfc9078bec725031ae623a4 ]

When operating in HS200 or HS400 timing modes, reducing the clock frequency
below 52MHz will lead to link broken as the Rockchip DWC MSHC controller
requires maintaining a minimum clock of 52MHz in these modes.

Add a check to prevent illegal clock reduction through debugfs:

root@debian:/# echo 50000000 > /sys/kernel/debug/mmc0/clock
root@debian:/# [   30.090146] mmc0: running CQE recovery
mmc0: cqhci: Failed to halt
mmc0: cqhci: spurious TCN for tag 0
WARNING: drivers/mmc/host/cqhci-core.c:797 at cqhci_irq+0x254/0x818, CPU#1: kworker/1:0H/24
Modules linked in:
CPU: 1 UID: 0 PID: 24 Comm: kworker/1:0H Not tainted 6.19.0-rc1-00001-g09db0998649d-dirty #204 PREEMPT
Hardware name: Rockchip RK3588 EVB1 V10 Board (DT)
Workqueue: kblockd blk_mq_run_work_fn
pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : cqhci_irq+0x254/0x818
lr : cqhci_irq+0x254/0x818
...

Fixes: c6f361cba51c ("mmc: sdhci-of-dwcmshc: add support for rk3588")
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: Yifeng Zhao <yifeng.zhao@rock-chips.com>
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -236,6 +236,13 @@ static void dwcmshc_rk3568_set_clock(str
 	sdhci_writel(host, extra, reg);
 
 	if (clock <= 52000000) {
+		if (host->mmc->ios.timing == MMC_TIMING_MMC_HS200 ||
+		    host->mmc->ios.timing == MMC_TIMING_MMC_HS400) {
+			dev_err(mmc_dev(host->mmc),
+				"Can't reduce the clock below 52MHz in HS200/HS400 mode");
+			return;
+		}
+
 		/*
 		 * Disable DLL and reset both of sample and drive clock.
 		 * The bypass bit and start bit need to be set if DLL is not locked.


