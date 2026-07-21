Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5299646F4B4;
	Tue, 21 Jul 2026 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656409; cv=none; b=IHG12ryLDOMR6jDbTgEpACHAsl8m2csnjxpvfg/9CaQzM9xPUBtVvXgbfCvi3+YNce++zl5QZB5BEbF7C4r9K977tzXz7JjsPX0wtO0pbyMThsljuhS8wCOmZ3wEz4qxkOz7zjNQLcr80C6Vez3RRSCSiK8XI91PPX96DyiUBIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656409; c=relaxed/simple;
	bh=vPYpb9IYZGQwPtPfm31MeGESY8dv9By2Uq1wsZVPTAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkiLlF/Jp4wEaGh29aaw3iAqgxg/hwGzpJFtO7jwqyIk5059++ATE+GfCfy9rG9pZif5nDW+jtg6oPjGkWqXP2TD09GcENCCQTV+zgAtu8nx3DG7K+QQJGYOPLIQvtVR7SrGgeLEs5nzDMtJTUSNlZ3P8uLaGABuWArernVVIuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9U4OgGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9U4OgGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B040A1F00A3A;
	Tue, 21 Jul 2026 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656408;
	bh=hDbTIH+A270IIt2YLZ+EJc28IXaWf61gi6CZ1zqYB8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9U4OgGRn3DxlJUJXH0TXcgkCgFI86qFbaKUfHe20hKgA20YaOO/8dHTwGrvKqDH+
	 YtMqVvbyCcNEOwQhqBZaAjZqVJfwIEweXARwepjO18y2n/KC74hwiG+leD4pGHpJ1t
	 mLPO8L/2olpj0L5rMmXb44912wCxmvL24e9EGkuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wandun Chen <chenwandun@lixiang.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0333/1611] of: reserved_mem: avoid post-init UAF when alloc_reserved_mem_array() fails
Date: Tue, 21 Jul 2026 17:07:29 +0200
Message-ID: <20260721152522.591221445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wandun Chen <chenwandun@lixiang.com>

[ Upstream commit e1686ca81dbf3edbde589b7daf312b45cbf76e03 ]

The global pointer 'reserved_mem' continues to reference the
reserved_mem_array which lives in __initdata if
alloc_reserved_mem_array() fails. of_reserved_mem_lookup() is
exported for post-init use, that would dereference freed memory
and trigger a use-after-free.

So reset reserved_mem_count to 0 when alloc_reserved_mem_array()
fails.

Fixes: 00c9a452a235 ("of: reserved_mem: Add code to dynamically allocate reserved_mem array")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://patch.msgid.link/20260604015332.3669384-1-chenwandun1@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index fe111d1ea73971..39d8305a168006 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -71,29 +71,32 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
  * the initial static array is copied over to this new array and
  * the new array is used from this point on.
  */
-static void __init alloc_reserved_mem_array(void)
+static int __init alloc_reserved_mem_array(void)
 {
 	struct reserved_mem *new_array;
 	size_t alloc_size, copy_size, memset_size;
+	int ret;
+
+	if (!total_reserved_mem_cnt)
+		return 0;
 
 	alloc_size = array_size(total_reserved_mem_cnt, sizeof(*new_array));
 	if (alloc_size == SIZE_MAX) {
-		pr_err("Failed to allocate memory for reserved_mem array with err: %d", -EOVERFLOW);
-		return;
+		ret = -EOVERFLOW;
+		goto fail;
 	}
 
 	new_array = memblock_alloc(alloc_size, SMP_CACHE_BYTES);
 	if (!new_array) {
-		pr_err("Failed to allocate memory for reserved_mem array with err: %d", -ENOMEM);
-		return;
+		ret = -ENOMEM;
+		goto fail;
 	}
 
 	copy_size = array_size(reserved_mem_count, sizeof(*new_array));
 	if (copy_size == SIZE_MAX) {
 		memblock_free(new_array, alloc_size);
-		total_reserved_mem_cnt = MAX_RESERVED_REGIONS;
-		pr_err("Failed to allocate memory for reserved_mem array with err: %d", -EOVERFLOW);
-		return;
+		ret = -EOVERFLOW;
+		goto fail;
 	}
 
 	memset_size = alloc_size - copy_size;
@@ -102,6 +105,12 @@ static void __init alloc_reserved_mem_array(void)
 	memset(new_array + reserved_mem_count, 0, memset_size);
 
 	reserved_mem = new_array;
+	return 0;
+
+fail:
+	pr_err("Failed to allocate memory for reserved_mem array with err: %d", ret);
+	reserved_mem_count = 0;
+	return ret;
 }
 
 static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem);
@@ -250,7 +259,8 @@ void __init fdt_scan_reserved_mem_reg_nodes(void)
 	}
 
 	/* Attempt dynamic allocation of a new reserved_mem array */
-	alloc_reserved_mem_array();
+	if (alloc_reserved_mem_array())
+		return;
 
 	if (__reserved_mem_check_root(node)) {
 		pr_err("Reserved memory: unsupported node format, ignoring\n");
-- 
2.53.0



