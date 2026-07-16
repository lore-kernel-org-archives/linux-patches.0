Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26768400987;
	Thu, 16 Jul 2026 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209631; cv=none; b=gUK4Fy7V+4Erdw6n2lkQ13oiHP0RDZU9lgCF2vbKj/H+oZfzPLwh3UZoP2p4AMkh0nbruviGRDrLDbGc64vFOxAEMsCrZY+LVNhHYY9v4BsSwmjgBsfgyQftwHxQCylU0E0msYwKX4A0PgPHXvWXp9MAegFJhP8cu96qz9Xrejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209631; c=relaxed/simple;
	bh=ZFCOOWlm1XGuKKAzWamlxmbjpkI/6dlm6mn9tO/5x5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q68grsgIUnh4kezsND59yUPtCKxRDbjXwbZW1HI1/5L/pnTPqFXtXrPH2vvjV7N4xEgGrR7QvBXJzu2UBYpvastjipSI6OETGmJMx4FmO79Ey0UGx/CkZE6hnTohKpGtrMfdobMjoZbKVmKFkItR1geaNmqJVhuYjyr3k/FEEYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9gCRGq1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9gCRGq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F92E1F00A3A;
	Thu, 16 Jul 2026 13:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209628;
	bh=sCo6laKnD/F9ugW2tTlNduxlG4rBscTdtURv+v5czug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9gCRGq1I2TVjeDPeoXcC11hEPSVlw/+vhBHqY7S9gRbWW7xaKoZA4094Quo8/5lG
	 hs7fAh6vBmGgl6kvk83b7bXa0aGVUWu1AlhKwainnre8IW9IccMp1yu7Q0rsr0G6YE
	 tboybgZ8LxC49AOGBmBfRoaYdrEaanw8WJo7nF9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 7.1 256/518] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() error path
Date: Thu, 16 Jul 2026 15:28:44 +0200
Message-ID: <20260716133053.419541215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -1504,6 +1504,7 @@ static int do_cpu_nanosleep(const clocki
 		spin_lock_irq(&timer.it_lock);
 		error = posix_cpu_timer_set(&timer, flags, &it, NULL);
 		if (error) {
+			posix_cpu_timer_del(&timer);
 			spin_unlock_irq(&timer.it_lock);
 			return error;
 		}


