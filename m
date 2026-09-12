Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0B21C5799;
	Sat, 12 Sep 2026 18:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239467; cv=none; b=hpHDM1QFrN9b5wuDSzaMIy9iHLJf7nXcqHarl8buTI5h1as2AEtuGC17/9IdrgyTg8A30aJSxMeB2FBL/n5SoL74jYrAx7xGK8h0S86H1vaF9GuvhPwunK55ZrXBQgHzScuqJ1O2byewXRbCUiaotlcHbuo3QIjlKmMPFvikDww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239467; c=relaxed/simple;
	bh=Z5lqfnZQxE5384s/DD4i3LaKgv/tsYbLuBIRc01Kn2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cboNdMUtGT1Btlg9dPPyPEEfQfG3XCf/83WruPZumS0/6m2640JYd66YlLRQTej5MOHMDB8X0DbmsPrljqKdCYbsQdlntMinCURPOUwKrsZV35u6BOf5IGuyyBcd4nJGLD//QuH4mRuZxDYCVvYkd/mlv2K5kw7rPEGzgjwFDx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqH2lakK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqH2lakK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33BD1F000FF;
	Sat, 12 Sep 2026 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239465;
	bh=BjsIb++eRy0RblsldUSepf8zD8rLvvoGvUm6sq4wZgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqH2lakKLBp1H0Un1M1kOz5Y63InBCFHTOk8vAADYlcRD5YIExYd74LTl0aa5Hst1
	 5UfU7VpxnzIWiEM0gfL79KbRClYHLarC84B2CHPEKvgQ4amsbkkQjbdhGlr0DN4ued
	 FR29O5itO22vvC3OikYweT44oxoIgmNvH0NnGcss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	jiazhenyuan <jiazhenyuan@uniontech.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 668/935] powerpc/smp: add NULL guard for cause_ipi in smp_muxed_ipi_message_pass
Date: Sat, 12 Sep 2026 09:01:38 +0200
Message-ID: <20260912065542.162238484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit 5aabc192702defb8950e7c81b05c3f4ca8ee43ec ]

smp_muxed_ipi_message_pass() calls smp_ops->cause_ipi() without
checking whether it has been set.

On platforms using muxed IPI (e.g. powernv/pseries), smp_ops->cause_ipi
is initialized to NULL in the static smp_ops and only assigned during
the platform smp_probe() handler.  If the IPI subsystem fails to
initialize -- for example when xive_init_ipis() fails and
xive_smp_probe() returns an error -- the probe handler returns early
and cause_ipi is never set.  Any subsequent IPI send (e.g.
arch_smp_send_reschedule()) would dereference the NULL pointer.

Add a NULL check to avoid the crash in that situation.

Fixes: 23d72bfd8f9f ("powerpc: Consolidate ipi message mux and demux")
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260727104215.184786-6-gouhao@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 2b8a5309fb4a5..9e3d9a3c8db4f 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -296,6 +296,9 @@ void smp_muxed_ipi_set_message(int cpu, int msg)
 
 void smp_muxed_ipi_message_pass(int cpu, int msg)
 {
+	if (!smp_ops->cause_ipi)
+		return;
+
 	smp_muxed_ipi_set_message(cpu, msg);
 
 	/*
-- 
2.53.0



