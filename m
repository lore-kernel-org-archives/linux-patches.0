Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33441DC745;
	Thu, 13 Feb 2025 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458772; cv=none; b=qbYMXg9IAsOwjFfbVuKNnEduq1FOfFdumoaX9PYpRTYKrXbK14q8fVLo2mAGEOnheaEP09Bxug8hx26aHlp4+aC/2NGmh0a6v0X2zMRCuulv61QQ0c3MqlYXySXyW9FKKhwaB7zBYs+7xIwUpuKDXm+yi0Gn1Rrnwli6NDdrbgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458772; c=relaxed/simple;
	bh=7XvkBoUpBtFtxoBVKvRAq4dQ3/fbgjQfBbDScnu/FfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClBjnB3cpdn0Fcq57TbVntJ8W94NQDlGCPjtk1gT3tPBKVBnfsi5hQIlM3R26fO6pkwtGmrwuC7hYUpp3IPmfO87PcXuxlCCakSJkr+iYrsyfC4DocvuJCZkfX1K72IkXIKG7wMQHrXT8+C3leGA8IhW6BDnuIn8hI9BLceSQe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxL/bK5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxL/bK5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63B6C4CED1;
	Thu, 13 Feb 2025 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458772;
	bh=7XvkBoUpBtFtxoBVKvRAq4dQ3/fbgjQfBbDScnu/FfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxL/bK5rJyGomN5wwO0pP+wvdfKlYTQPYD/+e+dGkx8K+wFQYDv46z+xgea4XLsFe
	 0MnZvYB5Dax/d1Zh8Eroa88AmFYKHAIq8KuYf84NAY9Md6BkbdbpnZ+ucrkY6PINya
	 +OdYlRCqewcv0j9i0/wfeUF5+k2gOT4ls8kI81f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Tang <feng.tang@linux.alibaba.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 074/443] APEI: GHES: Have GHES honor the panic= setting
Date: Thu, 13 Feb 2025 15:23:59 +0100
Message-ID: <20250213142443.470675041@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 07789f0b59bcd..b727724946556 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -173,8 +173,6 @@ static struct gen_pool *ghes_estatus_pool;
 static struct ghes_estatus_cache __rcu *ghes_estatus_caches[GHES_ESTATUS_CACHES_SIZE];
 static atomic_t ghes_estatus_cache_alloced;
 
-static int ghes_panic_timeout __read_mostly = 30;
-
 static void __iomem *ghes_map(u64 pfn, enum fixed_addresses fixmap_idx)
 {
 	phys_addr_t paddr;
@@ -983,14 +981,16 @@ static void __ghes_panic(struct ghes *ghes,
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



