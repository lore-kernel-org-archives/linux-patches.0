Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20E12116E9;
	Wed,  7 May 2025 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644152; cv=none; b=NQF3sJT9DbXzSTaEpifLqjkj5b6VYvsnhAN87HJbNeDvPlErUVFzpvVW8vZlegnE97APK78tDr6pnx5lyc9Nfr435nYwSzn8gcCl+d0q1YjbeLq3CHBHPc0C9Es6DCnexc9yisaVm50mnpXxYCWl4Bsw8kYT7Jmn8xrAhFcMixs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644152; c=relaxed/simple;
	bh=XttI6RueH+RAr5o5HXd9IrMaSNRl+k/rDeJOIMI+YO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bseFZwxamXaAT9Z4H9ZeLSiot4I9tgPid/ufvcTpeDOfuIks+pQ775wg0YqXvzHnoKTlN1TWVc0p/jOAAFtt/EwYiJqHGz/zpbX4hUwpdBHzW7EIm/qNTJMQ1yIGcnbnZgEIV+SCPDL6W2aoFCUCXWDICuSIO1235illasPjMDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXgANb00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXgANb00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42302C4CEE2;
	Wed,  7 May 2025 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644152;
	bh=XttI6RueH+RAr5o5HXd9IrMaSNRl+k/rDeJOIMI+YO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXgANb00Wnd61Gzl7XsHmwOlCoIZKw2bA3bT+OzcPQ4+iNwYDbVCHcn9AfetF3qRp
	 C6/DGwsd8hDXAcQfHHzyRr6H0wBVAT3Jj7s/aj3GvTCQaMLa5whvmPFjv129yxjFtt
	 HoTMo1MQjNfT2lehwdPzvwnt4/FQ76NJXk16xP3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Maimon <maimon.sagi@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 136/183] ptp: ocp: Fix NULL dereference in Adva board SMA sysfs operations
Date: Wed,  7 May 2025 20:39:41 +0200
Message-ID: <20250507183830.327059206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Maimon <sagi.maimon@adtran.com>

[ Upstream commit e98386d79a23c57cf179fe4138322e277aa3aa74 ]

On Adva boards, SMA sysfs store/get operations can call
__handle_signal_outputs() or __handle_signal_inputs() while the `irig`
and `dcf` pointers are uninitialized, leading to a NULL pointer
dereference in __handle_signal() and causing a kernel crash. Adva boards
don't use `irig` or `dcf` functionality, so add Adva-specific callbacks
`ptp_ocp_sma_adva_set_outputs()` and `ptp_ocp_sma_adva_set_inputs()` that
avoid invoking `irig` or `dcf` input/output routines.

Fixes: ef61f5528fca ("ptp: ocp: add Adva timecard support")
Signed-off-by: Sagi Maimon <maimon.sagi@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250429073320.33277-1-maimon.sagi@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 52 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4b7344e1816e4..605cce32a3d37 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2578,12 +2578,60 @@ static const struct ocp_sma_op ocp_fb_sma_op = {
 	.set_output	= ptp_ocp_sma_fb_set_output,
 };
 
+static int
+ptp_ocp_sma_adva_set_output(struct ptp_ocp *bp, int sma_nr, u32 val)
+{
+	u32 reg, mask, shift;
+	unsigned long flags;
+	u32 __iomem *gpio;
+
+	gpio = sma_nr > 2 ? &bp->sma_map1->gpio2 : &bp->sma_map2->gpio2;
+	shift = sma_nr & 1 ? 0 : 16;
+
+	mask = 0xffff << (16 - shift);
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	reg = ioread32(gpio);
+	reg = (reg & mask) | (val << shift);
+
+	iowrite32(reg, gpio);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return 0;
+}
+
+static int
+ptp_ocp_sma_adva_set_inputs(struct ptp_ocp *bp, int sma_nr, u32 val)
+{
+	u32 reg, mask, shift;
+	unsigned long flags;
+	u32 __iomem *gpio;
+
+	gpio = sma_nr > 2 ? &bp->sma_map2->gpio1 : &bp->sma_map1->gpio1;
+	shift = sma_nr & 1 ? 0 : 16;
+
+	mask = 0xffff << (16 - shift);
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	reg = ioread32(gpio);
+	reg = (reg & mask) | (val << shift);
+
+	iowrite32(reg, gpio);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return 0;
+}
+
 static const struct ocp_sma_op ocp_adva_sma_op = {
 	.tbl		= { ptp_ocp_adva_sma_in, ptp_ocp_adva_sma_out },
 	.init		= ptp_ocp_sma_fb_init,
 	.get		= ptp_ocp_sma_fb_get,
-	.set_inputs	= ptp_ocp_sma_fb_set_inputs,
-	.set_output	= ptp_ocp_sma_fb_set_output,
+	.set_inputs	= ptp_ocp_sma_adva_set_inputs,
+	.set_output	= ptp_ocp_sma_adva_set_output,
 };
 
 static int
-- 
2.39.5



