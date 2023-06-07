Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A833AE45
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98597C433EF;
	Wed,  7 Jun 2023 20:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169475;
	bh=XkrStt+XTSNlIOWptd0KbvocsSnYfjWumDVc6JiRCAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svpFzSYkxL3eT/td1Qc8k2WGNdPHQZfOauaEcBptPJ/fQKxzJZxIa7UkT6/iWIj1g
	 cyBESEhqro3Mga1BpCIG9b/OwS2vTw7oPUxfkp7QcVViWGlyClapd2j4kwGlJamErY
	 pAKAZd3XyoDJoqlT2hHLzHTIvPio1Z3odIH5VpLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jammy Huang <jammy_huang@aspeedtech.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 094/286] drm/ast: Fix ARM compatibility
Date: Wed,  7 Jun 2023 22:13:13 +0200
Message-ID: <20230607200926.132526236@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jammy Huang <jammy_huang@aspeedtech.com>

[ Upstream commit 4327a6137ed43a091d900b1ac833345d60f32228 ]

ARM architecture only has 'memory', so all devices are accessed by
MMIO if possible.

Signed-off-by: Jammy Huang <jammy_huang@aspeedtech.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230421003354.27767-1-jammy_huang@aspeedtech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index f83ce77127cb4..a6d0ee4da2b88 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -425,11 +425,12 @@ struct ast_private *ast_device_create(const struct drm_driver *drv,
 		return ERR_PTR(-EIO);
 
 	/*
-	 * If we don't have IO space at all, use MMIO now and
-	 * assume the chip has MMIO enabled by default (rev 0x20
-	 * and higher).
+	 * After AST2500, MMIO is enabled by default, and it should be adopted
+	 * to be compatible with Arm.
 	 */
-	if (!(pci_resource_flags(pdev, 2) & IORESOURCE_IO)) {
+	if (pdev->revision >= 0x40) {
+		ast->ioregs = ast->regs + AST_IO_MM_OFFSET;
+	} else if (!(pci_resource_flags(pdev, 2) & IORESOURCE_IO)) {
 		drm_info(dev, "platform has no IO space, trying MMIO\n");
 		ast->ioregs = ast->regs + AST_IO_MM_OFFSET;
 	}
-- 
2.39.2



