Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D8326AC5;
	Sat, 12 Sep 2026 16:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230834; cv=none; b=FlVEgjzBFTsGw2NpoGCgiUN/IIhSedkhRz5eFeu9bY96SaDqxAR1CQhVC2HhbnzhjMV1w2YVEvAoZwD3Tcf86/QPxXXlaHDj2jnuzy7Szmn2Zua9zC5t7OsHt6wOhkwhKd//TTfS5xYk7JVMqk7yTkIt0qTDzT/S0lqX9dVl4eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230834; c=relaxed/simple;
	bh=4N3L0ekzs03w/1/mlF3W6NnFgre/wJD40rhzFiRUl8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsjGj8F291OzhDxz1Em3Xk2O4ZdXSWElDNpPvk8rMTFw0A2JcCXTEMY3ej3ZYPOa/XA4HA0H7TbIJ+G+moHWQdyj0dvrLu5l3cmZF3VEvYx9GAsIACckJSmLMv/AEog3sk0Btwu0sqLvMaTgpfUYK2hCL7Ady+4Dx0INRQ86Hrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDKWBJD6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDKWBJD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785C61F000FF;
	Sat, 12 Sep 2026 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230833;
	bh=MJah2kE923KFfQzEtRLaxErvG8KrA5GG3OViVuXViNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDKWBJD6J6oQk+ZSnQ1rVQWj/kzMcKRNg/raH2NmBm7TKg9Cm2cHJlL2Qf8NPndFM
	 +QBoi+EIo1txjJSnFRsEWvyTYtTgFHEnCGkxncCEZ0/t/esEo5v60d35VMLenZWv+D
	 jEeAlmbvA/BFwssihU55uQ0UvOYcaAO5ku+ha40U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	jiazhenyuan <jiazhenyuan@uniontech.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0832/1191] powerpc/smp: add NULL guard for cause_ipi in smp_muxed_ipi_message_pass
Date: Sat, 12 Sep 2026 08:59:20 +0200
Message-ID: <20260912065606.949713435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 24c1950010812..980f2bc832d98 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -294,6 +294,9 @@ void smp_muxed_ipi_set_message(int cpu, int msg)
 
 void smp_muxed_ipi_message_pass(int cpu, int msg)
 {
+	if (!smp_ops->cause_ipi)
+		return;
+
 	smp_muxed_ipi_set_message(cpu, msg);
 
 	/*
-- 
2.53.0



