Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823232737FC;
	Fri, 21 Nov 2025 13:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730909; cv=none; b=Jiz42OSKzuJWAqLG8dq0O1TBeInBa5lo6LP5FgzvS+C+pYzAFVn1aLvLO4RPz2l1cV+Kg+hlwTEsTxvW0lRgjSwnyQmox1wGFTpf7MuTTcyGFu1KcsB9l0jpc+3sz67dTreET5INeGVGK8v5TI2hHWy31Hcsdy3pOvv8XeK3cx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730909; c=relaxed/simple;
	bh=cO5oKSZMXKGYUwOIzq0FgXTQSzVbGeynsRzzKGqysn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oseN6N1ZkNgfLSqxJzSV11CJHcneklQ12XrS8F7cfBcBhrdnM/oF9cOI3UEirLcK3ru+89QyS+e+E95K8IAxThXUIVvm5X+bBFmWcbgmcFR8TJCkMIXCghawTCGDBPgQzYfWQLmS7XsR07aGmGBO94edKsTRHeynqDOm2pDzY1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KyyrR4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KyyrR4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C158C4CEF1;
	Fri, 21 Nov 2025 13:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730904;
	bh=cO5oKSZMXKGYUwOIzq0FgXTQSzVbGeynsRzzKGqysn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KyyrR4UqLoOyBbs/RLgKjgaCO4OOFEjKTKm4boVy7dA76HQLdy2gclSgDERhZOkR
	 3/ju7PIhjcDdhhQix1V0UNceOQUHwNMyebJYVG0w3rH0WQRGrQ2dLet4jtt+ob70dC
	 P79ezcnY8oNHN/yFJ/hPnXWPnxlGPPv7khCcmfwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <rabenda.cn@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 023/247] riscv: acpi: avoid errors caused by probing DT devices when ACPI is used
Date: Fri, 21 Nov 2025 14:09:30 +0100
Message-ID: <20251121130155.435186050@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f90cce7a3acea..d7ee62837aa4f 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -330,11 +330,14 @@ void __init setup_arch(char **cmdline_p)
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



