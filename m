Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8974E324D;
	Wed, 30 Sep 2026 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785582; cv=none; b=RsK+U8Bx4oQGl+NZQSX01cRsWfrRXT7xZldV7FL0QHO0WqHjYvuSccYsKnrmgIVaomDtlHeeNFsG5iaWnXerfnqLSqtI3r38qSoVm7oTbglUnIbWG5yZvgYVGfY96sDBkGRhPLUqNy9sh0gbMMwcwcYfSP/8ov2ZwyJCQp8ofBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785582; c=relaxed/simple;
	bh=aDstJmnSt8iKTOlXqEN5PJaM1IVYPc7LxB/9+iRaIjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjqwLZN1RbayGINsdpTjyHWseZp5CcS5AVZ33IegKXoCVk6GRW5EcVkV932AgWjmkY9TjRUijSMC8rd+P2V2uF9kbffmJ+qHUSlT1OfY9yrdtvQ/d8DS6vWBaFiM2vCBC+YQ+egCkJh56Ha1wMgVvrWN1/1mVIkS2GZ1Vp3TqUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVAULzQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVAULzQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3F61F00893;
	Wed, 30 Sep 2026 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785574;
	bh=Oxc7z+pFCtKzLcHeduwfMcxfvYVe5ijWh3NAcyxfjmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVAULzQWMYpaZYKARE1VKWmlHcg+qgXLBSQ6d4RU5MIIIeZIBahkgj5EDrboWDZGL
	 jfQ5MTMBHAZdPfEGh3t4QFfXpSueqvUAhwvziamUubzjlwK+p61iOPDnOX3PUGL/3p
	 K//DFDCD5dJORWZ17yjx5A8YF06PygwXGsof2qdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 558/982] Revert "nvme-apple: Drop the PRP null check chicken bit"
Date: Wed, 30 Sep 2026 17:21:34 +0200
Message-ID: <20260930152428.759559692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

This reverts commit 201edb5f22d4d126a48fb69850a2a7f190982e59.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 6fb881f3807c5..778cd619aeebd 100644
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
 
@@ -1111,6 +1114,17 @@ static void apple_nvme_reset_work(struct work_struct *work)
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



