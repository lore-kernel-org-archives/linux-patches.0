Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749473019C7;
	Wed, 10 Dec 2025 07:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352146; cv=none; b=LRmaNwdQEesQxpJLiJMEmf+O8zybHfFf61WcVivstcmaqZehEZ9QXbrCWFqtRSIECS5fwtxiEba5+2WV9hu4G49iESCPhPBo7vph1jSDktkXFgxTT3W0/iuVDb00FSzFcaQHRqzu9fP2CnN/ah2hFsTBzt110BveZi+56Gq56Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352146; c=relaxed/simple;
	bh=KExl2soMVGC8VaTlhkAaPPeWCKCj0xDbznCHKCzxyYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGGbqxuriIXdycuaooCySjrhzeWa7tvtdINI5IghHoD5K8aMGfCURo2fPAt3n6hI0EoTl9/crzz3/BsOIk10LLlhQVA6J0+8lOVYpOeyoT8tC9xK7Vxg3bnprmlI2HqNHQlltSHEGVrrdFCzxwny9Kp0macw1MqVVi/xHyjq7vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwJuGGpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwJuGGpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B28C4CEF1;
	Wed, 10 Dec 2025 07:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352146;
	bh=KExl2soMVGC8VaTlhkAaPPeWCKCj0xDbznCHKCzxyYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwJuGGpfGbueVGnMa8Ifoid6l0e4el1Zbkl7BLvJ63qAc/OKrydxnWKIJYR4iDzZq
	 zGq/oLKu1y4zbEan1VLoHflE7MKw82ePwY1EchSTOAgL0Fkq4M+mpCau2LekcUy9zS
	 frZZ8hVZWpZsIjln6uRAg/X7PSkLyBA2KFLG7+jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 49/60] samples: work around glibc redefining some of our defines wrong
Date: Wed, 10 Dec 2025 16:30:19 +0900
Message-ID: <20251210072949.087523486@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit a48f822908982353c3256e35a089e9e7d0d61580 ]

Apparently as of version 2.42, glibc headers define AT_RENAME_NOREPLACE
and some of the other flags for renameat2() and friends in <stdio.h>.

Which would all be fine, except for inexplicable reasons glibc decided
to define them _differently_ from the kernel definitions, which then
makes some of our sample code that includes both kernel headers and user
space headers unhappy, because the compiler will (correctly) complain
about redefining things.

Now, mixing kernel headers and user space headers is always a somewhat
iffy proposition due to namespacing issues, but it's kind of inevitable
in our sample and selftest code.  And this is just glibc being stupid.

Those defines come from the kernel, glibc is exposing the kernel
interfaces, and glibc shouldn't make up some random new expressions for
these values.

It's not like glibc headers changed the actual result values, but they
arbitrarily just decided to use a different expression to describe those
values.  The kernel just does

    #define AT_RENAME_NOREPLACE  0x0001

while glibc does

    # define RENAME_NOREPLACE (1 << 0)
    # define AT_RENAME_NOREPLACE RENAME_NOREPLACE

instead.  Same value in the end, but very different macro definition.

For absolutely no reason.

This has since been fixed in the glibc development tree, so eventually
we'll end up with the canonical expressions and no clashes.  But in the
meantime the broken headers are in the glibc-2.42 release and have made
it out into distributions.

Do a minimal work-around to make the samples build cleanly by just
undefining the affected macros in between the user space header include
and the kernel header includes.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/vfs/test-statx.c         | 6 ++++++
 samples/watch_queue/watch_test.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/samples/vfs/test-statx.c b/samples/vfs/test-statx.c
index 49c7a46cee073..424a6fa15723c 100644
--- a/samples/vfs/test-statx.c
+++ b/samples/vfs/test-statx.c
@@ -19,6 +19,12 @@
 #include <time.h>
 #include <sys/syscall.h>
 #include <sys/types.h>
+
+// Work around glibc header silliness
+#undef AT_RENAME_NOREPLACE
+#undef AT_RENAME_EXCHANGE
+#undef AT_RENAME_WHITEOUT
+
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #define statx foo
diff --git a/samples/watch_queue/watch_test.c b/samples/watch_queue/watch_test.c
index 8c6cb57d5cfc5..24cf7d7a19725 100644
--- a/samples/watch_queue/watch_test.c
+++ b/samples/watch_queue/watch_test.c
@@ -16,6 +16,12 @@
 #include <errno.h>
 #include <sys/ioctl.h>
 #include <limits.h>
+
+// Work around glibc header silliness
+#undef AT_RENAME_NOREPLACE
+#undef AT_RENAME_EXCHANGE
+#undef AT_RENAME_WHITEOUT
+
 #include <linux/watch_queue.h>
 #include <linux/unistd.h>
 #include <linux/keyctl.h>
-- 
2.51.0



