Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABF046E004;
	Tue, 21 Jul 2026 19:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661061; cv=none; b=n+jjvwfY/r+VF6lcRJcX7TSjo33gtJunt2wBeaKUJi9M2gN2IRUPxX1BfbDb+8svknUXDlc0MI8I+jU51z7lMuwJ+nsdCTJSIiqHIWEZFi/KeF4zTK9iyHg7+1MZYm1oB4hD6wdc93Bo9s4VP52xb5MZsKJAQUg0lH8TLUfN1L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661061; c=relaxed/simple;
	bh=K76ZH9b4hxxFa98c+N7g494BIebEtrmrUp5qG/lGcEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbFh0sXAH/odDBC9gRbcWfAhA9TmJi+PtpFJZpJuBTwoCxxwbwL1QZoNRTnGLRGBUmzYIZrSU9p0Fl7hzhe8UbRZV9HTeunRLs3UTIFP9r8n3KMTjNV6YjQblAjJxEK0E8fHUrVeIRE9O5xOyyz+T6SqGqKD2DPkxBYZDOYdwj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nwx9WR/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nwx9WR/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0596C1F000E9;
	Tue, 21 Jul 2026 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661060;
	bh=UChVStfWC/Q3ApnFLpJDSFA9XqQKMbAH9xExmuuIYPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nwx9WR/XuXar5J1j0ugAbVa3LJLL0VN3Ug5I0ZJjjGReuQOfldBZ7IBg9a/OK9s8n
	 Ch5XIil1c3SfrGFu5D9eoVEpTxra3NIltKaw5RhKuLV4l7iHSwWejJ5tzMcWh1vxyY
	 G1NRWqdvUj31oVQW+a6i6dtVUHOAGb+HPFTwGlBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1216/2077] rtc: msc313: fix NULL deref in shared IRQ handler at probe
Date: Tue, 21 Jul 2026 17:14:49 +0200
Message-ID: <20260721152621.495279359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit a369f48be8de426a7d2bca18dbd46c2ad1138803 ]

msc313_rtc_probe() calls devm_request_irq() with IRQF_SHARED and
&pdev->dev as the cookie, but platform_set_drvdata() is only called
later after the clock setup. With a shared IRQ line, another device
on the same line can trigger the handler in that window. The
handler does dev_get_drvdata() on the cookie, gets NULL, and
dereferences priv->rtc_base in interrupt context.

Pass priv as the cookie directly so the handler reads it from
dev_id without the lookup, removing the dependency on probe order.

Fixes: be7d9c9161b9 ("rtc: Add support for the MSTAR MSC313 RTC")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260511032703.48262-1-sozdayvek@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-msc313.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-msc313.c b/drivers/rtc/rtc-msc313.c
index 8d7737e0e2e02c..6ef9c4efd7c92e 100644
--- a/drivers/rtc/rtc-msc313.c
+++ b/drivers/rtc/rtc-msc313.c
@@ -160,7 +160,7 @@ static const struct rtc_class_ops msc313_rtc_ops = {
 
 static irqreturn_t msc313_rtc_interrupt(s32 irq, void *dev_id)
 {
-	struct msc313_rtc *priv = dev_get_drvdata(dev_id);
+	struct msc313_rtc *priv = dev_id;
 	u16 reg;
 
 	reg = readw(priv->rtc_base + REG_RTC_STATUS_INT);
@@ -206,7 +206,7 @@ static int msc313_rtc_probe(struct platform_device *pdev)
 	priv->rtc_dev->range_max = U32_MAX;
 
 	ret = devm_request_irq(dev, irq, msc313_rtc_interrupt, IRQF_SHARED,
-			       dev_name(&pdev->dev), &pdev->dev);
+			       dev_name(&pdev->dev), priv);
 	if (ret) {
 		dev_err(dev, "Could not request IRQ\n");
 		return ret;
-- 
2.53.0



