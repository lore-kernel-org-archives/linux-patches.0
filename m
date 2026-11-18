Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061339;
	b=KHwfJHLl1y5GBM0NznbTtUYQe8NeXTilscZUvrxYZ9PjbGBEtSXv90xwGUtsWUrUW5xM
	 fwHqJ7JOUQ1GMb6uqvuXR+juLdshI2EsHyHSI0y+F0eDlloaSqUVRQSEIgEAuH+dipodv
	 AYVSK/hw8OlzBU2Ys/iilBpBHH4gcJLYpNpUeo9wOJ2tAzYMRcJe1DUU5x4XgJNBhkxwE
	 ck6GKyTwRlEayB53COchWEiXCnYjaPramD8FRX/ogEcL4/7Pt5NprUzLACXDuW9MzSdNW
	 pQEAln075z5kMExRH5Y+C9/i5dXg48cZG6Zt8FMXsyhgCGt5bMxspfFCt6aueGMaQ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7XB+ei9yvt53NUk/oEowtXTc6kLtIdBI37tZ49e6Z+M=;
	b=vXfxsMW7uHRbRfY8zdvvKY7rDN0k4FiRZOqtLwiz9zPK3WUSTBOLVVtjYNBHClhIN3U2
	 3hYsx3Yykh9lYPEN54VVX6ijYCRhyF5ll8pPvVcK1g1dGKr+G6CEfjxiOQlgCvUNlGW1H
	 CtbldZe9XpWx5KFf08NSwL9i5Y00g/X3dzj8K3l5r+2P+UENDBAZI84vYQdZp26mgiIam
	 aEFTwET9vfUO4gdnPvJi+iNgAIpEC53t4bAArvsXnnhkqEvrFzjJ4PDg0iLwWt7l8+obG
	 WjUEraNcfc32jgRkPvIFhYu19J/np1XQweBW+lXkK8qAP05HXR70sNhZhMRzZ2O+S0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RP+KebvO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC79E606A32A;
	Thu, 19 Nov 2026 04:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RP+KebvO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2CF1F000C4;
	Thu, 19 Nov 2026 04:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061338;
	bh=7XB+ei9yvt53NUk/oEowtXTc6kLtIdBI37tZ49e6Z+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RP+KebvOFE/I1fMRNeYWLbE9XHb3qiT64OVhYmfLChKtO5ODP8NiIz/ENqboP5Vkb
	 kOgwY/ygxq5s5Gyo+2idk37KX4fxlnNUl1aUrl/bWMdrQO0H7JP47Q1nvKVGhz7Tyy
	 8KdiZYMCfXz0yqb2ldYNR7J71y0M52yPOBDO/s28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1518/1848] init/main: fix off-by-one in argv_init cleanup
Date: Wed, 18 Nov 2026 15:59:16 +0100
Message-ID: <20261118150022.818384309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d23d1a8d5393f..a0142d0f6e1ae 100644
--- a/init/main.c
+++ b/init/main.c
@@ -557,7 +557,7 @@ static int __init init_setup(char *str)
 	 * the shell think it should execute a script with such name.
 	 * So we ignore all arguments entered _before_ init=... [MJ]
 	 */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
@@ -569,7 +569,7 @@ static int __init rdinit_setup(char *str)
 
 	ramdisk_execute_command = str;
 	/* See "auto" comment in init_setup */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
-- 
2.53.0



