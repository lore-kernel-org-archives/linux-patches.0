Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2283CAA41;
	Wed, 30 Sep 2026 19:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795792; cv=none; b=WcmAa6R66ANmaOwa4OtuV9lfe7aFzagAQGygPMAuFFWq0Xv3XXb75wZORE5Zn8rwLQ1mYTtAHQGwR68c9LwjDCnARZBgGAda2RW+h+JpmducAKDBjVYav1xsuT0LtBiO1vOVjRdS1ExtOZknkMmovXvDP/1P65Uwg0YHXAL3ki0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795792; c=relaxed/simple;
	bh=KPnDKXORlhxKidBSGARCFnpazTzSdk5UiiUfESZukTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu8ws/mi3/+Pr66PQ/DB2a5d5W/2IUOtRGKGLH/zkY6S2WZpDugiJyKGre9AaFlJmE5QjcEYMtLM6QmKcau2iqLMH6fZJxEEzwDkzRkVCGv7suStv5L7xIzUa2I+YmrDWOyzha7n1fBB9zErkj+5MBBMyqc6YKY4t+U5wMAsdI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VO1jtFV+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VO1jtFV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C421F000FF;
	Wed, 30 Sep 2026 19:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795790;
	bh=2Hoy3X2/IMXzygO53QGCi07a+XyXGsCLHwbrqVb4y3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VO1jtFV+YLjc+T0Ez5kTCFu2xq6lWCOZpZfvipveIRqozCBOOKymG+0DRH0XdYuV7
	 FPb7gkVo+VLMvsvbAdvHhbBzAZC4mRFEINf8fA0JwB2w/eIfH9H/gURjLeKK665+/l
	 nqK0a8qK9cFc08R5Q22kKDKC1/+ZCd8UAY/V4dA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0685/1193] Revert "nvme-apple: Drop the PRP null check chicken bit"
Date: Wed, 30 Sep 2026 17:22:49 +0200
Message-ID: <20260930152449.468548632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit ca6b14f01d0993992d2c4bfd972c1f5c46284745.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 6e9e0b6e00369..90d85a1bf3679 100644
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
 
@@ -1125,6 +1128,17 @@ static void apple_nvme_reset_work(struct work_struct *work)
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



