Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754F5198E70;
	Thu,  6 Jun 2024 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682937; cv=none; b=g+zgoh4TB6XNVLTjwDfru80Y1uNtxC9Joyx6S/vZEREmEG8JUU2719O0lMkt/25QppU6TGBunDsnTT4zES6baiEV7lS/0EEHRx2TVJOCa7Vq2M2n2quozBxxfaON5MIjdJ/JgL/D/Y8R8gp+dJY32RdS43mVk1Nht1jrthrUCpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682937; c=relaxed/simple;
	bh=C5obL2/HySdR11mXAom24xfy12nHSr0gss4Q3LB4t7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbrO3mn+xqoxIFgq4k9zLq4o1+avYSyM+S2VEWlua0bLIa/G+yqLej6EJsCVcEzubHs9il0neY2ZbmdNjYnC0auniF+Kble/7b38CT6FRvOfPIS8dXUjq6QjVq7PwJTeUcOeEboXS641aEATFYFTWTq+lInM/InVD+IQsYYlRJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFaJxx9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFaJxx9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56292C32781;
	Thu,  6 Jun 2024 14:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682937;
	bh=C5obL2/HySdR11mXAom24xfy12nHSr0gss4Q3LB4t7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFaJxx9nvQEGyLDtuJASaJcP9o+LMTj6EdCqGsiXiCU3DmDloVdb26XiFmMI9AV31
	 brfHpufeh999w29IjzHR6Wyhn1XHXdWzzGKKiWkXRIUNdovaXMgTCB7ORvWSl4k2oj
	 S3/MWACqoy9ENdRq4ssZ+Ltgy0bsjjsDwNh6ErcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Pavan Boddu <sai.pavan.boddu@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 089/374] i2c: cadence: Avoid fifo clear after start
Date: Thu,  6 Jun 2024 16:01:08 +0200
Message-ID: <20240606131654.864749631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 4bb7d6756947c..2fce3e84ba646 100644
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



