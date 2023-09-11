Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DDA1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059FBC433C8;
	Mon, 11 Sep 2023 14:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442499;
	bh=lT6Y6VuUTqiZD5penofz4qKci4XpU04WxZ/HbU2kY8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4u1N32SDATNP8C3B4rLkl+Rc/cmK7E62hTj6UOVzbYWgb6tYxo82LaZivAxq78dr
	 6Jhe1phwoCuaa+r/P0tJ8Ul2kpmcWkAp52D2oVZoxcJIG7kj00dzUQYtjqb0eSGknV
	 d5xkdQGz0Q77R4nXJ7rdCnIJ9slp0i68w/rSqMAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihong Dong <donmor3000@hotmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 046/737] LoongArch: Fix CMDLINE_EXTEND and CMDLINE_BOOTLOADER handling
Date: Mon, 11 Sep 2023 15:38:25 +0200
Message-ID: <20230911134651.735440304@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihong Dong <donmor3000@hotmail.com>

[ Upstream commit 83da30d73b86ab5898fb84f8b49c11557c3fcc67 ]

On FDT systems these command line processing are already taken care of
by early_init_dt_scan_chosen(). Add similar handling to the ACPI (non-
FDT) code path to allow these config options to work for ACPI (non-FDT)
systems too.

Signed-off-by: Zhihong Dong <donmor3000@hotmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/setup.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 78a00359bde3c..9d830ab4e3025 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -332,9 +332,25 @@ static void __init bootcmdline_init(char **cmdline_p)
 			strlcat(boot_command_line, " ", COMMAND_LINE_SIZE);
 
 		strlcat(boot_command_line, init_command_line, COMMAND_LINE_SIZE);
+		goto out;
 	}
 #endif
 
+	/*
+	 * Append built-in command line to the bootloader command line if
+	 * CONFIG_CMDLINE_EXTEND is enabled.
+	 */
+	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) && CONFIG_CMDLINE[0]) {
+		strlcat(boot_command_line, " ", COMMAND_LINE_SIZE);
+		strlcat(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+	}
+
+	/*
+	 * Use built-in command line if the bootloader command line is empty.
+	 */
+	if (IS_ENABLED(CONFIG_CMDLINE_BOOTLOADER) && !boot_command_line[0])
+		strscpy(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+
 out:
 	*cmdline_p = boot_command_line;
 }
-- 
2.40.1



