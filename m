Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031414;
	b=nesFK05sdP+opScAEFxneIIrHHINe96tFOKRZqIbfHFqcgXY/a/N3Us2Rh24VquaRkS7
	 VRx094MurO+eR6Xicz3UHQgIBIrdSs0UQIUo+foO2W6I65UCHNN87FSvIS9RV+bDYDgbq
	 BQE+J8kqy7+I4XmzLgSh+WMvteoim68IFSwYVuUlTKM0EPS2gBRo28LynVd/kdHuaIZEl
	 E5S+pi18VD7rHo22aDUaV7JpSoJbp9XNEKIDHSSUjVTxfsIliu2MOjpLNtpgy3tA56ZsA
	 pgiA2hs7NBxzCFOOQRtw4IZ1hgGdiBazgwBSKwzLzekA4dXb2ppdUfXQt9EprXF16Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eItCzRK++WrqUmtK++IAZdEPnY3fV7DrUuzG07EZPXs=;
	b=MExTbpnijRZMKVyygPUTE5ev4VLwvEXzZkP1YaiTHFtlTfbhhMNLZMAVVPq351xPBfZH
	 d+gvzqFSM02fR+SSD0YzLgI0YT2EX5uyVd8AOR7D8eKerurIxaBCMfUvyGLZh9ZHWUDJP
	 UnuDPJrzg6oK2s35K7p9M14mRrtxcQLbMu8ziHvXLsCja3oVyhgy4YCWoSojoZE9jRxLW
	 jezKLzEbr3kh/5IrHt+QDMiwaR/dggBBu+ND/upFq1fCRc5TW6QzW8cH36CNzMBHnDuC+
	 vMtRVWVItgSxsuCh9CoaznhvF9ECNzTHWdc5gRY1isNckwH8PxZLlanWxrUbT/tBOug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qEr0VbIp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F34D606A31C;
	Wed, 18 Nov 2026 19:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qEr0VbIp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BA01F000C7;
	Wed, 18 Nov 2026 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031414;
	bh=eItCzRK++WrqUmtK++IAZdEPnY3fV7DrUuzG07EZPXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEr0VbIp5xgNwyIpm2YBMqdwVSfqfVigGUQUVWd/nFwAx7z380EPN56AexmMFd4BR
	 WOz/m71p5zsojnSxVqpwPixZVlKEKZvs62xBMvjt/X5CZArlCK9agr23EUTtOil1nc
	 qP89+PK1D8fedrOTrEyAPASBTDbX9b3UnCq2Q1/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1049/1756] mailbox: arm_mhuv2: time out if the receiver never comes up
Date: Wed, 18 Nov 2026 15:52:56 +0100
Message-ID: <20261118150051.920640827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 86976f7cc324aac254136a352f74ac17f21e574c ]

mhuv2_tx_init() waits forever for access_ready. Fail probe
after 1s instead of hanging boot.

Fixes: 5a6338cce9f4 ("mailbox: arm_mhuv2: Add driver")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhuv2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/arm_mhuv2.c b/drivers/mailbox/arm_mhuv2.c
index cff7c343ee082..76c274931e813 100644
--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -27,6 +27,7 @@
 
 #include <linux/amba/bus.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/mailbox_controller.h>
 #include <linux/mailbox/arm_mhuv2_message.h>
 #include <linux/module.h>
@@ -968,6 +969,7 @@ static int mhuv2_tx_init(struct amba_device *adev, struct mhuv2 *mhu,
 {
 	struct device *dev = mhu->mbox.dev;
 	int ret, i;
+	u32 val;
 
 	mhu->frame = SENDER_FRAME;
 	mhu->mbox.ops = &mhuv2_sender_ops;
@@ -1011,8 +1013,11 @@ static int mhuv2_tx_init(struct amba_device *adev, struct mhuv2 *mhu,
 out:
 	/* Wait for receiver to be ready */
 	writel_relaxed(0x1, &mhu->send->access_request);
-	while (!readl_relaxed(&mhu->send->access_ready))
-		continue;
+	if (readl_relaxed_poll_timeout(&mhu->send->access_ready, val, val,
+				       100, 1000000)) {
+		dev_err(dev, "receiver not ready\n");
+		return -ETIMEDOUT;
+	}
 
 	return 0;
 }
-- 
2.53.0



