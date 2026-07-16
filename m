Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36E6430CE6;
	Thu, 16 Jul 2026 14:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212200; cv=none; b=UFFfX0kvn3Ob4dOfpIMWHmbbNv0cdsVO+OVlYD2N03XbCG+pT5DvkzfEMMd82KN8oHTSdQYN+wIwJN3iP+j+QNXVK/Mrqm2sS+l4zlY9TkmYHeNMVtvJUBzjrl7bUIGhkVjeOS68PAY/DVEXqFBpYYIuJ+4Q+Sp2jw+Kjn7irqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212200; c=relaxed/simple;
	bh=4LKGm+YGF1nDIDCxUF9fn6c7eGgehK44rJqHi0RoNDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgO6BjXutMJc6HQYWh5qiFWheu0yYCPkBTDjVG8M0wf5+UgnSPvt7n3H1lb/0eM3+Td5qf4amfNMdAXq0Jqcp6JislFwBziZ4w+lYHd0VMqPb1xYQUqx+8vxVlrSGx6rUPss8K+7cNF7L8ZmpaJD1cs3e/Cg2fS24tByhI7J574=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Fx6Vqzy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Fx6Vqzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E7F1F00A3A;
	Thu, 16 Jul 2026 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212199;
	bh=DxVsDk8TNzL7cdNHMcnlF6BfEA6LCahwP8Lr1xa8d/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Fx6VqzyTc0x5Yo1deHo13FtesumvQdIyQvBermaRzITynRx3P10dew9IDRpJhR4d
	 FjVBw89z73iNC7xQK3WS4mSjZq3iziFEQlusIKXy7ZausO2Sn0iCbqLFJSYOA1ijRT
	 5Kb4Mv0+9h0AB11MLNOjvBQTqrzJNehMivkKkkC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 6.12 194/349] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() error path
Date: Thu, 16 Jul 2026 15:32:08 +0200
Message-ID: <20260716133037.717450630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit 87bd2ad568e15b90d5f7d4bcd70342d05dad649c upstream.

In do_cpu_nanosleep(), posix_cpu_timer_create() takes a pid reference
via get_pid() and stores it in timer.it.cpu.pid. If the subsequent
posix_cpu_timer_set() call fails, the function returns immediately
without calling posix_cpu_timer_del() to release the pid reference,
causing a leak.

Fix it by calling posix_cpu_timer_del() before the unlock-and-return
on the error path, consistent with the other exit paths in the same
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260611161738.97043-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-cpu-timers.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1498,6 +1498,7 @@ static int do_cpu_nanosleep(const clocki
 		spin_lock_irq(&timer.it_lock);
 		error = posix_cpu_timer_set(&timer, flags, &it, NULL);
 		if (error) {
+			posix_cpu_timer_del(&timer);
 			spin_unlock_irq(&timer.it_lock);
 			return error;
 		}


