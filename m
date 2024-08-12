Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284ED1862B4;
	Mon, 12 Aug 2024 16:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479497; cv=none; b=eDgStJ41Si/pUmnHRCMUJ5zgiI8RJw844h3IdNcu19/X/u/QMVkMK7WM2WafwAtg+6seusvJW2ENoatqahlC9jzG/DZJmk5pITF9VExABxAUyjoQBmt4FVjsv+ow+7etek1dw6Sbc4iWNMKxEhHhcupQ9Ws0LqoiSNKSY4J3U3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479497; c=relaxed/simple;
	bh=fxIfP1gT3NV//cKVz8CtXMUGkZEsKOFFwgCbNxxwZTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHuk5JvlejqDohcRJjEyKBgxeFk6WH96LFBO0CORwdcyR2cK1aoLMwBedXqmHLQJyUgyAtyzqRLo+vd80K+H68DcHLzF4/Aj9BLcGVppnP6Wdwyc+L7/sX6WUlZdL1YL44futra10r+6KYTaPT82Q6vfwz7aoNn8tjwxEHrqWX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJ+lS/AL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJ+lS/AL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FD1C32782;
	Mon, 12 Aug 2024 16:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479497;
	bh=fxIfP1gT3NV//cKVz8CtXMUGkZEsKOFFwgCbNxxwZTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJ+lS/ALsw7Te7aQs/hRbizUfcZHiZknq8bN6gur4R2LqOdE0f5HPvJyZZ6mlpEkC
	 VYJ9ffg3tynG5hRkIKRFPbRV4gyoqvvuSsPxcczoccDvDUyc0rROFs+xvajsZm+euk
	 4cQev6awbdDK26FOwzbj/7w2V/mZe1Ae7AVs5oZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <linux@armlinux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 106/189] module: warn about excessively long module waits
Date: Mon, 12 Aug 2024 18:02:42 +0200
Message-ID: <20240812160136.220824304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit cb5b81bc9a448f8db817566f60f92e2ea788ea0f ]

Russell King reported that the arm cbc(aes) crypto module hangs when
loaded, and Herbert Xu bisected it to commit 9b9879fc0327 ("modules:
catch concurrent module loads, treat them as idempotent"), and noted:

 "So what's happening here is that the first modprobe tries to load a
  fallback CBC implementation, in doing so it triggers a load of the
  exact same module due to module aliases.

  IOW we're loading aes-arm-bs which provides cbc(aes). However, this
  needs a fallback of cbc(aes) to operate, which is made out of the
  generic cbc module + any implementation of aes, or ecb(aes). The
  latter happens to also be provided by aes-arm-cb so that's why it
  tries to load the same module again"

So loading the aes-arm-bs module ends up wanting to recursively load
itself, and the recursive load then ends up waiting for the original
module load to complete.

This is a regression, in that it used to be that we just tried to load
the module multiple times, and then as we went on to install it the
second time we would instead just error out because the module name
already existed.

That is actually also exactly what the original "catch concurrent loads"
patch did in commit 9828ed3f695a ("module: error out early on concurrent
load of the same module file"), but it turns out that it ends up being
racy, in that erroring out before the module has been fully initialized
will cause failures in dependent module loading.

See commit ac2263b588df (which was the revert of that "error out early")
commit for details about why erroring out before the module has been
initialized is actually fundamentally racy.

Now, for the actual recursive module load (as opposed to just
concurrently loading the same module twice), the race is not an issue.

At the same time it's hard for the kernel to see that this is recursion,
because the module load is always done from a usermode helper, so the
recursion is not some simple callchain within the kernel.

End result: this is not the real fix, but this at least adds a warning
for the situation (admittedly much too late for all the debugging pain
that Russell and Herbert went through) and if we can come to a
resolution on how to detect the recursion properly, this re-organizes
the code to make that easier.

Link: https://lore.kernel.org/all/ZrFHLqvFqhzykuYw@shell.armlinux.org.uk/
Reported-by: Russell King <linux@armlinux.org.uk>
Debugged-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 2124d84db293 ("module: make waiting for a concurrent module loader interruptible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 34d9e718c2c7d..f3076654eee12 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3160,15 +3160,28 @@ static int idempotent_init_module(struct file *f, const char __user * uargs, int
 	if (!f || !(f->f_mode & FMODE_READ))
 		return -EBADF;
 
-	/* See if somebody else is doing the operation? */
-	if (idempotent(&idem, file_inode(f))) {
-		wait_for_completion(&idem.complete);
-		return idem.ret;
+	/* Are we the winners of the race and get to do this? */
+	if (!idempotent(&idem, file_inode(f))) {
+		int ret = init_module_from_file(f, uargs, flags);
+		return idempotent_complete(&idem, ret);
 	}
 
-	/* Otherwise, we'll do it and complete others */
-	return idempotent_complete(&idem,
-		init_module_from_file(f, uargs, flags));
+	/*
+	 * Somebody else won the race and is loading the module.
+	 *
+	 * We have to wait for it forever, since our 'idem' is
+	 * on the stack and the list entry stays there until
+	 * completed (but we could fix it under the idem_lock)
+	 *
+	 * It's also unclear what a real timeout might be,
+	 * but we could maybe at least make this killable
+	 * and remove the idem entry in that case?
+	 */
+	for (;;) {
+		if (wait_for_completion_timeout(&idem.complete, 10*HZ))
+			return idem.ret;
+		pr_warn_once("module '%pD' taking a long time to load", f);
+	}
 }
 
 SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
-- 
2.43.0



