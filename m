Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B0C43B3DA;
	Tue, 21 Jul 2026 21:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671117; cv=none; b=AV3RW7bVNEjRK6mwbvFHnthZ9TxKSAY94Oc3R+G+gimEeA10g8nnF8+pOm1Y5JxGmPwCOLcvwg4Jl5pEbTnseT+FTq3SjIt9nhFoz6HsH2Yht0SQhbZQvD3oTKCU+TtDZJCJHz1qPMjDEm01c83cL9payp5Z2DahC+seD6WyEpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671117; c=relaxed/simple;
	bh=G/mC79dciedMwr8EHSJ7M0WJUPApcPCKL67UAngxhMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIJ1LKY2rbIdzYd0pMWsqOazcnxQ1PcBKANJUyUrpW8gT0JuDlKYjij3FdtpWDeCNEVbiEq8UqFs0U7A4r2XM1zKz+UISiS+9vxVPpHUjDDePbGDsspSkC/CFgmj5axddyoW+6SO9FHmzqUVSi6gpzoBf7Nr8xeoA3zijUOK5nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aW1Sh5eg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aW1Sh5eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E0F1F00A3F;
	Tue, 21 Jul 2026 21:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671108;
	bh=eFKKBiNrfa1HLwqmKXTmVIjbGi8Last9GQJvhMsxu6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aW1Sh5eg41HxtPrRscJ958YS3a7i4cOm8N1x8i+d6w7OEk8neGjpRUg0vAslZHWC6
	 PZg1VmJJyAQke/RaOkdQDHHnvT92gd2UABA8+H8KdaVDVvi6RP0WbJsR8RvzSLXuvh
	 MVmotkBwMrxcrt7rSbI9/KRMneTrr8mxMWDq1+yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 5.15 120/843] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() error path
Date: Tue, 21 Jul 2026 17:15:55 +0200
Message-ID: <20260721152408.704940730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1529,6 +1529,7 @@ static int do_cpu_nanosleep(const clocki
 		spin_lock_irq(&timer.it_lock);
 		error = posix_cpu_timer_set(&timer, flags, &it, NULL);
 		if (error) {
+			posix_cpu_timer_del(&timer);
 			spin_unlock_irq(&timer.it_lock);
 			return error;
 		}


