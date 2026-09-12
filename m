Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9F019E7F7;
	Sat, 12 Sep 2026 08:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201370; cv=none; b=ozsRXqrHTbuOFCz5Uug1yGkeHPAcFtj/tpxSAt53YFGlzwBVTrcKeo28Chin7KaZM8BIy88oV7r0YdLdUGNSMFyvNcDkyBCIEe1BJ7JPJLiMGUA2oPNLdUEr9HlNiy4kvbUN2beFogFp2mSA8+8yQW4VQY6cYL9kDadrMPdjOMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201370; c=relaxed/simple;
	bh=7yOkGDFktQYKCKmqfN2aCFqqxKtrclQZa/h1WmIzwnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iI16i7I2HgO9TVbrqLp93VEWt0NCAm7X1xfiaXkP+FOYCf5KaHmjH2d/eXLc6fsBTajFzA0VFNlg3CdV/1cVz+GYMhkq1bqD+ZOHKNjU/vNTXWRkrI0/3kHj5/ja//1ONGDYzC3z/zkDANmnvn4IhZvEO+0g7UnaM+nxPTBfM/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEcX2wK8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEcX2wK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F7B1F000FF;
	Sat, 12 Sep 2026 08:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201368;
	bh=p20Tc/zXxbdsGE3V82H167QTQpUofX4bvF5Q0kH7+kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEcX2wK8vgOwtyBeMCnjs2oERYgLW6d24bTJYcZ8X9a93Vhnc0oSK424mDJTNzpZW
	 yaB/Q4ns8qIIsqUdKTO69l/jv916S/ISnsPR9dYkLCaDhrzkjVp+WV2YiywQ6nJ7FV
	 L/RFSqM5zKtq1E4DdJF5h9w48XCzo5h+a2ILtVJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	jiazhenyuan <jiazhenyuan@uniontech.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0982/1815] powerpc/xive: make xive IPI allocation NULL-safe
Date: Sat, 12 Sep 2026 08:45:32 +0200
Message-ID: <20260912065712.047151538@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit f068fca7e8b7014014296b0e458ba9c5aa77f954 ]

__GFP_NOFAIL should not be used in new code [1].  xive_init_ipis()
allocates the xive_ipis array with __GFP_NOFAIL, which makes the
subsequent NULL check unreachable dead code.

Remove __GFP_NOFAIL so the allocation can fail, and make all xive_ipis
access paths NULL-safe:

- Return XIVE_BAD_IRQ from xive_ipi_cpu_to_irq() when xive_ipis is NULL.
- Set xive_ipis to NULL after kfree() in the error path to prevent
  use-after-free.
- Guard xive_setup_cpu_ipi() and xive_cleanup_cpu_ipi() against
  xive_ipi_irq == XIVE_BAD_IRQ to avoid dereferencing an uninitialized
  or already-freed xive_ipis array.

No functional change when allocation succeeds.

Link: https://lore.kernel.org/all/20260725202632.dcb325658896a470df91cf57@linux-foundation.org/ [1]
Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Cédric Le Goater <clg@kaod.org>
Suggested-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260727104215.184786-2-gouhao@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/common.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index dadd1f46ec939..86c78af1f68ea 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -74,6 +74,8 @@ static struct xive_ipi_desc {
  */
 static unsigned int xive_ipi_cpu_to_irq(unsigned int cpu)
 {
+	if (!xive_ipis)
+		return XIVE_BAD_IRQ;
 	return xive_ipis[early_cpu_to_node(cpu)].irq;
 }
 #endif
@@ -1132,8 +1134,7 @@ static int __init xive_init_ipis(void)
 	if (!ipi_domain)
 		goto out_free_fwnode;
 
-	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
-				 GFP_KERNEL | __GFP_NOFAIL);
+	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids, GFP_KERNEL);
 	if (!xive_ipis)
 		goto out_free_domain;
 
@@ -1158,6 +1159,7 @@ static int __init xive_init_ipis(void)
 
 out_free_xive_ipis:
 	kfree(xive_ipis);
+	xive_ipis = NULL;
 out_free_domain:
 	irq_domain_remove(ipi_domain);
 out_free_fwnode:
@@ -1190,6 +1192,9 @@ static int xive_setup_cpu_ipi(unsigned int cpu)
 
 	pr_debug("Setting up IPI for CPU %d\n", cpu);
 
+	if (xive_ipi_irq == XIVE_BAD_IRQ)
+		return -EIO;
+
 	xc = per_cpu(xive_cpu, cpu);
 
 	/* Check if we are already setup */
@@ -1234,6 +1239,9 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
 
 	/* Disable the IPI and free the IRQ data */
 
+	if (xive_ipi_irq == XIVE_BAD_IRQ)
+		return;
+
 	/* Already cleaned up ? */
 	if (xc->hw_ipi == XIVE_BAD_IRQ)
 		return;
-- 
2.53.0



