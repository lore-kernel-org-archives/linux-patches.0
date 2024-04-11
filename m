Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6261146A70;
	Thu, 11 Apr 2024 10:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831019; cv=none; b=kHscbGVYOTrhVPNUxW7q6wwnMlqSVyFlGppT+7LhnD/NfoM1wSkek8lsgucsBuP/kve7tR2XSJnlNwxL3qChlIxLz1+CdVQwaJF14alz3GPqyGYtoNEHHPKY5HfH9QaXZUyCpWpfYt4d/cfExOgTdLZawaptv2cz4MajgiXh9PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831019; c=relaxed/simple;
	bh=NL/r75MlsalO4CqSSZ1+PTDCDy6X568eOH6hjeOUut4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mY5l3FBoesWOd052blIyO6+sXAkNRBdrpHPE2H1H8HfLnyk5H7x3BX47FLQI7PmduB73mVJZCdcwFCpCyNTM8vRII4lEnBiRICjJ65gM6jIIbk5z6oRErHXnrO/2PV5rCWVLYCHi9IfcLg3yPhwlZDqzOUHN7zNj2pmjF+a9YQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqA2By8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqA2By8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA57C433C7;
	Thu, 11 Apr 2024 10:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831019;
	bh=NL/r75MlsalO4CqSSZ1+PTDCDy6X568eOH6hjeOUut4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqA2By8thWArWeT9KQVoatj8W0QtJCTEZuGkZ7DIcDcM6UspGZ9x3A0zYPY8hVrIp
	 AGJAg1pv9yW2bJwwLhUqRj94jgQv9kTIgBHBwo24SHH8fd3s3zfbnsn+mtjReLcjOv
	 M0jUID5g2MwtW1WOrvx4xJpcW2x0lIxnfkI++xvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/215] media: sta2x11: fix irq handler cast
Date: Thu, 11 Apr 2024 11:56:38 +0200
Message-ID: <20240411095430.545389975@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 798574cfad35e..5a77f8ba3a187 100644
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



