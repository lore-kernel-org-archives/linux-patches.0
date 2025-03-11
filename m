Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED35B1684AC;
	Tue, 11 Mar 2025 15:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706716; cv=none; b=dOIq9kf4p44/ooyfUgUmlg6mrYdMGT9oIk4MjRxh8jmmbQ8lBARCBmlwND+qeCDjbwJIUhCOB7SXoBOib2IevLhTC+VhiH3e09I2kPVITugZZ++1ZjuOD/yYQiqxWYpxLEU04VA/5ow18Ux5iHTBUNcmm11j+9JDci4LEdlkcB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706716; c=relaxed/simple;
	bh=zP9IZ49SBSvdxCfs4zu8X8O8emftP9G4Q7PZ3aG91ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzBvHALO7bu+V6LdwChtx764b4ZRKjucSntcGMr63faQP1CNVZy307g/RKrNGF++5NJJ2QIHVfaK/KyRwgP5l9Uq52qF3FUniJPWEa/s/LAvzSM3/dBSJO4c5wYzLbEOguif7aVUpSiRZmxM7lzVqGbB5Ia9pXJ1QSF0vYD+KVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCeiw6fG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCeiw6fG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C90C4CEED;
	Tue, 11 Mar 2025 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706715;
	bh=zP9IZ49SBSvdxCfs4zu8X8O8emftP9G4Q7PZ3aG91ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCeiw6fGftLNzV5Aw/eKQjepU336DH6UVnj9X+RTi4zzYuNUISx6hCiIG40XXVPGd
	 PH3v8yekmeWBAbvvXN0hVkm/H+kSyP1/Xmv/7MZr/LCsILQDcIwELKkEtkIIo4ZNdM
	 34q+4H69yweKwXMSIubcdLc15WFOTc1WcNQNsoVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Tang <feng.tang@linux.alibaba.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/462] APEI: GHES: Have GHES honor the panic= setting
Date: Tue, 11 Mar 2025 15:56:47 +0100
Message-ID: <20250311145803.927474604@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@alien8.de>

[ Upstream commit 5c0e00a391dd0099fe95991bb2f962848d851916 ]

The GHES driver overrides the panic= setting by force-rebooting the
system after a fatal hw error has been reported. The intent being that
such an error would be reported earlier.

However, this is not optimal when a hard-to-debug issue requires long
time to reproduce and when that happens, the box will get rebooted after
30 seconds and thus destroy the whole hw context of when the error
happened.

So rip out the default GHES panic timeout and honor the global one.

In the panic disabled (panic=0) case, the error will still be logged to
dmesg for later inspection and if panic after a hw error is really
required, then that can be controlled the usual way - use panic= on the
cmdline or set it in the kernel .config's CONFIG_PANIC_TIMEOUT.

Reported-by: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/20250113125224.GFZ4UMiNtWIJvgpveU@fat_crate.local
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 160606af8b4f5..a6c8514110736 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -155,8 +155,6 @@ static unsigned long ghes_estatus_pool_size_request;
 static struct ghes_estatus_cache *ghes_estatus_caches[GHES_ESTATUS_CACHES_SIZE];
 static atomic_t ghes_estatus_cache_alloced;
 
-static int ghes_panic_timeout __read_mostly = 30;
-
 static void __iomem *ghes_map(u64 pfn, enum fixed_addresses fixmap_idx)
 {
 	phys_addr_t paddr;
@@ -858,14 +856,16 @@ static void __ghes_panic(struct ghes *ghes,
 			 struct acpi_hest_generic_status *estatus,
 			 u64 buf_paddr, enum fixed_addresses fixmap_idx)
 {
+	const char *msg = GHES_PFX "Fatal hardware error";
+
 	__ghes_print_estatus(KERN_EMERG, ghes->generic, estatus);
 
 	ghes_clear_estatus(ghes, estatus, buf_paddr, fixmap_idx);
 
-	/* reboot to log the error! */
 	if (!panic_timeout)
-		panic_timeout = ghes_panic_timeout;
-	panic("Fatal hardware error!");
+		pr_emerg("%s but panic disabled\n", msg);
+
+	panic(msg);
 }
 
 static int ghes_proc(struct ghes *ghes)
-- 
2.39.5



