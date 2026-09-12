Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17541FC110;
	Sat, 12 Sep 2026 10:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209664; cv=none; b=AG9y2VFvyCacIoRzacgerERjHTCymwRg8xaM7RbC+4aO7rnktOkpPEoFcNEwZE6gQ94oChQ5p7GL68RMLRpPMendUoz3fZLbO4o0nyttIFRJT1vbZfN+cuu/kXv15YH+ieDjbqKAXbmdcqb3cXv5436DgwJETCHiKoXLLt1ZAEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209664; c=relaxed/simple;
	bh=OOJ2VcrFivHie2ycSEqJ8tFMeMDPpyCgvBhAA8x1hME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckBBtT9FtelX6NFL08c1UpL8tb8xrSt8AKV+qeSa3mmS60IRU9HqH3DG9p9C2Gb93XaUeWJMorUM8z7yM9lt6QNHUelWUMx91zn4MFNpBZqStZxSGB2HLVaksQk85Mzu+dRw9WYFmREZD/JzGsk/17dBcY0qqlT8jsr8LrBAv64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXO11E3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXO11E3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A861F000FF;
	Sat, 12 Sep 2026 10:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209663;
	bh=P7NbRw5rObm+ZI6afXf5grvHogpRWhtI34CEX9Ik+r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXO11E3lexPfhlklJinZb6gMQZ8oysAHb35KHTqVT2KdRZs430RcNhK7/ZxU3qJzR
	 ZYFcwFn0WdLY0nMwPbsatJbd1hKisttgciaIB4ARKIYSaruwsfFseVqz5qHiPupGtK
	 aFkbPMIVw1ho8k3aWax4JIjUlw5wt1J8bxGD2scc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	jiazhenyuan <jiazhenyuan@uniontech.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0830/1518] powerpc/smp: add NULL guard for cause_ipi in smp_muxed_ipi_message_pass
Date: Sat, 12 Sep 2026 08:49:59 +0200
Message-ID: <20260912065642.215752393@linuxfoundation.org>
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
index 0cd9c0c21af3e..b5518fba3b92e 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -289,6 +289,9 @@ void smp_muxed_ipi_set_message(int cpu, int msg)
 
 void smp_muxed_ipi_message_pass(int cpu, int msg)
 {
+	if (!smp_ops->cause_ipi)
+		return;
+
 	smp_muxed_ipi_set_message(cpu, msg);
 
 	/*
-- 
2.53.0



