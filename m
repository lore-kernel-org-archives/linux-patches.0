Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5821E482EF;
	Mon,  1 Apr 2024 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991248; cv=none; b=QCqzUY134rsDH4Fs74s8pRhLo7BlFj6j0OZoJ2ZQ4vvV6l6pkjQcNzagjSg/89NCV1mVb1DyrSKSxVom3ZneVwzvMcrqezBGd0u+eAp4EJsI4pjn5cerBFt4NguX5UO5k4NdsYM6RGYsc+4zObbH0j4R/dkp9S3OU5KfjR/p1pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991248; c=relaxed/simple;
	bh=HIjFNuH4zISWzcfuZRkh3bT3K4nzEt+gQDXZe0Tb3s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uHi44eHK8bYtimcQTc4RfFn0Dq73mMdjKPPbZ66Bz1Hyy5idZXtjBV0LaCfva7ZL3aSujnJQ+2k/VlisSL6pK8I+yHE7eih+gABlewCQti9Uj+PB25oKxi4myaWum5gU3rUXLsbejU20XR94KZtGuE1PE+1C25Nl09UjR8+JK8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVEwhUl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVEwhUl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7392FC433F1;
	Mon,  1 Apr 2024 17:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991247;
	bh=HIjFNuH4zISWzcfuZRkh3bT3K4nzEt+gQDXZe0Tb3s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVEwhUl3yYQw67bdOB95mI6gKm344MHUY5Ss9KzF9i2pRU7q41dVS9X5fqg8250Ko
	 /HSQZ6JpuUp52J43O0FsTvb1WIkwtwt0ZHuqWYaMh5z8WAuJJMFgG7bRev8dGAyWuY
	 OKv/m77B0yfdGWOr4Y+XQ4CiukeKV2FybDHiFZXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20R=C3=B6sti?= <an.roesti@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/272] entry: Respect changes to system call number by trace_sys_enter()
Date: Mon,  1 Apr 2024 17:46:10 +0200
Message-ID: <20240401152536.432359818@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index be61332c66b54..ccf2b1e1b40be 100644
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



