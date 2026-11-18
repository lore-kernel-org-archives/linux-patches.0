Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018982;
	b=fYCN8pYrRUIudXr54erRH/HKJ1f5ACBDE9ttgAKeVOXN9TaYvNnwfz9QUppeD2WgrHBB
	 EgIhNBEuU1s6tDZjqj57JrH6FuFiCCSwLKZ7WBWer4tQoXYDyoUYYP6+4FIJEF2DXZr3X
	 7e3a6VPJgwI2k9gPCHyqihdbGdl4j5/zS4W2WqcwjsJAQt+hoYWJHEfS6ouEpnegLUuRt
	 0bBswVxPKH8eDKNDpniMa1TgUwu1nshHuK12vETWWZld7hcUVD90YHMvnUD7cLUF2SLb/
	 3tCoR2HDFRQy7W7/k0TDqewvsLzQjw1WXuau3YwXS+nlt4ZLQ2/GJw4QOGfvyNmlfbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AWJwWnSLi5zSOhMjFDzcwIK3LumEv5gwmTyy3Ae0fMI=;
	b=IcYdntJxRSzhpzv+8cpcA/b6KZPkqEckGJomFglXm/ck5MuG/pLfsvJ4TZPFhX67zub4
	 9el/MxtLa9L0Oy9u5q904xmJO9K0+n7SRDYUmFAevPM7nu1NmqX9dcuWi+q6aWAWuE/Xf
	 RjsTytxWzU6iAdmTnZye3MVTP3HVoMFBJgDS1Hf5B0txliamIgj1Bz+GROrg2VUCSrPF2
	 8+idenAedrj7EJflZzwvGZtpzDMWZSMlIreNidQ+D1EkXs1z1DXZdPAGyq8skXx6hQer5
	 EiYj5UEZGiNKIJM1rkWaEbcF91cU4xuY7KoCGym6RxL2V7vTI5l2K9UZJWHi6c4V9tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hR7JTKE9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31C8606A31C;
	Wed, 18 Nov 2026 16:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hR7JTKE9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C1E1F000C4;
	Wed, 18 Nov 2026 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018981;
	bh=AWJwWnSLi5zSOhMjFDzcwIK3LumEv5gwmTyy3Ae0fMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hR7JTKE9ICuyqo+lVevCk33y5fYFtLkXdAmIz3zyT0Jr7iYeOKqV+5ZljsYsA1RID
	 WWXva6pZvsLwAmaJ2OhUoqwvb415ayeMx8PUY3CzFsVCBbQShUqHBTdq2l1FmCcwuD
	 3MvdagwPmqx+r4MPdfOlL7ljk5aG6fmDnavzVA4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1396/2651] init/main: fix off-by-one in argv_init cleanup
Date: Wed, 18 Nov 2026 15:43:56 +0100
Message-ID: <20261118150338.274251052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 4efcb9956c39c..fc2c8000f49b6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -581,7 +581,7 @@ static int __init init_setup(char *str)
 	 * the shell think it should execute a script with such name.
 	 * So we ignore all arguments entered _before_ init=... [MJ]
 	 */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
@@ -594,7 +594,7 @@ static int __init rdinit_setup(char *str)
 	ramdisk_execute_command = str;
 	ramdisk_execute_command_set = true;
 	/* See "auto" comment in init_setup */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
-- 
2.53.0



