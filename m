Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A66E374169;
	Sat, 12 Sep 2026 08:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201265; cv=none; b=rRW5Gzq0EemQuCYBoG48HDnkOXi67nNRzsa63dphwoTQQ0coWUqU5aATYPJgkRfJRyebepgvdG3RfTFIzaw4bxAYIHLWwxYuYfwZiZpGsOTgHi8RPG2KQD7FYh8PDJ7UEUpnszTV2fUUV0ouQwCwJo8td9tLqwAF8kgoi88P/pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201265; c=relaxed/simple;
	bh=4XMvE9X1xxh0RDm8WtKLh9N0pz/cAO9e8vFT5SHKBQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ymb9hy1l/wfrVlbCfAxqRPUx7ijwPKMftR9J1ReWaiNaTn72JIrnKvqkphY9WIU22XmSVa3FDUNHM2v0/UA3giWIMnRgfOXaI0oLZsxTLVw39jJJ5DjTLIDlcXUIETLE98tN2M2o20dJOXNNQp3o5Om0QJCUkw+pw6yCI0wjq6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqVUtB8M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqVUtB8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BF31F000FF;
	Sat, 12 Sep 2026 08:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201264;
	bh=buRhzqrw40+xOl4JNxMQTQW3JwVvIkxlYtYg573q234=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqVUtB8MnD4z6X+gzrf8mEY0k/cNBHadr8rnCGTJoN2V/7BO98CIcvRp/4tsAl7r6
	 LwRvYgFdKBTfpe/rXj/Hp7O5eqtSrYo+FMT4ktm8eXqLfnvRiKDFiP9HxS7Yr6kAGr
	 9kUsAcXzAqeILTi14GP494TVLRlxaFqCTtm2j65o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0918/1815] ARM: tegra: Fix OF node reference leaks in IRQ init
Date: Sat, 12 Sep 2026 08:44:28 +0200
Message-ID: <20260912065710.478476150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 7acac0cabaac6967e1f987bfedd4418204c813a7 ]

tegra114_gic_cpu_pm_registration() and tegra_init_irq() use
of_find_matching_node() for temporary IRQ init lookups, but the helper
returns a referenced node even when the result is used only as a boolean
or as an of_iomap() input.

Use scoped device_node cleanup for both lookups so the references are
dropped when the functions return.

Fixes: 7e8b15dbc392 ("ARM: tegra114: Reprogram GIC CPU interface to bypass IRQ on CPU PM entry")
Fixes: e9479e0e832b ("ARM: tegra: skip gic_arch_extn setup if DT has a LIC node")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-tegra/irq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 4e1ee70b2a3f1..e5a611dce7e74 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -66,9 +66,9 @@ static const struct of_device_id tegra114_dt_gic_match[] __initconst = {
 
 static void __init tegra114_gic_cpu_pm_registration(void)
 {
-	struct device_node *dn;
+	struct device_node *dn __free(device_node) =
+		of_find_matching_node(NULL, tegra114_dt_gic_match);
 
-	dn = of_find_matching_node(NULL, tegra114_dt_gic_match);
 	if (!dn)
 		return;
 
@@ -88,7 +88,10 @@ static const struct of_device_id tegra_ictlr_match[] __initconst = {
 
 void __init tegra_init_irq(void)
 {
-	if (WARN_ON(!of_find_matching_node(NULL, tegra_ictlr_match)))
+	struct device_node *dn __free(device_node) =
+		of_find_matching_node(NULL, tegra_ictlr_match);
+
+	if (WARN_ON(!dn))
 		pr_warn("Outdated DT detected, suspend/resume will NOT work\n");
 
 	tegra114_gic_cpu_pm_registration();
-- 
2.53.0



