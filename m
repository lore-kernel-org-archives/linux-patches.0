Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDAB3BA232;
	Tue, 21 Jul 2026 21:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668490; cv=none; b=I7Ge38YLEh6S2S0LFYHH8BfLlbjye9J4O/GfbbRFmnRJ5fPz1updOuLt0m8cK7UflfIwkgSHwHb1UCk906ZlvN+/XYdgBMgsHVr5VZ6m7dwC+HSxsfBUF/AdB7WkhCK8mwWdel3QXX9wrp0vh13HvbpCVCZgucrut4embCKs2OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668490; c=relaxed/simple;
	bh=fGMo+L2aWhBAi/t0W3dukjh+FFzbAgr0pbs2dG9qHYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/B4oJ7nFqqPa/y9QyGFDyOaoY+sbCIP6Y53zifEn9wdrF0x2bbodK6anTKxbRiQsoaZsh0BAnESuP+li5k6nrYoPZ1SAZx7v/WNquHHLTnT3tdST1mU2H3/LgocKXGCEn9TwNZqdXRdamC0Ji2qF7h272lZ84wbl8u3EoO/L+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIiV4qsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIiV4qsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7137D1F000E9;
	Tue, 21 Jul 2026 21:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668488;
	bh=mTxZHvH8ttv7sC4VyL/2b+JmVnqGg9H3ERJr7ocMRhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIiV4qsm9j5EY15hJChM2CZGflJeKrof2q8Ve/t5OkYd3ET2L1VW1ZfUh5y9joCfq
	 gaZ27ldwCX3/epeyrJFehEOn1uT8nSYeCtVhf5f9fYhLxSgUUfjTYJATMHEhYBz9RG
	 ePB+Abl+M1WOSF6MSn4GXTU26ghl2FDuQcm1b6WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 6.1 0152/1067] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() error path
Date: Tue, 21 Jul 2026 17:12:33 +0200
Message-ID: <20260721152427.995190482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1536,6 +1536,7 @@ static int do_cpu_nanosleep(const clocki
 		spin_lock_irq(&timer.it_lock);
 		error = posix_cpu_timer_set(&timer, flags, &it, NULL);
 		if (error) {
+			posix_cpu_timer_del(&timer);
 			spin_unlock_irq(&timer.it_lock);
 			return error;
 		}


