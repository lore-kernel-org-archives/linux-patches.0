Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019483;
	b=mAVl4b4ptqh3PLsg/wrz+DA7+wAOYeL5BruM73SthRWDosab2QJvQQZVOdNAhV/zzXSh
	 3SSQ2HNlSaNP7ale89LHCAirGfuhGhhmNKpvLxNrnpV/1m4sDGdXGG7/1DsaZZL9StBd3
	 Tn2gZXIj7FUhF50aP8a3gnAVpUsMkL58q2a+Q66aQwUWilnisCymS5at7q+6/FnEHd9D1
	 PlJC+sr93I9eEH7TDAmkYEMjhWbLrH7rXjaj1uDVmHgRg4pcTcg8kJNGEeP1gvP+74An+
	 wUEt+1r/nHYoBILxl3D68aLWdF90INyVXxcmac9aLnjETrW/128RAqOfqhw6zFV+vug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CSwwSLIMOxPRXRor8FOjvtZe4I4M0930bR65E+CMCgA=;
	b=Or7CWfYBwy31glNuwNlDfGg1UdhIDCNoP64w2pOL1M47xOLIKTH6OTKOnEzaqVAoDAkf
	 cCAyZQ/bT8UNq41Uti0DeXgrUt3igqHk9VAT91NPUVP6nrtKVwLoIK3GyQ0ZOYUQ3oORE
	 ZnEslmdGhndBpc/YJzhWFj2HfJ5yeKPSHpbLg8c18/uGXiCQdt+04o+UlGt9hTFkFRNzz
	 vdyQuFntC92E+aHfPBOr8395wjr/J3yzk+Kr5GE9IcflaIjvuNKT8AG0vPoMB0SV4pOgx
	 I4WUWcM4Ej9SMAsejNT/vAgxEb0+GQFzV1RH+MuU8hJXOrVv4YZejsLo2ryth4P8EDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KkOOfkR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBD5606A7CB;
	Wed, 18 Nov 2026 16:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KkOOfkR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76B51F000C4;
	Wed, 18 Nov 2026 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019483;
	bh=CSwwSLIMOxPRXRor8FOjvtZe4I4M0930bR65E+CMCgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkOOfkR0fu+jIKrXCPBHXFbHo7BPL5DlJtnV1h5/DIvhFqrkTAEZ3dzef4H2XhHsI
	 OEkso/nxfoRwBTPL6NJegdnS6ElteS8GFCxR3jng9KLNHtOezC1MamgCYAW9WF+MT+
	 9mhOcNyq/zzwE8JZN2EDuxnaAw6L6IugNwzPfbWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1610/2651] mailbox: arm_mhuv2: time out if the receiver never comes up
Date: Wed, 18 Nov 2026 15:47:30 +0100
Message-ID: <20261118150345.799267833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d4077cd49360f..0520d49966340 100644
--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -27,6 +27,7 @@
 
 #include <linux/amba/bus.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/mailbox_controller.h>
 #include <linux/mailbox/arm_mhuv2_message.h>
 #include <linux/module.h>
@@ -967,6 +968,7 @@ static int mhuv2_tx_init(struct amba_device *adev, struct mhuv2 *mhu,
 {
 	struct device *dev = mhu->mbox.dev;
 	int ret, i;
+	u32 val;
 
 	mhu->frame = SENDER_FRAME;
 	mhu->mbox.ops = &mhuv2_sender_ops;
@@ -1007,8 +1009,11 @@ static int mhuv2_tx_init(struct amba_device *adev, struct mhuv2 *mhu,
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



