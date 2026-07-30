Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6645E43F080;
	Thu, 30 Jul 2026 14:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421487; cv=none; b=MS71X5YOxq24p0uc3yTyZkJqC6DoVQEVOKFOOFJNESBlYuUVUwml/8QONeKg6TxE3eKtOYIxISaD/Icz8pzAbReKyawTPAzIBV47g2hkkmlWNB1g6UI3ZO39E6XOSIkfdu8VEn/2q+dK7ZZzokWUgo+sB5UatCs5mxNHD6P2dNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421487; c=relaxed/simple;
	bh=fsHncDOk15yRCsJJWOvJldT4gVwQh2rZ+qc52Vy4S7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDGfk6p16KTZBwNGgeM6njS2xcnr3nPOtWjQOSnz0eMM7+nOmiCSyQYWgRGUqVfz/LA8/lQ56r/JJ7wtYTdHdYu6g2ebbSJezslpoT+Mmzmz+gktwp/DZE2Q8HIEN6Myc6zW2i/ZftF8k6Nyc7+H3cgRl/lXJB6cSuNUjA+kS08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E94EF7/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E94EF7/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B688B1F000E9;
	Thu, 30 Jul 2026 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421486;
	bh=28ekxkUadN9JOLI1aP4MC3B1wEcvVCh3KChsoehxxCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E94EF7/ZP6LRUg0pPNI1w6MOaGeG5zOjwuUx9s3Bde7Q6wwV/XKbuEvqVtf2n7l1c
	 PlMBLwMkXEkuxFer0cen3B9HBHELIOsAq1jIDvHTfDxPX6l4v2M2p/XMWQLsG69ryy
	 0EqRPFjbiJranIEObltWgxbzLgnbZIIn+lY2ZyKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Harris <mark.hsj@gmail.com>,
	Nam Cao <namcao@linutronix.de>,
	Michael Ellerman <mpe@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 118/744] riscv: hwprobe: Avoid uninitialized read in hwprobe_get_cpus()
Date: Thu, 30 Jul 2026 16:06:31 +0200
Message-ID: <20260730141446.788653315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harris <mark.hsj@gmail.com>

[ Upstream commit 5caae1deee89a6582c761d5dcd4b924b744426cc ]

When cpusetsize < cpumask_size(), hwprobe_get_cpus() did not fully
initialize its copy of the cpu mask, which could cause non-deterministic
results from the riscv_hwprobe syscall on a system with more than 8 CPUs
when the supplied cpu mask is empty.  Address this by fully initializing
the cpu mask.

Fixes: e178bf146e4b ("RISC-V: hwprobe: Introduce which-cpus flag")
Signed-off-by: Mark Harris <mark.hsj@gmail.com>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Michael Ellerman <mpe@kernel.org>
Link: https://patch.msgid.link/20260714003056.73707-1-mark.hsj@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/sys_hwprobe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 1659d31fd288fc..caf6762427c87e 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -450,6 +450,7 @@ static int hwprobe_get_cpus(struct riscv_hwprobe __user *pairs,
 	if (cpusetsize > cpumask_size())
 		cpusetsize = cpumask_size();
 
+	cpumask_clear(&cpus);
 	ret = copy_from_user(&cpus, cpus_user, cpusetsize);
 	if (ret)
 		return -EFAULT;
-- 
2.53.0



