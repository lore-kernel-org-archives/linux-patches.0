Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D392188704;
	Wed,  5 Feb 2025 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767161; cv=none; b=bECjVj6jiJjilm74PKxv3e0CGCr+L3YdRcsX83Xy6VcSuSQpGE8cix6nxRZiR5Wzbjr+b1VgLFfwx6CPy9PLwqKt/TQK0Xs65z1jtuMLTgy/QhlVjMG0/4fPQlsUWkK18nBLV53hCaX9G2MopFyHXCB+GyyT8eQmGyvLHdsEAsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767161; c=relaxed/simple;
	bh=ivAsZbZfJr7lNy7pX3WSkUhfrGg/D6moWZPN1BvS1pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWh1gY2pNw0VziMaZ7DBZ7FGOkFoHR5U7wZnY6qIKOzK+tkUtYhfDqcRNkdr+K+n6PDc/Fp7bu41O5QOIuW0P3CE5kLWnwGIyysPG2/nDG7tLB1178GAI0YVjbuZyj1E4k09la439Mp2l7rxUlTZDCof+CYLEPvhC8yhsrUF1/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6EiviPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6EiviPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7019CC4CED1;
	Wed,  5 Feb 2025 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767160;
	bh=ivAsZbZfJr7lNy7pX3WSkUhfrGg/D6moWZPN1BvS1pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6EiviPRCN7rOD90sQnNEa699aFCqpYtpblxC4XkT9wgXDPWFE/QQBVhz3pfkTLnW
	 QlLTSx8Ht4/CtIKOiciwbBf+gw0G2pGSuJ5OLJFe4QVs51nPk7DBHucQCrQjpQtDLI
	 8PLLEqAnzBPfEAMHQ9uOanqwpw2r5xaDGiGGAjmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 414/590] media: i2c: ov9282: Correct the exposure offset
Date: Wed,  5 Feb 2025 14:42:49 +0100
Message-ID: <20250205134511.104455388@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit feaf4154d69657af2bf96e6e66cca794f88b1a61 ]

The datasheet lists that "Maximum exposure time is frame
length -25 row periods, where frame length is set by
registers {0x380E, 0x380F}".
However this driver had OV9282_EXPOSURE_OFFSET set to 12
which allowed that restriction to be violated, and would
result in very under-exposed images.

Correct the offset.

Fixes: 14ea315bbeb7 ("media: i2c: Add ov9282 camera sensor driver")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov9282.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov9282.c b/drivers/media/i2c/ov9282.c
index 9f52af6f047f3..87e5d7ce5a47e 100644
--- a/drivers/media/i2c/ov9282.c
+++ b/drivers/media/i2c/ov9282.c
@@ -40,7 +40,7 @@
 /* Exposure control */
 #define OV9282_REG_EXPOSURE	0x3500
 #define OV9282_EXPOSURE_MIN	1
-#define OV9282_EXPOSURE_OFFSET	12
+#define OV9282_EXPOSURE_OFFSET	25
 #define OV9282_EXPOSURE_STEP	1
 #define OV9282_EXPOSURE_DEFAULT	0x0282
 
-- 
2.39.5



