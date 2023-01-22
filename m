Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705717E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9945C433D2;
	Sun, 22 Jan 2023 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400139;
	bh=RoeuIW9wBtVegAJaa9Tnrs49NdEuDamP2b2vYyGKqRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRsJ917XznIFRNpZULogDzC26M4A+67hdtlzBAZyfvbTgq4juwUgWmdg9XFFjhAyU
	 LYQySXyFfnRhej+sAoGwtxCSJWAMpobf8wDScTTZyCUk+JSuG7bnvQ6zqp2NycngH4
	 lZtwkfX6UJwscT2XBOo5FudpkhS1SLYfwF6R8cQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ding Hui <dinghui@sangfor.com.cn>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/55] efi: fix userspace infinite retry read efivars after EFI runtime services page fault
Date: Sun, 22 Jan 2023 16:03:56 +0100
Message-Id: <20230122150222.621078977@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ding Hui <dinghui@sangfor.com.cn>

[ Upstream commit e006ac3003080177cf0b673441a4241f77aaecce ]

After [1][2], if we catch exceptions due to EFI runtime service, we will
clear EFI_RUNTIME_SERVICES bit to disable EFI runtime service, then the
subsequent routine which invoke the EFI runtime service should fail.

But the userspace cat efivars through /sys/firmware/efi/efivars/ will stuck
and infinite loop calling read() due to efivarfs_file_read() return -EINTR.

The -EINTR is converted from EFI_ABORTED by efi_status_to_err(), and is
an improper return value in this situation, so let virt_efi_xxx() return
EFI_DEVICE_ERROR and converted to -EIO to invoker.

Cc: <stable@vger.kernel.org>
Fixes: 3425d934fc03 ("efi/x86: Handle page faults occurring while running EFI runtime services")
Fixes: 23715a26c8d8 ("arm64: efi: Recover from synchronous exceptions occurring in firmware")
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 136b9c7f9ac9..a6735f1a16d1 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -62,6 +62,7 @@ struct efi_runtime_work efi_rts_work;
 									\
 	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {			\
 		pr_warn_once("EFI Runtime Services are disabled!\n");	\
+		efi_rts_work.status = EFI_DEVICE_ERROR;			\
 		goto exit;						\
 	}								\
 									\
-- 
2.39.0



