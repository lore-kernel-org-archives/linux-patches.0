Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064781;
	b=xD+OGV4rMZmGv3O/5jEKdN5cSy2sWh6fOf03XHgd9E/kYim0H5M+eOm4vMIdrzkITUcQ
	 pDgNN3wrG9DG5xYaY5Axy1G1ZIu/ely1Svc7XowphhJgc1hUoXUFnbnVm6hzVSHFqxfjn
	 YJlKNsBPPCVdfY9hGH2mqvlG0hXFXs0E0KUtsLgAZs7pAUhfC4UrsPVKMmKT/PMw5MfnH
	 PlbQJz991Rp9E42Rgxl28sp4abwkU+shuAfse8/O1LhO5E4suplXZOMy5EsR2si4hxhkx
	 bHK1V1HnZgsHdmKYr+6/0+LSuJFNdBl21TQ5tYD7crPxSQnZriZBcvwjsntELwx2Png==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3zlvuXcFCmeU6QEY8Z2n43Y4Xjnom0WeKNIPi91b/KI=;
	b=vslCi792OQjZcMkQHUgF7pxGgEuO9YPP2nyWZqZgPzVoQsfLRz83iyyRfh/YlWzEtuPo
	 YDNLO94Q07hnMrallnly/FS2G0FAAApnWd5aA6aQwNU5lD74788c+O14yFIXZcgf72ybn
	 eOdKVHZ1d3e59eXgUG+rCPo12M6fOBSmWw6KZZuh+sJHhbi0DcWzSH9lJFgK2wbwFRwE+
	 +mW6Oz8BauYhX0xyy+qemYT0yziuQSo0/b+muZcLW36iTTjGCO3T5b3OxImJ14kT6v4Px
	 5AqM0obJhGzGaA/KKYDXY2wvrDOXQvQSkolptJM3Wvx13tAW+/02WnXOghaC855FmXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k62t1KqE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DEB606A9F2;
	Sat,  7 Nov 2026 15:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k62t1KqE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C5D1F0089F;
	Sat,  7 Nov 2026 15:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064781;
	bh=3zlvuXcFCmeU6QEY8Z2n43Y4Xjnom0WeKNIPi91b/KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k62t1KqEzwK+hrgvI5fiV7telwUiYL8LTOTcMQK0TlYbT8RW9N/hMuWVMpxqWcIRc
	 FKk/xJjUZ02ROgLJGHUuQTbzNvn7yFRFFEoBp5YrFljwGPHwtsMJf4f62kziYd+umk
	 xs07LU2hwckFbnYmgHu7w3gAohOAARJzG36Spksg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <brads@mainlining.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Guenetr Roeck <linux@roeck-us.net>,
	Wang Jinchao <wangjinchao600@gmail.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0731/1257] panic: fix redirect CPU race in panic_try_force_cpu()
Date: Sat,  7 Nov 2026 08:50:27 -0500
Message-ID: <20261107134959.463237241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <brads@mainlining.org>

[ Upstream commit 73554d8db4951d2a486405a2759cc0ffd282c0b2 ]

Patch series "panic: fix panic_force_cpu= redirect races and NMI bypass",
v7.

The panic_force_cpu= parameter redirects a panic to a specific CPU so the
crash kernel runs there.  The redirect code in panic_try_force_cpu() had
two races and an NMI bypass, all found by Sashiko.  This series closes
them and kills one more hack that the rework turned up.

Panic from NMI still goes through the redirect path first, so the crash
kernel ends up on the CPU the admin asked for.  The redirect buffer is a
static 1KB now, no initcall, no fallback message.

This patch (of 6):

The cmpxchg() in panic_try_force_cpu() makes sure that only one CPU tries
to redirect panic() to the requested CPU.  It is similar to the cmpxchg()
in panic_try_start() which makes sure that only one CPU does the panic().
In both situations, only the winner of cmpxchg() should proceed further.
Other CPUs should go offline.

There is a bug because the cmpxchg loser returns false and falls through
into vpanic().  Two non-target CPUs A and B panic, the requested CPU is C:

             cpu A                          cpu B
          ----------                     ----------
    panic()                              panic()
    vpanic()                             vpanic()
    panic_try_force_cpu()                panic_try_force_cpu()
        cmpxchg wins                        cmpxchg fails
        redirect = A                        old_cpu = A
        IPI -> C                            return false      <- BUG
        return true                     panic_try_start() wins
    panic_smp_self_stop()                __crash_kexec() on B
    (A stops)                            (target C bypassed)

The loser must stop, not fall through.  It cannot just return true,
though.  A CPU that already won the redirect cmpxchg can reenter
panic_try_force_cpu() on the same CPU, for example a nested NMI during the
message formatting, before the IPI is sent:

             cpu A (1st)                  cpu A (nested)
          ----------                     ----------
    panic()
    vpanic()
    panic_try_force_cpu()
        cmpxchg wins (redirect = A)
        vsnprintf(msg) ...
            <-- NMI, nested panic -->
                                     panic()
                                     vpanic()
                                     panic_try_force_cpu()
                                         cmpxchg fails
                                         old_cpu == A (this CPU)
                                         return true   <- would halt
                                     panic_smp_self_stop()
                                     (IPI never sent, panic abandoned)

Check old_cpu against this_cpu so a second call from the same CPU returns
false and falls through to panic_try_start() instead.

Also fix the panic_in_progress() check.  We must not redirect when
panic_cpu is already assigned.  Return true to stop when the panic is on
another CPU, false to proceed when it is this one.

Update the panic_try_force_cpu() doc comment for the new return value
semantics.

Link: https://lore.kernel.org/20260916182957.7788-1-brads@mainlining.org
Link: https://lore.kernel.org/20260916182957.7788-2-brads@mainlining.org
Fixes: 2e171ab29f91 ("panic: add panic_force_cpu= parameter to redirect panic to a specific CPU")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260705164123.18746-1-include@grrlz.net
Closes: https://sashiko.dev/#/patchset/20260707172252.4842-1-include@grrlz.net
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 213725b612aa1..010b331658b6b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -371,8 +371,9 @@ int __weak panic_smp_redirect_cpu(int target_cpu, void *msg)
  * for the crash kernel to function correctly. This function redirects
  * panic handling to the CPU specified via the panic_force_cpu= boot parameter.
  *
- * Returns false if panic should proceed on current CPU.
- * Returns true if panic was redirected.
+ * Returns true when this CPU must stop: the panic was redirected or is
+ * already running on another CPU.
+ * Returns false when panic() should proceed on this CPU.
  */
 __printf(1, 0)
 static bool panic_try_force_cpu(const char *fmt, va_list args)
@@ -396,16 +397,20 @@ static bool panic_try_force_cpu(const char *fmt, va_list args)
 		return false;
 	}
 
-	/* Another panic already in progress */
+	/*
+	 * Don't redirect when a panic is already in progress. Stop this
+	 * CPU when it's another one, proceed when it's this one.
+	 */
 	if (panic_in_progress())
-		return false;
+		return panic_on_other_cpu();
 
 	/*
-	 * Only one CPU can do the redirect. Use atomic cmpxchg to ensure
-	 * we don't race with another CPU also trying to redirect.
+	 * Only one CPU can do the redirection. Others should go offline.
+	 * Continue with panic() when we already tried the redirection
+	 * from this CPU before, for example via nmi_panic().
 	 */
 	if (!atomic_try_cmpxchg(&panic_redirect_cpu, &old_cpu, this_cpu))
-		return false;
+		return old_cpu != this_cpu;
 
 	/*
 	 * Use dynamically allocated buffer if available, otherwise
-- 
2.53.0



