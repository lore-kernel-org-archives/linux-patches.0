Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E7F379C40;
	Thu, 17 Sep 2026 18:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671308; cv=none; b=s8YXlIJor5yDGWhIOeRUECPH5RF51PoVIlwsU7kWJNwOcKkvC1HKjeX3wN1vN2hSd507kL6ZSdNbGSj6sevI5k3azUL+KkPP234LQGdfIPy1kVa+yOiuxlZfklcwFu0sVlJp7p8fR+Zq/gTQ9VQTLgodgB7ld9omOmIj/gTQ7iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671308; c=relaxed/simple;
	bh=z7UGNabaQcoFKOZsVfswje1BhOQD6fp1uuMoHb9je1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TO7pBmiXVDluezA8qSjU5NRX3yUUGRc9d2QIccDUkgQyyOFtS7nFBITiFc4yivq1H1iRWVB+GW1xAd4mgtYnccCiRG0hEE0A3tpjwukXdloSIjr05b7Sv1nzjaGnViOi/9kR1hzpNuB3xEaQvBr//vuKMLLkHWIrr5TewTT4yzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5YUaeKr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5YUaeKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5359A1F000FF;
	Thu, 17 Sep 2026 18:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671306;
	bh=ILa2nMtY+5EFvRAuvdMM9fio/+m9VAX+0cbkG81pFHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5YUaeKrqMvxhH1c7YgZGkw8fWVdyjF9MYwtYa7YJlUMuBA4sTVaN8LUMihohELRi
	 DcOhGOP7Ldo7SbNtgBeWI38q0U6P9WP4BDx3lPfbItzXetw9YxvzOV+k/O/Cqcy5x9
	 BfzJFSYSaPvmN+ZU177U136iPRKO/PkK5cfzadDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0934/1102] Revert "nvme-apple: Drop the PRP null check chicken bit"
Date: Thu, 17 Sep 2026 16:14:37 +0100
Message-ID: <20260917151604.088930277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

This reverts commit 6f6a8772d275c4a520f4b3664d1a4329a0de8810.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 5f745bf615fe7..8fc466588c4f2 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -47,6 +47,9 @@
 #define APPLE_ANS_BOOT_STATUS	 0x1300
 #define APPLE_ANS_BOOT_STATUS_OK 0xde71ce55
 
+#define APPLE_ANS_UNKNOWN_CTRL	 0x24008
+#define APPLE_ANS_PRP_NULL_CHECK BIT(11)
+
 #define APPLE_ANS_LINEAR_SQ_CTRL 0x24908
 #define APPLE_ANS_LINEAR_SQ_EN	 BIT(0)
 
@@ -1127,6 +1130,17 @@ static void apple_nvme_reset_work(struct work_struct *work)
 		/* Setup the NVMMU for the maximum admin and IO queue depth */
 		writel(anv->hw->max_queue_depth - 1,
 			anv->mmio_nvme + APPLE_NVMMU_NUM_TCBS);
+
+		/*
+		 * This is probably a chicken bit: without it all commands
+		 * where any PRP is set to zero (including those that don't use
+		 * that field) fail and the co-processor complains about
+		 * "completed with err BAD_CMD-" or a "NULL_PRP_PTR_ERR" in the
+		 * syslog
+		 */
+		writel(readl(anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL) &
+			~APPLE_ANS_PRP_NULL_CHECK,
+			anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL);
 	}
 
 	/* Setup the admin queue */
-- 
2.53.0



