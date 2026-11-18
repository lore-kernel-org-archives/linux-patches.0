Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040964;
	b=rDc37zS53HiAmxMuuu1j5EOMsxIvTYo+lWUwKJAMTQelRDldS3kUBBKdMxi8+YUI9o9N
	 ZcjvBmGgn5VVO1ix3DBps0E53teS6H2n2L1BQeBDDbPBhBEX2Q3lkrvEeuP7TP0sG+JEs
	 JNi5ivdONN9KSKepPv1gvvumdK7strF8VQTrJsk5r4SAxDrFfwWwsEN+Ij4fczIEbq5pz
	 0JkcZyDKlFtN+rluAJgcqwdhL31zopSSK8IghJQtZGj+C/bhm9rxhokiCbKbkLsWsbBur
	 4kQQLLNUrknf2epOhx1uzypYqTZtOsgOneoIrkesjJYUkgpd9UAhN/s9110auyDlVeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JHP+Ahb8ET5/AVICDrASi4Mqem47HwznVLIymczcur8=;
	b=Z8A88hMEz+k/9tMg3xoHaYwhHxPpC0eyHTgm0RkDVhriOj5NM/SeCky+gTEDoI078lNh
	 bFBnW2RseMA/LVf15dE/SWvYDBmLJCl5xoGVJXur1HJuL8Sxz2ZoLEnP74VVuzeJr9Hm0
	 BuYTFvAG+XnZHaFgQc0bFsF0GuktG3ImcOW2t+zN/mrZYhUhP+2kCfnKpflJrQExTb5oy
	 YUKGF/5q5cPf2hL91DCVuOxXuhY1rc0pEeHNpi0BQWJey5Vzl0lIHoOxTuseVnWCJzTrd
	 J0MBYtTq7i7Tq1zAsjfEB1YiutO4KnSqBbbazn8O2w1aAUe3urCmU9IclKB8DfB0bEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c3GLKnD8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B89606A31C;
	Wed, 18 Nov 2026 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c3GLKnD8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E8F1F000C4;
	Wed, 18 Nov 2026 22:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040964;
	bh=JHP+Ahb8ET5/AVICDrASi4Mqem47HwznVLIymczcur8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3GLKnD8+DA5hBI7cBNw9rxQvirKGAgoPHn9nDwnljQwb4vE8fUejNVdrtiCbwqWY
	 I+dR5VHO1tnPl5nTnjYzasnm4fab6Ei8kR4o55FIU9hVcmPrzku2qnWE+yiB0BX0cf
	 yyVxbDpAmgUnv/09EbqEe87U8+uX4oxPQRKU/tv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2645/3318] init/main: fix off-by-one in argv_init cleanup
Date: Wed, 18 Nov 2026 15:54:27 +0100
Message-ID: <20261118150440.411403753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilson Felipe Pereira <wfelipe@google.com>

[ Upstream commit b82ed0e3a1dafe41577b095318a3ea6c0eec6f46 ]

Patch series "init: fix array boundary bugs in boot parameter parsing".

This series fixes two distinct boundary logic edge-case bugs in
`init/main.c` related to parsing boot command-line arguments and
environment variables.  Both bugs have been present since the early git
history (Linux-2.6.12-rc2).

1. The first patch fixes an off-by-one error in `init_setup()` where
   the final slot of the `argv_init` array was left uncleared. This
   allowed a stale kernel parameter to leak into the `init` process's
   user-space command line if exactly `MAX_INIT_ARGS` unknown
   parameters were passed.

2. The second patch fixes a false-positive kernel panic in
   `unknown_bootoption()`. If a user filled the environment variable
   array up to its exact limit (32) and then attempted to overwrite
   the final variable, the kernel would panic before evaluating
   whether it was a harmless duplicate.

Exact QEMU reproduction steps for both edge cases are documented inside
their respective commit descriptions.

This patch (of 2):

When cleaning up argv_init in init_setup() and rdinit_setup(), the loop
terminates one element early due to using '<' instead of '<='.  Since
argv_init is sized MAX_INIT_ARGS+2, index MAX_INIT_ARGS is a valid element
that should be cleared to NULL.

If exactly MAX_INIT_ARGS unknown arguments are passed before 'init=', the
uncleared argv_init[MAX_INIT_ARGS] can act as a ghost argument to
/sbin/init or cause a spurious kernel panic when later appended to.

To verify the argument leak, boot a VM into a shell with 32 unknown kernel
arguments, the init parameter, and 31 user arguments:

  STALE_ARGS=$(for i in {1..32}; do echo -n "stale$i "; done)
  USER_ARGS=$(for i in {1..31}; do echo -n "user$i "; done)
  qemu-system-x86_64 -kernel bzImage \
      -append "$STALE_ARGS init=/bin/sh $USER_ARGS"

Running `cat /proc/1/cmdline` inside the shell reveals that the 32nd
kernel argument ('stale32') incorrectly leaked into the init process's
command line.  This patch zeroes the final slot, cleanly terminating the
array.

Link: https://lore.kernel.org/20260818045357.4123784-1-wfelipe@google.com
Link: https://lore.kernel.org/20260818045357.4123784-2-wfelipe@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: ffdfc40976dd ("[PATCH] Add rdinit parameter to pick early userspace init")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index e7b171527a1c8..968c93ea14fdd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -563,7 +563,7 @@ static int __init init_setup(char *str)
 	 * the shell think it should execute a script with such name.
 	 * So we ignore all arguments entered _before_ init=... [MJ]
 	 */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
@@ -575,7 +575,7 @@ static int __init rdinit_setup(char *str)
 
 	ramdisk_execute_command = str;
 	/* See "auto" comment in init_setup */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
-- 
2.53.0



