Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33EA142649;
	Wed,  3 Jul 2024 10:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004187; cv=none; b=PbnVCJIEqf+2ORRW0R544AS5f7m+704LCSo6regZXIeKiqr/QN+j34p8UTuv76fRapUvKbak5Xhl1nulXcEugt5lGb/Ypyp54ok0Iudx+GhI/B6nxt1hbp9iE+L/pJY6zw0Rk6QF7T8i3Hrw1hkppSYvUDTiPCsc7j3G5gPnwxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004187; c=relaxed/simple;
	bh=84C5rkV4lPSxXpOEh2p5zm/sZaLyYuxmn1qXY55Glwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpYlTM9C5Fh4kgwVwgbu45iQPSYprOqtVfA1wSUM5jjtyCyYS+M/Zm9v1Ak08r9Mipkm+aKrHTkoEuYr9yQCun01jLiRdcx4X1316uywWuij8rgMVIbHXo6vGta84IOD+7MvJdnIOHOxau7XIsAFEVGejhUneUX1bQ6GM9h0Hgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfmssTRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfmssTRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A267C32781;
	Wed,  3 Jul 2024 10:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004187;
	bh=84C5rkV4lPSxXpOEh2p5zm/sZaLyYuxmn1qXY55Glwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfmssTRRFyaIudYkEhneHdU0Qt98jpez8CD69qrVr/P17jv/Q4MOtF7sSlodfqZAa
	 9YkQkHTeTFCH2SMhHIJ82eZVglpuhCtcvyAi+c/QCMP6DvTnz7SRgQB6lYX++Hw2+j
	 w2F1BXOAp+8p6g1T8KnrycBFiM3UjpmcKvflMP4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <dawei.li@shingroup.cn>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/189] net/iucv: Avoid explicit cpumask var allocation on stack
Date: Wed,  3 Jul 2024 12:40:10 +0200
Message-ID: <20240703102847.097983365@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Li <dawei.li@shingroup.cn>

[ Upstream commit be4e1304419c99a164b4c0e101c7c2a756b635b9 ]

For CONFIG_CPUMASK_OFFSTACK=y kernel, explicit allocation of cpumask
variable on stack is not recommended since it can cause potential stack
overflow.

Instead, kernel code should always use *cpumask_var API(s) to allocate
cpumask var in config-neutral way, leaving allocation strategy to
CONFIG_CPUMASK_OFFSTACK.

Use *cpumask_var API(s) to address it.

Signed-off-by: Dawei Li <dawei.li@shingroup.cn>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://lore.kernel.org/r/20240331053441.1276826-2-dawei.li@shingroup.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/iucv.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 8b5b8cc93ff8b..f0364649186b9 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -565,7 +565,7 @@ static void iucv_setmask_mp(void)
  */
 static void iucv_setmask_up(void)
 {
-	cpumask_t cpumask;
+	static cpumask_t cpumask;
 	int cpu;
 
 	/* Disable all cpu but the first in cpu_irq_cpumask. */
@@ -673,23 +673,33 @@ static int iucv_cpu_online(unsigned int cpu)
 
 static int iucv_cpu_down_prep(unsigned int cpu)
 {
-	cpumask_t cpumask;
+	cpumask_var_t cpumask;
+	int ret = 0;
 
 	if (!iucv_path_table)
 		return 0;
 
-	cpumask_copy(&cpumask, &iucv_buffer_cpumask);
-	cpumask_clear_cpu(cpu, &cpumask);
-	if (cpumask_empty(&cpumask))
+	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_copy(cpumask, &iucv_buffer_cpumask);
+	cpumask_clear_cpu(cpu, cpumask);
+	if (cpumask_empty(cpumask)) {
 		/* Can't offline last IUCV enabled cpu. */
-		return -EINVAL;
+		ret = -EINVAL;
+		goto __free_cpumask;
+	}
 
 	iucv_retrieve_cpu(NULL);
 	if (!cpumask_empty(&iucv_irq_cpumask))
-		return 0;
+		goto __free_cpumask;
+
 	smp_call_function_single(cpumask_first(&iucv_buffer_cpumask),
 				 iucv_allow_cpu, NULL, 1);
-	return 0;
+
+__free_cpumask:
+	free_cpumask_var(cpumask);
+	return ret;
 }
 
 /**
-- 
2.43.0



