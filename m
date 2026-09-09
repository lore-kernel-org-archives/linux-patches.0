Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C483E4C6803;
	Wed,  9 Sep 2026 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962100; cv=none; b=SnjzaWqMHDP6nSCadIot0xkOIV5v7+W2lxBtJ98Ph1tKUmRfcFRI3LGZGoz7h+87aS3yqTgGjUu6PHyrmhFs+K/eoTSlf/vaQrIFredEdaEqPfJSEcaIyBohJmxC3CIikGBlCI/15NB3JU420N5mk9Y1p9E1ER1Vu9z7qd3P1CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962100; c=relaxed/simple;
	bh=XwykmkyZ+4ZKDaMBjRgK3DAQFdA9pXfXKcZXWp6IfUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkmvQpvNwEoiOf7oi2ExDHQy1lGjOTKv0ypvtS7oY9OhZ0UVFfFeWTXo2cke/GQZoufGjNCGAMUTYHWPcjGjG7texnXqFjJQdyb+BC0u3pUCeC1PncRy9KwwWqOIs2YcOJnaoZKRSl3mYYLm4XEt8TxmicjT6THoN39zQYue9Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ea6fm9vR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ea6fm9vR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339721F00A3A;
	Wed,  9 Sep 2026 13:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962098;
	bh=6hgFw5w+NG/P06JXC+Tb51lCD/rIvE6d4AISyNz59b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ea6fm9vRPSr1OAWYtfIdSmAujfvKcqthVtm+3s7GBvAGRAwr2L6goNg5lEMJZgS7U
	 6z4+2Ae5EA8NOmBzTAg7SdVC+f2WzeScMq2mFoIKOzPGhKwPboM6VH/QDjXpMWE+gn
	 /M5acXLfpgZvmvcMiYHWSVtjs+y6PBHDxef0To4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 166/556] Revert "once: dont use a work queue to reset sleepable static key"
Date: Wed,  9 Sep 2026 15:37:26 +0200
Message-ID: <20260909134236.258842180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 0ba6912f7e974045dcdd170f022cba19247e00bc upstream.

This reverts commit e8eef69a99f185e75909adb24ab93d706e07bf27.

While DO_ONCE_SLEEPABLE() is used from sleepable/process context, callers
may still be holding arbitrary subsystem locks.

For instance, __inet_hash_connect() uses get_random_sleepable_once() which
invokes DO_ONCE_SLEEPABLE() while holding the socket lock (sk_lock):

  lock_sock(sk)
    __inet_hash_connect()
      get_random_sleepable_once()
        DO_ONCE_SLEEPABLE()
          __do_once_sleepable_done()
            static_branch_disable()
              static_key_disable()
                cpus_read_lock()

Calling static_branch_disable() directly from __do_once_sleepable_done()
causes static_key_disable() to synchronously acquire cpus_read_lock()
(cpu_hotplug_lock) and jump_label_mutex inside the caller's lock context.

This introduces an unwanted lockdep dependency:
  sk_lock -> cpu_hotplug_lock

Because cpu_hotplug_lock depends on fs_reclaim (via workqueue CPU bringup
allocating memory with GFP_KERNEL), and storage/block layers (such as
NVMe-TCP) acquire sk_lock during I/O dispatch, lockdep reports circular
locking dependencies:

  set->srcu -> sk_lock -> cpu_hotplug_lock -> fs_reclaim -> q_usage_counter -> elevator_lock -> set->srcu

This false positive previously prompted commit 19bdb70c77d3 ("nvme-tcp:
lockdep: use dynamic lockdep keys per socket instance") to work around the
warning using per-socket dynamic keys in NVMe-TCP.  That in turn broke
asynchronous socket teardown and caused syzbot warnings in
tcp_tsq_handler().

Restoring once_disable_jump() in __do_once_sleepable_done() ensures that
static_branch_disable() is executed asynchronously from a system workqueue
without holding the caller's locks.

Link: https://lore.kernel.org/20260825142515.1965654-1-edumazet@google.com
Fixes: e8eef69a99f1 ("once: don't use a work queue to reset sleepable static key")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Closes: https://lore.kernel.org/lkml/ao0mwtt8ePAINFni@shinhome/
Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/once.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/once.c
+++ b/lib/once.c
@@ -93,6 +93,6 @@ void __do_once_sleepable_done(bool *done
 {
 	*done = true;
 	mutex_unlock(&once_mutex);
-	static_branch_disable(once_key);
+	once_disable_jump(once_key, mod);
 }
 EXPORT_SYMBOL(__do_once_sleepable_done);


