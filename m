Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E3D224AEF;
	Tue, 16 Dec 2025 12:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887802; cv=none; b=W5bqKlKPdPdfQAHjc6ROQHNHk3qSJYpMtbwQ0E5Qmx+4wWK5Av/ahEV7XGDtpddl6NJIv5z/vNDh3iNw7dGrm9L3lJvlU+yEjtuZvM8ZA7auqwO95AQSZ0ErreNXQp6a8Eb3ShnEZ8yfp6+FWZm2zpRsG1SKf7KuT1Hi8rLcE/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887802; c=relaxed/simple;
	bh=LYFFM1VL+N10i0AJZ+q3fEtyZbduspwCxxpbKJXs1U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D50y3JpLjwRw6coSE0u3zhWTkJheW4XmGNszvlemcCEkwIJD0+JG9Gf50vh5HuryyHIo3Dqyj+ikTgYQGtOBnmakGhnFWp5jkXWgd+yTQV3Xwu4Nd/pbzfEjMT+/8nsI/IqmK3qdCo9OJ7F5XOIoDRQE6YRVQEfQ9AIziTkp+TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Vq3NKyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Vq3NKyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792B9C16AAE;
	Tue, 16 Dec 2025 12:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887802;
	bh=LYFFM1VL+N10i0AJZ+q3fEtyZbduspwCxxpbKJXs1U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Vq3NKynQBiqjQJ5fepWlwwJRJkQpi8GbDxcjMFtSW5g8IU7Lr9uq9j1h6GzxBcnT
	 rHtW+so+F7lyx7q7QofwAf6L5ve0C/v71cNrjtX+iIhFlZUNv7S754VifoUA408WYX
	 e7CFKi3UUEfBJaJgFArhsshHHLBu3Zh1PMQRrV6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 341/614] of/fdt: Fix the len check in early_init_dt_check_for_usable_mem_range()
Date: Tue, 16 Dec 2025 12:11:48 +0100
Message-ID: <20251216111413.719343251@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Yuntao Wang <yuntao.wang@linux.dev>

[ Upstream commit 463942de13cd30fad5dba709f708483eab7efc2c ]

The len value is in bytes, while `dt_root_addr_cells + dt_root_size_cells`
is in cells (4 bytes per cell). Modulo calculation between them is
incorrect, the units must be converted first.

Use helper functions to simplify the code and fix this issue.

Fixes: fb319e77a0e7 ("of: fdt: Add memory for devices by DT property "linux,usable-memory-range"")
Fixes: 2af2b50acf9b9c38 ("of: fdt: Add generic support for handling usable memory range property")
Fixes: 8f579b1c4e347b23 ("arm64: limit memory regions based on DT property, usable-memory-range")
Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Link: https://patch.msgid.link/20251115134753.179931-4-yuntao.wang@linux.dev
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index b45f60dccd7cf..ea37ba694bcd7 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -884,8 +884,9 @@ static unsigned long chosen_node_offset = -FDT_ERR_NOTFOUND;
 void __init early_init_dt_check_for_usable_mem_range(void)
 {
 	struct memblock_region rgn[MAX_USABLE_RANGES] = {0};
-	const __be32 *prop, *endp;
+	const __be32 *prop;
 	int len, i;
+	u64 base, size;
 	unsigned long node = chosen_node_offset;
 
 	if ((long)node < 0)
@@ -893,14 +894,17 @@ void __init early_init_dt_check_for_usable_mem_range(void)
 
 	pr_debug("Looking for usable-memory-range property... ");
 
-	prop = of_get_flat_dt_prop(node, "linux,usable-memory-range", &len);
-	if (!prop || (len % (dt_root_addr_cells + dt_root_size_cells)))
+	prop = of_flat_dt_get_addr_size_prop(node, "linux,usable-memory-range",
+					     &len);
+	if (!prop)
 		return;
 
-	endp = prop + (len / sizeof(__be32));
-	for (i = 0; i < MAX_USABLE_RANGES && prop < endp; i++) {
-		rgn[i].base = dt_mem_next_cell(dt_root_addr_cells, &prop);
-		rgn[i].size = dt_mem_next_cell(dt_root_size_cells, &prop);
+	len = min(len, MAX_USABLE_RANGES);
+
+	for (i = 0; i < len; i++) {
+		of_flat_dt_read_addr_size(prop, i, &base, &size);
+		rgn[i].base = base;
+		rgn[i].size = size;
 
 		pr_debug("cap_mem_regions[%d]: base=%pa, size=%pa\n",
 			 i, &rgn[i].base, &rgn[i].size);
-- 
2.51.0



