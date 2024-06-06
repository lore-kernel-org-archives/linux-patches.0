Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407591C2309;
	Thu,  6 Jun 2024 14:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683648; cv=none; b=F72JUZMr4UFNEzO6OG+vyS7sJXV9TyB/5CEBiPciBb0s3+ymneGqqu3u6EIAp9WYbFlHKPoxf4r0sC9mjALFD//Mg65KtoZhz9BSjiz7s7B7FZcziHNXN1brsJ7EDvxy0zCq4n/CMF3RaU4xoSRxTqt2NfcC4U2fC8iOlh1yQYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683648; c=relaxed/simple;
	bh=xRX22CkQzUzzsGd4wkyvmw9pEzqmxlNvpFBQViUmEOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvRh+A9q+WMclaTWhcVUc/qsUYDRYpMh14Cj0sA+fIUssNgbZ99Xk5E12l/23+J1dzjCIzO6sFwv5hc54rGMb93NlE2tZuyNxMJOsuE8arBtGvkk+wvszFxuiZxuIfgNEorQZ7HUM5kMoZDUndJwcnAeMBiqg/eLPUXLZyiZolE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXKLXG2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXKLXG2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE37C32781;
	Thu,  6 Jun 2024 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683648;
	bh=xRX22CkQzUzzsGd4wkyvmw9pEzqmxlNvpFBQViUmEOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXKLXG2WkGz0L8EJYTeS8gFCBUhniSlaTw+0oR94UWPM17o0P2ftHWnktRsWzxh7J
	 bAbwZx7srnhXOoIYjhDYkwGIvBGfCasR7pMCaw7yfKkmo4EF3epX9VfQO0RQPLKAEb
	 ZuLec9oZW9a/O13WJvTGydQLJDH+S1Z3AsCWcR4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Pavan Boddu <sai.pavan.boddu@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 492/744] i2c: cadence: Avoid fifo clear after start
Date: Thu,  6 Jun 2024 16:02:44 +0200
Message-ID: <20240606131748.224396198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Pavan Boddu <sai.pavan.boddu@amd.com>

[ Upstream commit c2e55b449de7298a751ed0256251019d302af453 ]

The Driver unintentionally programs ctrl reg to clear the fifo, which
happens after the start of transaction. Previously, this was not an issue
as it involved read-modified-write. However, this issue breaks i2c reads
on QEMU, as i2c-read is executed before guest starts programming control
register.

Fixes: ff0cf7bca630 ("i2c: cadence: Remove unnecessary register reads")
Signed-off-by: Sai Pavan Boddu <sai.pavan.boddu@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index de3f58b60dce5..6f7d753a8197c 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -633,6 +633,7 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
 
 	if (hold_clear) {
 		ctrl_reg &= ~CDNS_I2C_CR_HOLD;
+		ctrl_reg &= ~CDNS_I2C_CR_CLR_FIFO;
 		/*
 		 * In case of Xilinx Zynq SOC, clear the HOLD bit before transfer size
 		 * register reaches '0'. This is an IP bug which causes transfer size
-- 
2.43.0



