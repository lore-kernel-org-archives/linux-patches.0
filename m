Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F2E231A2A;
	Mon, 10 Mar 2025 17:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627896; cv=none; b=MGsCa+LrU+tViVzea/kLEpQDUBfqHI3jE9p4Oag4jq6/2lu1MaI0I4EWg3oq8JAfvy3hmSyCbCdPTtNJ3H/hxEshIyaUS8zoOT7cbrfGfALSujskdxz8/FyV8nRMCuV+FDnwLw7UbTZ46AVqU75pxdbda8DpYsth3jMGNrSGdnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627896; c=relaxed/simple;
	bh=IKob7Pqk5Fll0q5xB5uMXU1S2M6+0et7Qj7eRXA/3Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NHPf03DS1aGxYvMIZ/k/tnp8nQqUJOZn0VZRO4kIzju/Ya0cW8qmrRHQ8dK8aEbRmM84RJRWr+HbyVIiPcSQyTTUNHYwc8hv0ZVqwCrRLa2u3+UOkQPGtz88yujE9oaFkrfMRrwo1FfCbEfROXBU5u+aTSAStrBbmokKNYwUeys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkdgg2KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkdgg2KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6AFC4CEE5;
	Mon, 10 Mar 2025 17:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627896;
	bh=IKob7Pqk5Fll0q5xB5uMXU1S2M6+0et7Qj7eRXA/3Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkdgg2KQWtT2E2Ylt8Nnb7NOzkHsgKeS+v8FTUWoXHX2jhpfau/FBA3aIMvceCpWX
	 m6wMeOh/wuHnswDsTcB7XZ+uaFZ3lOWveXmU+ZQ1wgVZxAaBfFYFAgKMTXyX7rf0CI
	 WFOyD+KgtAgHVJ1ZbAJcYcKZW2gI87HtyF8gu3MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mikisabate@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sunil V L <sunilvl@ventanamicro.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/145] riscv: Prevent a bad reference count on CPU nodes
Date: Mon, 10 Mar 2025 18:05:12 +0100
Message-ID: <20250310170435.478136380@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Sabaté Solà <mikisabate@gmail.com>

[ Upstream commit 37233169a6ea912020c572f870075a63293b786a ]

When populating cache leaves we previously fetched the CPU device node
at the very beginning. But when ACPI is enabled we go through a
specific branch which returns early and does not call 'of_node_put' for
the node that was acquired.

Since we are not using a CPU device node for the ACPI code anyways, we
can simply move the initialization of it just passed the ACPI block, and
we are guaranteed to have an 'of_node_put' call for the acquired node.
This prevents a bad reference count of the CPU device node.

Moreover, the previous function did not check for errors when acquiring
the device node, so a return -ENOENT has been added for that case.

Signed-off-by: Miquel Sabaté Solà <mikisabate@gmail.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Sunil V L <sunilvl@ventanamicro.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Fixes: 604f32ea6909 ("riscv: cacheinfo: initialize cacheinfo's level and  type from ACPI PPTT")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240913080053.36636-1-mikisabate@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: fb8179ce2996 ("riscv: cacheinfo: Use of_property_present() for non-boolean properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cacheinfo.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/cacheinfo.c b/arch/riscv/kernel/cacheinfo.c
index d6c108c50cba9..d32dfdba083e1 100644
--- a/arch/riscv/kernel/cacheinfo.c
+++ b/arch/riscv/kernel/cacheinfo.c
@@ -75,8 +75,7 @@ int populate_cache_leaves(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
-	struct device_node *np = of_cpu_device_node_get(cpu);
-	struct device_node *prev = NULL;
+	struct device_node *np, *prev;
 	int levels = 1, level = 1;
 
 	if (!acpi_disabled) {
@@ -100,6 +99,10 @@ int populate_cache_leaves(unsigned int cpu)
 		return 0;
 	}
 
+	np = of_cpu_device_node_get(cpu);
+	if (!np)
+		return -ENOENT;
+
 	if (of_property_read_bool(np, "cache-size"))
 		ci_leaf_init(this_leaf++, CACHE_TYPE_UNIFIED, level);
 	if (of_property_read_bool(np, "i-cache-size"))
-- 
2.39.5



