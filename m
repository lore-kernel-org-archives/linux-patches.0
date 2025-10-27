Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38C1332900;
	Mon, 27 Oct 2025 19:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591671; cv=none; b=khAA+yKc3LcX1Fzj95bZeM8zfC+MbmTKqdfe+OPTwKVLq1LiLnyRAs2JbY0+WE7jXF16krIzR2MviuNEPEPnQfyocD9ZBWrZEhxXbDQt5oN22sVu/geX5ZyXilU9QfBwOkVy0y2BuRZUC0yJpLv31SgFdiWS5T6m1p8GbABnbtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591671; c=relaxed/simple;
	bh=icM7Q1j8GLqLmcpszjolm1Y/md1kJGQpU7Zw15cxzdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTyNjOirbejE5iR3p11+Viqht/plqMF8aDxAmjUA1gQIgWwdSxe4rC8qXucIx2MyY3sGz/mRNLSPl5BgM40xgkw+WAYoaUVIAw/crzdN/QZKJd3WH4D7ExBfS369sgJ5v2TxsCsIgxQLLeK2psrCUj9fegxyJzKboivaAoKEFiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5GzwWb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5GzwWb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FB5C19422;
	Mon, 27 Oct 2025 19:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591671;
	bh=icM7Q1j8GLqLmcpszjolm1Y/md1kJGQpU7Zw15cxzdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5GzwWb/YZxefV4KerrrNK8KPOnz9S2bv8RwDVDc69CT4CyycfclAzUFjZf052keC
	 2/2x7ygF1BLVMgovjFOUgjSsDe+TcVvQDFR6pDsTCudOupdHX14QZDmLqG034KIkGN
	 uvT7ATvvhSglnDMEf1biDBlhFcT84DIrOVPCeKQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-riscv@lists.infradead.org,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/332] riscv: Use of_get_cpu_hwid()
Date: Mon, 27 Oct 2025 19:35:39 +0100
Message-ID: <20251027183532.408988014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit bd2259ee458e299ec14061da7faddcfb0d54d154 ]

Replace open coded parsing of CPU nodes' 'reg' property with
of_get_cpu_hwid().

Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-riscv@lists.infradead.org
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20211006164332.1981454-9-robh@kernel.org
Stable-dep-of: d2721bb165b3 ("RISC-V: Don't print details of CPUs disabled in DT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index 6d59e6906fddf..f13b2c9ea912d 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -22,7 +22,8 @@ int riscv_of_processor_hartid(struct device_node *node)
 		return -ENODEV;
 	}
 
-	if (of_property_read_u32(node, "reg", &hart)) {
+	hart = of_get_cpu_hwid(node, 0);
+	if (hart == ~0U) {
 		pr_warn("Found CPU without hart ID\n");
 		return -ENODEV;
 	}
-- 
2.51.0



