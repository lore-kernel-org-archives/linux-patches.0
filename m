Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4C780030;
	Wed, 21 Feb 2024 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521989; cv=none; b=EJEyE4lEvzimjJL6hQoLLR2G9k33owSTIjpNkfRK+dc4vvm1LaM6MLICLy2Unx/XNG6XFI6sqlh79x7otjmm/959LmTf/+yzwMuSgTE7b58vrawE+UHzzwMCvc6npRCOnjZIXGyDp+NuXzxz4Nc8P8/NM7OCoLnm6DyfKV8Zedk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521989; c=relaxed/simple;
	bh=MMG8JtF6iB2q8ScevwTzt6D3TqhPCgw4YKcza5ke048=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IS71I3f8jS63U43rGYuSADaOvXB6Wh2j9HZZ3hzBQYpuP7BltG1epUBZ1yqtQ/KgoksGX2v5Osnru3XpYJDI5WkCEuIzhICn2SGDJPZmB6CBesJ8de5WbAmcpIonwdonuz23VYz8eriRrbQToAbtCY7kaNMK+ScIH69urRid9oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2dsZ8gm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2dsZ8gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23688C43390;
	Wed, 21 Feb 2024 13:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521989;
	bh=MMG8JtF6iB2q8ScevwTzt6D3TqhPCgw4YKcza5ke048=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2dsZ8gmx06lZmuvOL5y1GlKRJ8X6znKREFYv1U3OCRqsGLetCrAowytwiizw+YYb
	 VildR8aKt1qV8E9NbGEooIoE2TFnwg0uN7v6iXjA4jEW+ggUAiwf/ayjz5mF6/9wAE
	 VjCY18tCr5wiTDp34v9yaf6GCnKmbWHOibNJ8Zcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/476] bnxt_en: Wait for FLR to complete during probe
Date: Wed, 21 Feb 2024 14:01:38 +0100
Message-ID: <20240221130009.675756620@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 3c1069fa42872f95cf3c6fedf80723d391e12d57 ]

The first message to firmware may fail if the device is undergoing FLR.
The driver has some recovery logic for this failure scenario but we must
wait 100 msec for FLR to complete before proceeding.  Otherwise the
recovery will always fail.

Fixes: ba02629ff6cb ("bnxt_en: log firmware status on firmware init failure")
Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20240117234515.226944-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 631639a19bad..3888561a5cc8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11925,6 +11925,11 @@ static int bnxt_fw_init_one_p1(struct bnxt *bp)
 
 	bp->fw_cap = 0;
 	rc = bnxt_hwrm_ver_get(bp);
+	/* FW may be unresponsive after FLR. FLR must complete within 100 msec
+	 * so wait before continuing with recovery.
+	 */
+	if (rc)
+		msleep(100);
 	bnxt_try_map_fw_health_reg(bp);
 	if (rc) {
 		rc = bnxt_try_recover_fw(bp);
-- 
2.43.0



