Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2E5355028;
	Tue, 16 Dec 2025 11:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885929; cv=none; b=aJAcYUTnHx53clvYd6kZiqSt3EjNLqRjuz8u1OJdRJyCY5sXOTRPkaNLcJmpsis1BJ4bJfiogbM+jnF6bVvAiJ25H8032nnW7/bAo7eceZvNOKHWJCDZ9/HbHVQiIB9J0P2ftqiMi/MUiT3s3RDOQ0pj/is7nFGCbz9iFF2QyDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885929; c=relaxed/simple;
	bh=o3NAQwnDYzc4Z64kZS3CjdCU0j47iAW6ekWuqcOX69E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikaPWkjhvUnLSHy+8bbLOjaErqk05GYYEQSt3IBoArj+6G+q/UbD3+8ANHf2LqF3US6CMAxwZHR05MeM4qHNDyKzQUCA/gp6XxgddXJr/ZcBi/YmO7AAw1NSg0UEWvi2vJ2yhqKZt3Bj2L0vVVaePgoOzn4FI9m/iJFUiWpUG68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/t9rxOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/t9rxOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCA3C4CEF1;
	Tue, 16 Dec 2025 11:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885929;
	bh=o3NAQwnDYzc4Z64kZS3CjdCU0j47iAW6ekWuqcOX69E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/t9rxOIopgw824+sqjirIRRHfj74Et8ysDCnDTp2O9R7KSj7zNIsY/cFbmPbTpAw
	 YFQ4a0m9Gp7bBK8z+8e5MpiH6cEY4tiYo1TWeImJuQhHwu2LBO5vi6dO75CuHjFPqY
	 WUYPMTispvj8TDwdfJmV9UR7ObmPcUGLUlm+UM4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 287/507] of/fdt: Fix incorrect use of dt_root_addr_cells in early_init_dt_check_kho()
Date: Tue, 16 Dec 2025 12:12:08 +0100
Message-ID: <20251216111355.875120581@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index 0c18bdefbbeea..de16785a48695 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -924,26 +924,18 @@ static void __init early_init_dt_check_kho(void)
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



