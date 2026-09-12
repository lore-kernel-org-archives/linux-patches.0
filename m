Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4232A36921B;
	Sat, 12 Sep 2026 08:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201384; cv=none; b=XjGLHMkfgj5P8zY8pmw7fRGTgPngUvBrbPBLJnJPEWVp9+IYVqpo7BaFt6+luX0QEDYwjV0GGjppS9ortK/WcWDyONT+sfnlu/4nWk6jUjlSfxd3ZV1sQZnb01gRVn7Gob8+oJU7Ah/+O05xN0ymsN9OXo7KtR0TBnrjkVdV57s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201384; c=relaxed/simple;
	bh=K8n03uwyjqHi+/e1GQ8d7ni5oo7nR6KLbCxonLnqAWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4QIM+tw8zofAO0MN2vjjs7uV5mEzFkx1CZzHTcoWpxJVrKaJJNmWrWzzch4mqzywkY/lwZ3i7NzcLwjsi7cRQ9eUEC5KhvlcgHFut/Zx2EqrO4nXZznJG5kn0wbkQTHzTDicEq+fJbF/oI8UzOPzbBUwe988M+frSAcgG/c8vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNv0Y4MK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNv0Y4MK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49081F000FF;
	Sat, 12 Sep 2026 08:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201383;
	bh=7MLwPDE2hWzearVSYZ5tt8Ytit/2p6pYfr3WRh0QDr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNv0Y4MKRoUysgMupAT31IsPdy/2nnBS/fNIQvVKcPwfWq/ADpIug83ewFYXWw6V1
	 gcGtbq1kvndlvXNC8dpcXJBQElVSTjFk62T8MZ+xdcZLQkSN4v963awXHbzQX+U9Is
	 myjq+U3jLWsHprVMnaheX/6A10dpYCn709MT4o+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	jiazhenyuan <jiazhenyuan@uniontech.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0985/1815] powerpc/smp: add NULL guard for cause_ipi in smp_muxed_ipi_message_pass
Date: Sat, 12 Sep 2026 08:45:35 +0200
Message-ID: <20260912065712.118149013@linuxfoundation.org>
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
index 3467f86fd78f2..6a5a5469aaae5 100644
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



