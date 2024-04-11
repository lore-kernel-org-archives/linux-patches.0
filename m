Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1509C64CC0;
	Thu, 11 Apr 2024 10:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832204; cv=none; b=ehrKCsyek+prTX2d4k9dl9zBH6zUprseVdlcNSJoLmy4u5eMrsW57LLl9NTJ9d7mC7NmVgo0xvlmmhxlrJkU4Onz2Zg7nu6JiB77Z5X4tUJeG2ifP1qklIbm1ZYm+9xfA6kReALfYk+0SVEx9KsQ46VqNPdmTQ+5WIgeOzsLR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832204; c=relaxed/simple;
	bh=5KrGVtxZ001BmcSdcXLmjqN+y302wayJMnRh7IXao2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTnHkSRp+hv8Ni4kvvbwwMtaPv8PLigWPLz3HAk6XQj/fUlu4+OPGtuMHOtbLloA83vHgjJkz3bcMvWVkvkqTpzDCi9pbzT35gkJnJm26wLnF0FC2Gk8lt7q9sZyfz88lUOnA7MA2YFJRMvI7qPJZAW6NydbFNbckuiBqTqmtkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdwGg5nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdwGg5nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECE6C433F1;
	Thu, 11 Apr 2024 10:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832204;
	bh=5KrGVtxZ001BmcSdcXLmjqN+y302wayJMnRh7IXao2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdwGg5nfBiMOy5UmVj1Yv+2AUUI9821e7sFSrwK4t5TlLWS5v0fr6HU+yna7W+/Jy
	 eXS8MvuMYXte8AS5iGBlP8Y8cjsHRzCRR9ZF1W3g1LY6rIDKN2xPPeDddLx5Xjy+VM
	 ZBW5m8yDfiLmBBWHuwfsHnwpIRx5v8ATh9MT8DYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/294] media: sta2x11: fix irq handler cast
Date: Thu, 11 Apr 2024 11:57:06 +0200
Message-ID: <20240411095443.475139372@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3de49ae81c3a0f83a554ecbce4c08e019f30168e ]

clang-16 warns about casting incompatible function pointers:

drivers/media/pci/sta2x11/sta2x11_vip.c:1057:6: error: cast from 'irqreturn_t (*)(int, struct sta2x11_vip *)' (aka 'enum irqreturn (*)(int, struct sta2x11_vip *)') to 'irq_handler_t' (aka 'enum irqreturn (*)(int, void *)') converts to incompatible function type [-Werror,-Wcast-function-type-strict]

Change the prototype of the irq handler to the regular version with a
local variable to adjust the argument type.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil: update argument documentation]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 336df65c8af11..01ca940aecc2d 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -760,7 +760,7 @@ static const struct video_device video_dev_template = {
 /**
  * vip_irq - interrupt routine
  * @irq: Number of interrupt ( not used, correct number is assumed )
- * @vip: local data structure containing all information
+ * @data: local data structure containing all information
  *
  * check for both frame interrupts set ( top and bottom ).
  * check FIFO overflow, but limit number of log messages after open.
@@ -770,8 +770,9 @@ static const struct video_device video_dev_template = {
  *
  * IRQ_HANDLED, interrupt done.
  */
-static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
+static irqreturn_t vip_irq(int irq, void *data)
 {
+	struct sta2x11_vip *vip = data;
 	unsigned int status;
 
 	status = reg_read(vip, DVP_ITS);
@@ -1053,9 +1054,7 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
 
 	spin_lock_init(&vip->slock);
 
-	ret = request_irq(pdev->irq,
-			  (irq_handler_t) vip_irq,
-			  IRQF_SHARED, KBUILD_MODNAME, vip);
+	ret = request_irq(pdev->irq, vip_irq, IRQF_SHARED, KBUILD_MODNAME, vip);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
 		ret = -ENODEV;
-- 
2.43.0



