Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055865;
	b=T2gE1EsgXB+IQlGKgxf+y84Ka/k7A4oXYVIH5iqKbQoJIsyABzngotSmrDRA8i2fy6EM
	 SJDbcJYCmtF57x3g6L4Aeoxk9ESXtki8S+XAM4vMkJZODnVLspKvHYIuQpxPFB5jm1+Vj
	 p8hx4T9HwyYljdITHUGq55Q/QIiRSPPUUNfLDUcFajgLfJ7QfJTK+hOuE1Oo6+3D4+9dy
	 Wa/m60XhRxubwd46Ae2+zWR/TUPGQ3hHmumwKD2PauEEh+WLy1OVTlGBeQM5Mihnbt2Z6
	 fW/0nirIPGg36gUi93z0GHPtuZz247BUxzD7yr97PqywydBXHkcRgni3nLvjTlg7mmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bssb3afId7MFITRVEpYDag3+3D4W8YDItsiOzjFIqrA=;
	b=ZK4s8H0jArr27/KRF+L2UYq4RARfwRiOJFI+z21/DVwjbcn/MP8rB0tdiKfi6IgpvjZw
	 LcAtByoyZJK932jaEz/2cmfJbs6KKERns32XEeLzJOBIfaj/VaxcJ1xpgG1hAfInaez+R
	 oPixfWSKoBoZLE7Jn1Gta8S4k2NM9GCabk3JiG7qaBdfAYLlrGJKPUcXqWuzEsLYLYTCH
	 PPwJandKPtHoyiQmk8W5N3LfzSt2nUTWF55kgtqui01XSsUr25KwzJcC/JFbVaE6N5KQt
	 oNbAa+xbrx6j7UeXTpYNQknVm2cst0PR2hLXTIT8cji3oR3fi0qvm6NqIJkNoTZU2vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eb24NXvi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7315C606A338;
	Thu, 19 Nov 2026 02:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eb24NXvi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55451F000C4;
	Thu, 19 Nov 2026 02:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055865;
	bh=bssb3afId7MFITRVEpYDag3+3D4W8YDItsiOzjFIqrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eb24NXviB72u9BJCqBxWn4ISSw6M7+XkA9L6/zlgw7qxmIIdKJ8CR175SGXTyz00v
	 ELehNkKRw3Y42Rz5XZpRou5gCUNfI1LrxizSjF3t4sCAMlHsg8zHl03QQHE34XEXoN
	 1faM4Uv/MRmdYXjKQTTs7K5OzaW2zzbUJdTKOcqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1785/2214] init/main: fix off-by-one in argv_init cleanup
Date: Wed, 18 Nov 2026 15:57:41 +0100
Message-ID: <20261118150122.882914769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fe0edf6d9aa7e..12a6d38adb7ed 100644
--- a/init/main.c
+++ b/init/main.c
@@ -570,7 +570,7 @@ static int __init init_setup(char *str)
 	 * the shell think it should execute a script with such name.
 	 * So we ignore all arguments entered _before_ init=... [MJ]
 	 */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
@@ -582,7 +582,7 @@ static int __init rdinit_setup(char *str)
 
 	ramdisk_execute_command = str;
 	/* See "auto" comment in init_setup */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
-- 
2.53.0



