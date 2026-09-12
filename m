Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AA364059;
	Sat, 12 Sep 2026 08:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203139; cv=none; b=ulxKJ3Lgb644w4Tgku+0aB4oYWX5HtZMumRFPqz3cNytdBHDYvQZSnR8N84hdOJdbtI4qyI+GgA/Bb9v0XRbMtgMrP+gVKmBtpKp3/PZW8KPz7YjQtmpaLdkD36fceALvZdz3EG67mTyzdZLwodMIUFhy2B+nPYt5G1LiO4fl8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203139; c=relaxed/simple;
	bh=XyQlDPKezUSNW4Llwsv5MoWwL2vvz9ypRRoj+vtDFrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7j0BsZbsXYNye4/mLnpWiBSjtiZOXPLuJ1RLbwABGfEfgGTx09gFyRNoVinFIjlRekPoT5FAenuu3UJU0tpGdjduDZYi0RQR+ftp/5jaOnNoBkZmG+g9tidQpujcGo8HtSkbcjCXdZU6WKDhouU0P96fQpms6xM33ROp4XG50I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exe0fbE1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exe0fbE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC9E1F000FF;
	Sat, 12 Sep 2026 08:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203137;
	bh=sUJSvo/lM9N04uMjXd84DCf+weZVQsFstHuKHe5P2SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exe0fbE1XN2+x8kQADUgxv7lokWveBcR07Xy53wSysSkhQDnnLfZGhJ8gPjwuR8o+
	 IY9k8ewr+xte6INtxMG2BSSpM/F7q6teWy1NDXIOorGGQxO6hA/Sp8Sl2dZuDfp7pt
	 gOuBx1GjGFmh5upm4dZeG6LSv2OTgeL5mBb18Iq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1347/1815] nvme-apple: Drop the PRP null check chicken bit
Date: Sat, 12 Sep 2026 08:51:37 +0200
Message-ID: <20260912065720.642082789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

[ Upstream commit 8ce883fd068b7ba9ab493cd3ecca3a7ea868c375 ]

Now that we program the DMA direction correctly the NULL check that used
to make commands fail passes. Another side effect of this bit was that
non-align buffers on the admin queue were silently allowed and that's
been fixed now as well and we this don't need this chicken bit anymore.
More importantly, starting with the firmware installed with macOS 15,
which is required for M4 but can also be installed on the previous SoCs,
the controller no longer exposes this control register and any access
SErrors instead. Just drop the write entirely.

Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
Tested-by: Joshua Peisach <jpeisach@ubuntu.com>
Tested-by: Janne Grunau <j@jannau.net>
Tested-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index e67a125e9b87b..b90812ed74b1b 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -47,9 +47,6 @@
 #define APPLE_ANS_BOOT_STATUS	 0x1300
 #define APPLE_ANS_BOOT_STATUS_OK 0xde71ce55
 
-#define APPLE_ANS_UNKNOWN_CTRL	 0x24008
-#define APPLE_ANS_PRP_NULL_CHECK BIT(11)
-
 #define APPLE_ANS_LINEAR_SQ_CTRL 0x24908
 #define APPLE_ANS_LINEAR_SQ_EN	 BIT(0)
 
@@ -1143,17 +1140,6 @@ static void apple_nvme_reset_work(struct work_struct *work)
 		/* Setup the NVMMU for the maximum admin and IO queue depth */
 		writel(anv->hw->max_queue_depth - 1,
 			anv->mmio_nvme + APPLE_NVMMU_NUM_TCBS);
-
-		/*
-		 * This is probably a chicken bit: without it all commands
-		 * where any PRP is set to zero (including those that don't use
-		 * that field) fail and the co-processor complains about
-		 * "completed with err BAD_CMD-" or a "NULL_PRP_PTR_ERR" in the
-		 * syslog
-		 */
-		writel(readl(anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL) &
-			~APPLE_ANS_PRP_NULL_CHECK,
-			anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL);
 	}
 
 	/* Setup the admin queue */
-- 
2.53.0



