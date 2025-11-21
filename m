Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7063128D0;
	Fri, 21 Nov 2025 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733215; cv=none; b=S+gWIkQwAKEdURdoADygf8sUyY3RPWOuosVHYOPgCrKk/14o7OHIig1Q3hzAbEEIon/8q/w9P4eE1JkA/WKGxD3/mA2uYjftib8YE7Q4/L7T5b620e2yelheaGKBed/YesXcOF8rD5w2tBwTzVhPE/Q3vpi9QQulKRZXcKTAFxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733215; c=relaxed/simple;
	bh=5Bj19LZyJZTLUdBlcnEgE19O4sWgh8c7P/e9IFhAn0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIAs8si4DE+5QSbit4d0xTKlW15PAW9MELCORyiX5LWNypn5n9UIRNS4iTBhRDE7V28tWw2OA1oHp7e+LEFEQ7APW6QNyyTbSATJ0kwSUl5rxlaJ5aXwQWaLQ2J7i1nSMtip5Ji0LDopP44w2vsYy6Q3Z+CcgEiwmOZK5EkKtsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJC2gGCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJC2gGCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B870C4CEF1;
	Fri, 21 Nov 2025 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733215;
	bh=5Bj19LZyJZTLUdBlcnEgE19O4sWgh8c7P/e9IFhAn0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJC2gGCsitMgn3AF8hTUQV3J1Q/HGr2cKqaYbcsMuELYO5j1TeNtiKUtvCbriB+Iz
	 YwEGWNkxtspVFuIcQ87s90d2O4DNKd7R9l0YhDNtRXGchit9aH7R4R0/rBCMXk/6m+
	 f4XcBLTAXuZIal5UZ/bfEa7J+up0k4twlcaSEQ5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <rabenda.cn@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 384/529] riscv: acpi: avoid errors caused by probing DT devices when ACPI is used
Date: Fri, 21 Nov 2025 14:11:23 +0100
Message-ID: <20251121130244.687833974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Gao <rabenda.cn@gmail.com>

[ Upstream commit 69a8b62a7aa1e54ff7623064f6507fa29c1d0d4e ]

Similar to the ARM64 commit 3505f30fb6a9s ("ARM64 / ACPI: If we chose
to boot from acpi then disable FDT"), let's not do DT hardware probing
if ACPI is enabled in early boot.  This avoids errors caused by
repeated driver probing.

Signed-off-by: Han Gao <rabenda.cn@gmail.com>
Link: https://lore.kernel.org/r/20250910112401.552987-1-rabenda.cn@gmail.com
[pjw@kernel.org: cleaned up patch description and subject]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/setup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index f598e0eb3b0a0..ee269b1c99a19 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -318,11 +318,14 @@ void __init setup_arch(char **cmdline_p)
 	/* Parse the ACPI tables for possible boot-time configuration */
 	acpi_boot_table_init();
 
+	if (acpi_disabled) {
 #if IS_ENABLED(CONFIG_BUILTIN_DTB)
-	unflatten_and_copy_device_tree();
+		unflatten_and_copy_device_tree();
 #else
-	unflatten_device_tree();
+		unflatten_device_tree();
 #endif
+	}
+
 	misc_mem_init();
 
 	init_resources();
-- 
2.51.0



