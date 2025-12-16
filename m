Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D090F224AEF;
	Tue, 16 Dec 2025 12:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887805; cv=none; b=SO8g5fYc7ILB/+XhuAPMik8riPoS3866XH9Rfdn9ymKwRRyw5xkUKqBmM1m3XfPaKdDm83yolc43R6iv3y2aRlLDb0JQrKRCwKXkNf03S6Lk2oF5zSb2myu4+w6Y3N/JNDTHGTh7ZZD4HjvJfkC03W9DPnacMsnsPP80pmc/Hb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887805; c=relaxed/simple;
	bh=dTtPQOVLEsFoAxatqH5XEbL1tat3gLcNQFiIGjn32Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouVq+05BQ5WlsdCPSkRVUBBGSN2mkicEiidz9+EmBOFIbEffMCgdGhHcv6zRJsMWqNJZE6bLSVXjkUG4C32AQs7EdBH8oIRlO+Zl1bo/kinT2EM9VGqbBmOiKjopXUeXFcuB7cXeBVxKHGfHbbU9ouonJd7FNkEJxwl/sz/axQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lQ1vH2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lQ1vH2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371EAC4CEF1;
	Tue, 16 Dec 2025 12:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887805;
	bh=dTtPQOVLEsFoAxatqH5XEbL1tat3gLcNQFiIGjn32Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lQ1vH2s5JP/Fak6CQhdyNjDiaVg3PNtqzRKrmHJKzGBxZe9KVDmg16ZHOWHXhY6Y
	 +NnN7JIYNvH5g3oszggrFuq5EP1SmNQJ97KmXGgFcZq1WAZP/M4XG4yyE6eSPNPQkk
	 O3KcYEB9DI6JgZYvHTiaWSjsoJeYSS/LONTHTfxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 342/614] of/fdt: Fix incorrect use of dt_root_addr_cells in early_init_dt_check_kho()
Date: Tue, 16 Dec 2025 12:11:49 +0100
Message-ID: <20251216111413.755266987@linuxfoundation.org>
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

[ Upstream commit c85da64ce2c36bba469f6feede9ca768f0361741 ]

When reading the fdt_size value, the argument passed to dt_mem_next_cell()
is dt_root_addr_cells, but it should be dt_root_size_cells.

The same issue occurs when reading the scratch_size value.

Use a helper function to simplify the code and fix these issues.

Fixes: 274cdcb1c004 ("arm64: add KHO support")
Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Link: https://patch.msgid.link/20251115134753.179931-5-yuntao.wang@linux.dev
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ea37ba694bcd7..fdaee4906836f 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -922,26 +922,18 @@ static void __init early_init_dt_check_kho(void)
 {
 	unsigned long node = chosen_node_offset;
 	u64 fdt_start, fdt_size, scratch_start, scratch_size;
-	const __be32 *p;
-	int l;
 
 	if (!IS_ENABLED(CONFIG_KEXEC_HANDOVER) || (long)node < 0)
 		return;
 
-	p = of_get_flat_dt_prop(node, "linux,kho-fdt", &l);
-	if (l != (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32))
+	if (!of_flat_dt_get_addr_size(node, "linux,kho-fdt",
+				      &fdt_start, &fdt_size))
 		return;
 
-	fdt_start = dt_mem_next_cell(dt_root_addr_cells, &p);
-	fdt_size = dt_mem_next_cell(dt_root_addr_cells, &p);
-
-	p = of_get_flat_dt_prop(node, "linux,kho-scratch", &l);
-	if (l != (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32))
+	if (!of_flat_dt_get_addr_size(node, "linux,kho-scratch",
+				      &scratch_start, &scratch_size))
 		return;
 
-	scratch_start = dt_mem_next_cell(dt_root_addr_cells, &p);
-	scratch_size = dt_mem_next_cell(dt_root_addr_cells, &p);
-
 	kho_populate(fdt_start, fdt_size, scratch_start, scratch_size);
 }
 
-- 
2.51.0



