Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015EE2EA72C;
	Tue, 17 Jun 2025 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178462; cv=none; b=nrhDNB5OjNBiSfT8pZHokNBZ+sf2CXL8sWuFX6hiBDNxsRjEZHZsg6eGLwvdNrk95ITIFgYPJaN9/GKetoT/OWjAfJ7mhX/JF9B2RH2FB+2fqk7jdplpWq7eLRNeUov7rj/bjVoHwXF2b1kY64Cnffp7USyO3tofzBCQbEBwz90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178462; c=relaxed/simple;
	bh=9b8p/QYhNLzkaTf4+CjLU9qMu8NoDTt3skTCjD0y9Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwgdPtaEpT3U/HTo73ljA9hHY7Lhwsga9Sn/GQGLrocpji6kHiOkdyhkfrGvQCxMFqh5ZKd/u/6ntwk5JAy1BEjTj0Xn2qzUcO5znDlO1TJnROd9cJTKhA55UtoUT34zFhf962/7C9F7VMumDOmLK4/PXBiRi8ahojcq8okLhCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOjukrQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOjukrQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C247C4CEE3;
	Tue, 17 Jun 2025 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178461;
	bh=9b8p/QYhNLzkaTf4+CjLU9qMu8NoDTt3skTCjD0y9Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOjukrQxOZ3aFFXJc55eRYw6iJDsERhXyEYHzdaPsCR80btRX9lWtlPV6XR1TM43I
	 qZ4vZvppsOFPUS44WsWnw6y8WopJJRyRGQAA1Dd7iRhrpR+HH+6rmUn44rSQ0ggpNq
	 o4l9fo9kwRKzsPUFPZXQr6BQ4vcHjx0qlw1yodMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 463/780] mailbox: mchp-ipc-sbi: Fix COMPILE_TEST build error
Date: Tue, 17 Jun 2025 17:22:51 +0200
Message-ID: <20250617152510.342268937@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit d635ba4207c31940398c41caa0cedd80f3b9c9c7 ]

If COMPILE_TEST is y but RISCV_SBI is n, build fails:

drivers/mailbox/mailbox-mchp-ipc-sbi.c: In function 'mchp_ipc_sbi_chan_send':
drivers/mailbox/mailbox-mchp-ipc-sbi.c:119:23: error: storage size of 'ret' isn't known
	struct sbiret ret;
	              ^~~
  CC      drivers/nvmem/lpc18xx_otp.o
drivers/mailbox/mailbox-mchp-ipc-sbi.c:121:15: error: implicit declaration of function 'sbi_ecall' [-Werror=implicit-function-declaration]
	ret = sbi_ecall(SBI_EXT_MICROCHIP_TECHNOLOGY, command, channel,
	      ^~~~~~~~~

move COMPILE_TEST to ARCH_MICROCHIP dependency as other drivers.

Fixes: e4b1d67e7141 ("mailbox: add Microchip IPC support")
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index ed52db272f4d0..e8445cda7c618 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -191,8 +191,8 @@ config POLARFIRE_SOC_MAILBOX
 
 config MCHP_SBI_IPC_MBOX
 	tristate "Microchip Inter-processor Communication (IPC) SBI driver"
-	depends on RISCV_SBI || COMPILE_TEST
-	depends on ARCH_MICROCHIP
+	depends on RISCV_SBI
+	depends on ARCH_MICROCHIP || COMPILE_TEST
 	help
 	  Mailbox implementation for Microchip devices with an
 	  Inter-process communication (IPC) controller.
-- 
2.39.5



