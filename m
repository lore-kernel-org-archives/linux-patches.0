Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B2A347FEC;
	Sat, 12 Sep 2026 13:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218041; cv=none; b=pc5o9DXyvxoW5ICDkdSqDYXM8zRhAIAFGUyfRa22ehazmTyBME0l6fCXWLd9lTh3+qtrimoLc4TRx12ZHfASG2/U84U8nuw1BdnyEU+7RbEhgRGmKhg1zx9+xtc1obGxWYpHAXD/O47npBJ1hJOE+SMl0wo9HvoBi3fyKdooTks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218041; c=relaxed/simple;
	bh=P7JDzkHG4j1D1m/TKHOYQbwgLJrWIzBZaE2mEwVMHgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvO2EMVVJcCiN6toVAGY3a/e7UCZmeA67H5rovup5wy1mwzgiiXrdXHr6ujDM5cCe1rtBQsJYgW7NUGshbfCSKNrl3f+1ftZDhl/QAcOW+W4SSYCAryulgR0Ikdx+B+Du8Tq14MwtLWf3DN2CHjXUkNuCzU8ArT/dZefNbxLzPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvLq6Uh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvLq6Uh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDD91F000FF;
	Sat, 12 Sep 2026 13:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218040;
	bh=Nzwt0QTLO5PzN22SdPK1RCWFXe3Z72PAfMynm2yxbFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvLq6Uh22Oe8KDlJJ8JCFGgrand5lT7uouMyrRZjJrQentDbFtwRQCjK1ZiED7J6L
	 tzkU0AcUCp3R+Zd5UxWxxL1UgyOUJqCDF+JkY8nIW+2vw3uff/0mmH6/2co9zyReoA
	 u60NjE5DatkLnnzSPaW9FAhLH62y+APO6BMQ6NYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1061/1376] nvme-apple: Drop the PRP null check chicken bit
Date: Sat, 12 Sep 2026 08:58:07 +0200
Message-ID: <20260912065631.206877541@linuxfoundation.org>
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
index 8fc466588c4f2..5f745bf615fe7 100644
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
 
@@ -1130,17 +1127,6 @@ static void apple_nvme_reset_work(struct work_struct *work)
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



