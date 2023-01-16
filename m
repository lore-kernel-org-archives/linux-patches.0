Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245DD33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01BAC433D2;
	Mon, 16 Jan 2023 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884880;
	bh=E01V5XLMeZzO/7m/W6rpRk7DgC939qDkEyYKSOku9lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwZAEYCpZayfCVZwsYGMaz09E8aqf/P4Vsr2duTnFBwPScIwtxhhkhb9Z4fvIPU+D
	 nKrJqgB6vSz3urd+b4qf/pac6vr0QYy7LLGRK9n2/JAVarB1PIDndEyeHhz7X5DEvp
	 /EjbZ6+2q2f8QiRvYvqQA7idps4Pc4lDtSqV6WBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Heng <liheng40@huawei.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/183] efi: fix NULL-deref in init error path
Date: Mon, 16 Jan 2023 16:51:38 +0100
Message-Id: <20230116154810.686038903@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 703c13fe3c9af557d312f5895ed6a5fda2711104 ]

In cases where runtime services are not supported or have been disabled,
the runtime services workqueue will never have been allocated.

Do not try to destroy the workqueue unconditionally in the unlikely
event that EFI initialisation fails to avoid dereferencing a NULL
pointer.

Fixes: 98086df8b70c ("efi: add missed destroy_workqueue when efisubsys_init fails")
Cc: stable@vger.kernel.org
Cc: Li Heng <liheng40@huawei.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index f12cc29bd4b8..033aac6be7da 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -374,8 +374,8 @@ static int __init efisubsys_init(void)
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		pr_err("efi: Firmware registration failed.\n");
-		destroy_workqueue(efi_rts_wq);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_destroy_wq;
 	}
 
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
@@ -423,7 +423,10 @@ static int __init efisubsys_init(void)
 		generic_ops_unregister();
 err_put:
 	kobject_put(efi_kobj);
-	destroy_workqueue(efi_rts_wq);
+err_destroy_wq:
+	if (efi_rts_wq)
+		destroy_workqueue(efi_rts_wq);
+
 	return error;
 }
 
-- 
2.35.1



