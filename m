Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF6A302748;
	Mon, 27 Oct 2025 19:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592052; cv=none; b=cN7G8qEMIvQxXrjkSCTe1MZJWb6eo2qLeKX61vVays6Rdck2I82j9jSmO3rxJ0q2NpHd0taxNl3ctlZE1kxiI1lGWWcUamNmdeirUSvmGrFGpknwWAqXc38zqt8rYHrZCLEoIxbJwe/tPdqZbH/qEKi9nbdMfUudWkXTyZbZI1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592052; c=relaxed/simple;
	bh=PbSM5Goroah3kg+eVMNFshrN2EhgSvGlXNZQZDE60SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASlDl9p7Yw1zLdTX+TKa9l3Rtj14Z/Pfa0kRkQBPM0/Za8d0M3ePYBfMOR1lyh+n+uLAhb3bUAAaGdvzc5PjrhFNsfsvJ1knPEnr+wbtXZmN1FWtb25AfZ80/m0kZS+/S/P3NIRvij5FwyeVGkb6LRCpxqmMaEDDSb6JbofzrJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7QZ96Mn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7QZ96Mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CA1C4CEF1;
	Mon, 27 Oct 2025 19:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592052;
	bh=PbSM5Goroah3kg+eVMNFshrN2EhgSvGlXNZQZDE60SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7QZ96Mnxzfza4/gc8yBSPC76BDRgHUbR72Nedm9ak0i72qa8bClcGtm1hcwSaQ8d
	 k8vV+8QQg9QhopOYHdvn1WWh4qa+3jGieS9ztKnicjwJYcmjjZlWWwyFoj7m4bNXgI
	 UNGXh6wPsuRIlwYLueTnAVil2TiCz0zuDky+yuvI=
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
Subject: [PATCH 5.15 070/123] riscv: Use of_get_cpu_hwid()
Date: Mon, 27 Oct 2025 19:35:50 +0100
Message-ID: <20251027183448.271242205@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



