Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B692ED143;
	Thu,  3 Jul 2025 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555051; cv=none; b=uvHcj74cpIBgjuTx9UmPgkDyFjpfXQy4Jtmf2x/onsh/vDEVUoLjWc48ck5eSosX50f7KU7kiQdqQ/h9FrDoFjGxYIVjoGsbdrnz5nfGS559Op+2y2ypoihVWkUsIebXCAlO77r658hyoKT3i5jwgTMC5exzMjKxkgVanKCJZ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555051; c=relaxed/simple;
	bh=KL3+n8QzS4q/Sr6YdPE7a6+0AuWOqo/WM3/a9hPEGWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpYaJFzDQ7avgDZGnVA+7b23uHHZeE9LeRjtwJ+HRSl9qzMlKu9PGqfyV4P/2S6Ooap4hTUHeekCsZddh89np9obJV8iLbdXbUuBMtA4V3FCvQgYxf4g/WhiPZFoX0kEez57v/C4xvqaJX/d4KFUhQKlFPjM8tCcAmRjU3NhDj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3Bj90LE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3Bj90LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C057C4CEE3;
	Thu,  3 Jul 2025 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555051;
	bh=KL3+n8QzS4q/Sr6YdPE7a6+0AuWOqo/WM3/a9hPEGWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3Bj90LESw5MPQzd/cXrP+jnwTGOuQwq92CFx93ucGic8/DucBhWW6MioKaDrI7Jz
	 pmyu8hzAYnhhBewigJoXGtIxZ3gwtYRzXzYW7moNQoSg6hYxfTFFM6UUX7cIj13Jem
	 FN//X+Zkk0/3skduzuo9zIW2/SC7csM0fBWseYbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Chong Han <chong.han@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 131/263] HID: Intel-thc-hid: Intel-quicki2c: Enhance QuickI2C reset flow
Date: Thu,  3 Jul 2025 16:40:51 +0200
Message-ID: <20250703144009.618218000@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Even Xu <even.xu@intel.com>

[ Upstream commit 73f3a7415d93cf418c7625d03bce72da84344406 ]

During customer board enabling, it was found: some touch devices
prepared reset response, but either forgot sending interrupt or
THC missed reset interrupt because of timing issue. THC QuickI2C
driver depends on interrupt to read reset response, in this case,
it will cause driver waiting timeout.

This patch enhances the flow by adding manually reset response
reading after waiting for reset interrupt timeout.

Signed-off-by: Even Xu <even.xu@intel.com>
Tested-by: Chong Han <chong.han@intel.com>
Fixes: 66b59bfce6d9 ("HID: intel-thc-hid: intel-quicki2c: Complete THC QuickI2C driver")
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel-quicki2c/quicki2c-protocol.c        | 26 ++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-protocol.c b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-protocol.c
index f493df0d5dc4e..a63f8c833252d 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-protocol.c
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-protocol.c
@@ -4,6 +4,7 @@
 #include <linux/bitfield.h>
 #include <linux/hid.h>
 #include <linux/hid-over-i2c.h>
+#include <linux/unaligned.h>
 
 #include "intel-thc-dev.h"
 #include "intel-thc-dma.h"
@@ -200,6 +201,9 @@ int quicki2c_set_report(struct quicki2c_device *qcdev, u8 report_type,
 
 int quicki2c_reset(struct quicki2c_device *qcdev)
 {
+	u16 input_reg = le16_to_cpu(qcdev->dev_desc.input_reg);
+	size_t read_len = HIDI2C_LENGTH_LEN;
+	u32 prd_len = read_len;
 	int ret;
 
 	qcdev->reset_ack = false;
@@ -213,12 +217,32 @@ int quicki2c_reset(struct quicki2c_device *qcdev)
 
 	ret = wait_event_interruptible_timeout(qcdev->reset_ack_wq, qcdev->reset_ack,
 					       HIDI2C_RESET_TIMEOUT * HZ);
-	if (ret <= 0 || !qcdev->reset_ack) {
+	if (qcdev->reset_ack)
+		return 0;
+
+	/*
+	 * Manually read reset response if it wasn't received, in case reset interrupt
+	 * was missed by touch device or THC hardware.
+	 */
+	ret = thc_tic_pio_read(qcdev->thc_hw, input_reg, read_len, &prd_len,
+			       (u32 *)qcdev->input_buf);
+	if (ret) {
+		dev_err_once(qcdev->dev, "Read Reset Response failed, ret %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * Check response packet length, it's first 16 bits of packet.
+	 * If response packet length is zero, it's reset response, otherwise not.
+	 */
+	if (get_unaligned_le16(qcdev->input_buf)) {
 		dev_err_once(qcdev->dev,
 			     "Wait reset response timed out ret:%d timeout:%ds\n",
 			     ret, HIDI2C_RESET_TIMEOUT);
 		return -ETIMEDOUT;
 	}
 
+	qcdev->reset_ack = true;
+
 	return 0;
 }
-- 
2.39.5



