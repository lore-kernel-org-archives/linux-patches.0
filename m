Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FCBC129;
	Mon,  1 Apr 2024 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988829; cv=none; b=Fd7cJDRQwKdf4GPsAFc8VatZPFrESgxqSHRw7wrgIb/hj+IaxQjR/hOYKOlfM3Vsq59VFVyJmN7xAVXJX6y2nUzB6/sf4zxkRFo2Mry9IQaQog3QfxA24M77pMxW1GYTi4ZO7YGt+A1NsaybDNhW/L9CXdMisEej4FWZjNticrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988829; c=relaxed/simple;
	bh=dzvFngU4xzWNsk5MfWEm6blesgcsGRSZU8M5ZSf6jao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5MmiIaWn7eAzHi2SptVxH/pPA6OsFYT+O8hN+HiYbsB07+fqSbe6Y0bVvnpJQwzzjIdRFbEkhtftsR9FcUcRBcr0VqHzzc670SUMGdsBkHPrGE88THKNKnUGJMAmBv17sMSQRzQ/bW+9jpseF8f7T4099BLRMQgaXJDSCu+dG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/2d8sph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/2d8sph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D19C433C7;
	Mon,  1 Apr 2024 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988829;
	bh=dzvFngU4xzWNsk5MfWEm6blesgcsGRSZU8M5ZSf6jao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/2d8sphKpaaxnE6o/Mi5gF3VP+kvY0fL8OKpncSHi8SRxi69hcEm4Tn4xPyIg1uJ
	 FKAcQVXf03Guobs9KQgA5hC9AtO8d2jdOCUGKrYCRU6GRgXVscBa4t4neQ6URqO5xz
	 9VjAyFitpzNmeWZp4J8CKaf2LIp3bA9CrGpY3OGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20R=C3=B6sti?= <an.roesti@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 301/432] entry: Respect changes to system call number by trace_sys_enter()
Date: Mon,  1 Apr 2024 17:44:48 +0200
Message-ID: <20240401152602.169361102@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Rösti <an.roesti@gmail.com>

[ Upstream commit fb13b11d53875e28e7fbf0c26b288e4ea676aa9f ]

When a probe is registered at the trace_sys_enter() tracepoint, and that
probe changes the system call number, the old system call still gets
executed.  This worked correctly until commit b6ec41346103 ("core/entry:
Report syscall correctly for trace and audit"), which removed the
re-evaluation of the syscall number after the trace point.

Restore the original semantics by re-evaluating the system call number
after trace_sys_enter().

The performance impact of this re-evaluation is minimal because it only
takes place when a trace point is active, and compared to the actual trace
point overhead the read from a cache hot variable is negligible.

Fixes: b6ec41346103 ("core/entry: Report syscall correctly for trace and audit")
Signed-off-by: André Rösti <an.roesti@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240311211704.7262-1-an.roesti@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/entry/common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index d7ee4bc3f2ba3..5ff4f1cd36445 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -77,8 +77,14 @@ static long syscall_trace_enter(struct pt_regs *regs, long syscall,
 	/* Either of the above might have changed the syscall number */
 	syscall = syscall_get_nr(current, regs);
 
-	if (unlikely(work & SYSCALL_WORK_SYSCALL_TRACEPOINT))
+	if (unlikely(work & SYSCALL_WORK_SYSCALL_TRACEPOINT)) {
 		trace_sys_enter(regs, syscall);
+		/*
+		 * Probes or BPF hooks in the tracepoint may have changed the
+		 * system call number as well.
+		 */
+		syscall = syscall_get_nr(current, regs);
+	}
 
 	syscall_enter_audit(regs, syscall);
 
-- 
2.43.0



