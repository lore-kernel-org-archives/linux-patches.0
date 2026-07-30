Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CC6435A9E;
	Thu, 30 Jul 2026 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425532; cv=none; b=RH7Rpn8BziXt8c25mnGE+H9FW8DFO1YOCIuzCzXGtNOaY1zDTP1wXZI25q2IzuwMeKv0vsx8R3OIkg+nkNlXBHJpuLTYGTzlKvQBiFoR/8eyOUwQxFsc50oRgKHzZKqHLEeBHrCR5lfHbSVJTqmUSofS/By7fK3kmpxoJrw/BDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425532; c=relaxed/simple;
	bh=ILiI9uB7cupnsNuTbiMlDPnetiFsAoazmAzHPvUjzQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKpUDfHlnwMYwbJEKPPla/H5DjhSuV24bvra1DojBAgInAZ8Q5ac/z0x9O2zjffxjHbvlwfbT4NdTd6CgaedOnS33AVL6ncSxr9EiRr4Lk4mQSbyU0L2UcMDA20cHm29Nji0xMpJt4dfV9EWvkVgwvmAXoH7MK9cbiZGVBsO/2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rquNbpq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rquNbpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2151F000E9;
	Thu, 30 Jul 2026 15:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425531;
	bh=z+biOczrTNa3JxlUC40o1j4lQuuhmM3oQJV80K3t0LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0rquNbpqckCb73TIG2C7V0Tou1IoP8TM86uPR4BtdI358YLwZFrWi6OplJaFcze+p
	 YF+21/VmL4bhFPFcyxL89KGv5PtQroBg8shsD5jq3+9XNp9xHf9nzFbC7iRt77GKq1
	 EKo8GJl4HXnrpGBWPd0asscDrk3uZTTtLbHxZMKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Harris <mark.hsj@gmail.com>,
	Nam Cao <namcao@linutronix.de>,
	Michael Ellerman <mpe@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/602] riscv: hwprobe: Avoid uninitialized read in hwprobe_get_cpus()
Date: Thu, 30 Jul 2026 16:08:15 +0200
Message-ID: <20260730141438.158674096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fc62548888c587..d273080bec34d8 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -336,6 +336,7 @@ static int hwprobe_get_cpus(struct riscv_hwprobe __user *pairs,
 	if (cpusetsize > cpumask_size())
 		cpusetsize = cpumask_size();
 
+	cpumask_clear(&cpus);
 	ret = copy_from_user(&cpus, cpus_user, cpusetsize);
 	if (ret)
 		return -EFAULT;
-- 
2.53.0



