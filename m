Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C861C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CC5C433D6;
	Wed, 23 Nov 2022 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197012;
	bh=fJ0lPZa0ylFVhACa79Ytd26siB75fd7+pfkuz5h4/NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaDiE8IKmO+YM+h8KxCfg02Uvxw+Vr3FnQt/2E+I9Rffxq5k+zaNZfHATYmTxhydJ
	 JD5hjkWg3dIUN/LL93Wvt7p3/UFM2pKBjrcV4q6mLnPJim/oFDp20aj63BTdJm8NUk
	 tpPMf7Kf0wB2nOcLDcKvggyynOjJy34M2hw2XaUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chang <liaochang1@huawei.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 143/314] MIPS: Loongson64: Add WARN_ON on kexec related kmalloc failed
Date: Wed, 23 Nov 2022 09:49:48 +0100
Message-Id: <20221123084632.019197689@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit fa706927f4722a2df723b2a28d139b1904a3e7fa ]

Add WARN_ON on kexec related kmalloc failed, avoid to pass NULL pointer
to following memcpy and loongson_kexec_prepare.

Fixes: 6ce48897ce47 ("MIPS: Loongson64: Add kexec/kdump support")
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson64/reset.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/mips/loongson64/reset.c b/arch/mips/loongson64/reset.c
index 758d5d26aaaa..e420800043b0 100644
--- a/arch/mips/loongson64/reset.c
+++ b/arch/mips/loongson64/reset.c
@@ -16,6 +16,7 @@
 #include <asm/bootinfo.h>
 #include <asm/idle.h>
 #include <asm/reboot.h>
+#include <asm/bug.h>
 
 #include <loongson.h>
 #include <boot_param.h>
@@ -159,8 +160,17 @@ static int __init mips_reboot_setup(void)
 
 #ifdef CONFIG_KEXEC
 	kexec_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);
+	if (WARN_ON(!kexec_argv))
+		return -ENOMEM;
+
 	kdump_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);
+	if (WARN_ON(!kdump_argv))
+		return -ENOMEM;
+
 	kexec_envp = kmalloc(KEXEC_ENVP_SIZE, GFP_KERNEL);
+	if (WARN_ON(!kexec_envp))
+		return -ENOMEM;
+
 	fw_arg1 = KEXEC_ARGV_ADDR;
 	memcpy(kexec_envp, (void *)fw_arg2, KEXEC_ENVP_SIZE);
 
-- 
2.35.1



