Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15D52DC792;
	Sat, 12 Sep 2026 11:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211851; cv=none; b=G3/yAcYOcKlheagbxGKu0h4UOn4JvpE2B8M7t0yygl0La9XhV/3rMO6uzZ+lkQ9bYMJdIW5nFikXPt4YFoB/20vEQ/VYx3J0rt1sdxOjomPhlXabWyJxV/JMc8hKlshSEM14KeFeba1910GpKrRYeyRRA7LlQLZo2ESfTFTsWY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211851; c=relaxed/simple;
	bh=nRl5y85QssJrypJF8Nh+BSTMSpaOBjcCoj8eOMC4Gx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENJjewDW09qBlttR/HImr9Nf7YsaQLHnucQNdOpj3f3q1HDz1nTpWLamMTjUK/acSjGoKDuSxDZIOseXd2XEHYw7fpMhOvCpm+SrdE3lqZliQIWk4r53CqJOUT2IJA/uFCpdYBhpr/GlABSoPMZCAXKxD3rDgQvdZ52cRvtyWL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8d/gpSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8d/gpSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB591F000FF;
	Sat, 12 Sep 2026 11:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211850;
	bh=00KSd9xPEFg3Y2q7UvAVCLKs586r9Bc8ol6v35BtL10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8d/gpSjkRAJuFYl8LPl0pEbk/Q2Fkg3bO7GA+EaR7leYoc6kQcY45l9I5mgraCuz
	 sYLRL6ApmsNKE4CbPyKB18pYibKYe3ePlzGSpKQvuPlxc7kz3piVPQBUEae4lI7LVz
	 20aFvgG1JH/m8+Hu51l+ROqOtaLIBad/3Zq1z/i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1315/1518] irqchip/gic-v5: Use logical cpu 0 irs_data for dynamic IST allocation
Date: Sat, 12 Sep 2026 08:58:04 +0200
Message-ID: <20260912065653.274072309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 9dfcc2187282816d42b9f8aa2b689c732ebbcc01 ]

In set-ups with a 2-level IST, L1 table entries are created dynamically
when LPIs are allocated.

The L1 allocation and mapping, implemented in gicv5_irs_iste_alloc() is
carried out in preemtible context and can be carried out on any IRS in
the system.

Current code indexes the per_cpu_irs_data per cpu array using
smp_processor_id() to retrieve the IRS that is local to the core
executing gicv5_irs_iste_alloc().

Since that's preemptible context, the core executing that function can
change on preemption. Given that every IRS in the system is equivalent
to each core, this is not really an issue in that even if the thread
is preempted and resumed on a different cpu, the table allocation and
mapping to an IRS would work seamlessly regardless.

On the other hand, smp_processor_id() spits a legitimate splat on
DEBUG_PREEMPT kernels when used in preemtible context and this should
be fixed.

Given that all IRSes are equivalent from a core perspective in terms of
IST initialization, always choose as a policy the IRS local to logical
cpu 0, preventing the smp_processor_id() splat.

Fixes: 0f0101325876 ("irqchip/gic-v5: Add GICv5 LPI/IPI support")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://sashiko.dev/#/message/20260810104747.E5CE71F000E9%40smtp.kernel.org
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-6-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-irs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
index ce2732d649a3e..a650eccdb37a8 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -198,7 +198,7 @@ int gicv5_irs_iste_alloc(const u32 lpi)
 	if (!gicv5_global_data.ist.l2)
 		return 0;
 
-	irs_data = per_cpu(per_cpu_irs_data, smp_processor_id());
+	irs_data = per_cpu(per_cpu_irs_data, 0);
 	if (!irs_data)
 		return -ENOENT;
 
-- 
2.53.0



