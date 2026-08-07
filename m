Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1676F37BE84;
	Fri,  7 Aug 2026 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114588; cv=none; b=rnMl0setN5BjO7aj3X2UDTUWH8Hl09XE+Y5MUQs4pHeN+PZYWwZvE0yYVg2AtVKKXjXo8Krpxqpx8uLXw2kKI9xMdEPlzns/5y+xp81K48d0pijIf0+tM8xetx+ESDFSa1IzL31FQdWOOTm9MYT8uF7AFH3fSvY6gE4ssdv5EAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114588; c=relaxed/simple;
	bh=QBbWJwr2uSt+zBl9LORaiANYsz0LNMzljf8Hu2DrDoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQHSS8CEeCOQ1+nf1blH/ZP8H2BgkYD/nBLWX9eSieUiqg7/EPm1odJgZ4gGHzQnDGVuyV3X2IsJFUm1XZ5rrCfDloZuA5/piTz477QIIRCsB4LiZ9q0r92Qrdhv1zQlc0jbj49yF8Bim2OR5pg2zGm3X6553dC3RwJIinLr1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkfvN0R+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkfvN0R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105001F000E9;
	Fri,  7 Aug 2026 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114584;
	bh=weo2LQmtcxMNVaqQ0+ckN5+UCD2Rt7D6iKee+bYbXtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkfvN0R+0HbZgPMFG/t6GyIjNwdefPI1Y11j2vLJZiTsp4/rcLvrkAagsQ5U50erC
	 8yBSeWkT3Jq/4efqm/jJdYUb4gsnjsncmPhPlW5Bpy3JLcgCGvoro30cVeIvVzxIYN
	 06qwObiweIURgAeA57IflG9ZgXxz8mEocJOlhjAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wandun Chen <chenwandun@lixiang.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 271/337] of: reserved_mem: avoid post-init UAF when alloc_reserved_mem_array() fails
Date: Fri,  7 Aug 2026 16:37:54 +0200
Message-ID: <20260807143424.414888056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Wandun Chen <chenwandun@lixiang.com>

commit e1686ca81dbf3edbde589b7daf312b45cbf76e03 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/of_reserved_mem.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -70,29 +70,32 @@ static int __init early_init_dt_alloc_re
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
@@ -101,6 +104,12 @@ static void __init alloc_reserved_mem_ar
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
@@ -246,7 +255,8 @@ void __init fdt_scan_reserved_mem_reg_no
 	}
 
 	/* Attempt dynamic allocation of a new reserved_mem array */
-	alloc_reserved_mem_array();
+	if (alloc_reserved_mem_array())
+		return;
 
 	if (__reserved_mem_check_root(node)) {
 		pr_err("Reserved memory: unsupported node format, ignoring\n");


