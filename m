Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC23E1F09B3;
	Fri, 21 Nov 2025 13:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731674; cv=none; b=d1PDsg/JU7w6iY34Eot82Zqw6t8Uf17cbiyGCaEjL/hgKvmEFeggpFvRYY5LAXbP27qg/DRbuq/Q3OVUC+VDRoBc/3Qm8ThfyR8cOfQzvBR9pH83ruQJmlcnjLCMbRRCzH4loGvEAhOiMcE/a77fdmNAxGyzsPGUWxGthIuwu6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731674; c=relaxed/simple;
	bh=ZTn0xEib5ArylGW3/frl3sW+F+Q45qidTGzIECFCWMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoTOipncsQYdYw0IAzjd4xessHudkSq3b6KN/TDvWGepuKpX1+BZN+lZ75Zt3BS4lMlrVOG3chsqOdVCuljgjj2mgcokua9qKBB21V8V8WktJgZwr4ctKWqxw4rXm7+z/7g51Lm9gC4lnJNT0k5NCtBEwoXDY0vMT0Hu1eLzbG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJBfPGjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJBfPGjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12812C4CEF1;
	Fri, 21 Nov 2025 13:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731673;
	bh=ZTn0xEib5ArylGW3/frl3sW+F+Q45qidTGzIECFCWMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJBfPGjyQB7M70ggHeyZYux9FJTdNOVa6WC9jeszwAG0CsLVf+96gH/xz6i6hG4dH
	 LI8fZmVdSSpUGgxZpNgvjqi3N61cJN9Jgxhwos6yJhRdovRykFqNEJJjAQNg8mNFg1
	 P6VgMESSYwmISQpFIFFTKOfk7jRM/wA4WNoXQr80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <rabenda.cn@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/185] riscv: acpi: avoid errors caused by probing DT devices when ACPI is used
Date: Fri, 21 Nov 2025 14:10:41 +0100
Message-ID: <20251121130144.390653670@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 194bda6d74ce7..4c430c9f017d8 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -298,11 +298,14 @@ void __init setup_arch(char **cmdline_p)
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



