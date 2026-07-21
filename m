Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE1E46C4C6;
	Tue, 21 Jul 2026 15:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649160; cv=none; b=TeIbNkqlIUODOjTZPPKuM8uHHR6RQw8oq4W6h15FFD4P4In6ZPeTYM+nVLZsaNLfQJzF/I1CuKt8raIvmI/ozsr4X8Hrb4RXEhRwWilLtZplC6FZeE1+OaDZ/VQmYnfehzAoky1+sx/giiQAxSc5rkij5apHqtiTzaY0YQPtmdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649160; c=relaxed/simple;
	bh=fiZ8ujDnwwqT75OI6kMRAFKzWVevP4HKY5cAYLa64bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzQQ+79bCuWKZgOUY9HAmYBMPeYwaYONQRraNKIoK60n9jz0p6AlayZEs/ZDU/DnNJdy2hXysi5F/8KCD6oIKq7TKZ/ii89+z/xQbc5LkSuVeFBC3KwHcDTvV2GmYx/gCMOKciklq9gvO6Mo8uX4L6+nVpenXO6nYgsSV1YU+70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDQInqAW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDQInqAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5201F00A3A;
	Tue, 21 Jul 2026 15:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649158;
	bh=inDWqIVxb8mR4Hxf5uwYRAcd0lk0GNGG8sSvL95cH8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDQInqAWLavIiKpxkoeabos8VfwHehXSP8DCfFKYwVQvTViVYgM3+qSFDnEA+UaPQ
	 fkFesnVX1sKG8p9gAI+GIiR43qfKoUfZhuvz3bC7DCY9rI8b6n2XfRdzmj5r1XZrE2
	 g9kGW1eq9/PTIH3VN6EQVVx9F+unK/2Ifsrf25Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wandun Chen <chenwandun@lixiang.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0473/2077] of: reserved_mem: avoid post-init UAF when alloc_reserved_mem_array() fails
Date: Tue, 21 Jul 2026 17:02:26 +0200
Message-ID: <20260721152603.955098846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8d5777cb5d1b3d..deaea58c74f2a5 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -69,29 +69,32 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
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
@@ -100,6 +103,12 @@ static void __init alloc_reserved_mem_array(void)
 	memset(new_array + reserved_mem_count, 0, memset_size);
 
 	reserved_mem = new_array;
+	return 0;
+
+fail:
+	pr_err("Failed to allocate memory for reserved_mem array with err: %d", ret);
+	reserved_mem_count = 0;
+	return ret;
 }
 
 static void fdt_init_reserved_mem_node(unsigned long node, const char *uname,
@@ -266,7 +275,8 @@ void __init fdt_scan_reserved_mem_late(void)
 	}
 
 	/* Attempt dynamic allocation of a new reserved_mem array */
-	alloc_reserved_mem_array();
+	if (alloc_reserved_mem_array())
+		return;
 
 	if (__reserved_mem_check_root(node)) {
 		pr_err("Reserved memory: unsupported node format, ignoring\n");
-- 
2.53.0



