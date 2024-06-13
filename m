Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45D56EB56;
	Thu, 13 Jun 2024 12:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280617; cv=none; b=HXb7Dvm19hcrauATOuZr/ufJV9mVL2QC3O+DixEuAPxjd/VbpLODgaPotiJfnrT2OAvWQr3Lm3JAB88oQeUUqpXfZTaZFS9+Gk+ahOVi1A0jA2K6lcoQG9V3V1P70gtn+OMXEI72kSB7AUstixb8EkXN0Tj819svQch1BntGd40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280617; c=relaxed/simple;
	bh=FxCElrmZoq3RCxY86ps4Hu5mpbNn20q/SF9Gz1RCzsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCAGExEbgQS/EifECDMC1wlmL3emxpTAXzIe08HUxW9l8wX3O08AblpJBiUrr6TIZzP9I9OaGTCmTY4PWBmPXvnggB+xgAqutMs5hG66TgSnKROMRjmlzoxVc5+oGQhQuQw8aG5VgJYJhJPKKcxT80cmNSkXnxiRxEkyDhHwWx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siDCwNvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siDCwNvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA2AC2BBFC;
	Thu, 13 Jun 2024 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280617;
	bh=FxCElrmZoq3RCxY86ps4Hu5mpbNn20q/SF9Gz1RCzsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siDCwNvHpcdBEY/bjYtm/vdK2MlKyxbzVZrsW09dPTlK3RESSmuFDW8rtRfndmopX
	 7XsYSLOlivp2q9tJsqhooVep+0dudef00hy8uZMB6p6/iJVf+Ut8/Ryq3XAkW2waLc
	 AGgr5BjhYi0q2kR4lA50ngr0TU2Gq5agVICujQNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 115/137] parisc: Define sigset_t in parisc uapi header
Date: Thu, 13 Jun 2024 13:34:55 +0200
Message-ID: <20240613113227.759892242@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Helge Deller <deller@kernel.org>

commit 487fa28fa8b60417642ac58e8beda6e2509d18f9 upstream.

The util-linux debian package fails to build on parisc, because
sigset_t isn't defined in asm/signal.h when included from userspace.
Move the sigset_t type from internal header to the uapi header to fix the
build.

Link: https://buildd.debian.org/status/fetch.php?pkg=util-linux&arch=hppa&ver=2.40-7&stamp=1714163443&raw=0
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/signal.h      |   12 ------------
 arch/parisc/include/uapi/asm/signal.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 12 deletions(-)

--- a/arch/parisc/include/asm/signal.h
+++ b/arch/parisc/include/asm/signal.h
@@ -4,23 +4,11 @@
 
 #include <uapi/asm/signal.h>
 
-#define _NSIG		64
-/* bits-per-word, where word apparently means 'long' not 'int' */
-#define _NSIG_BPW	BITS_PER_LONG
-#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
-
 # ifndef __ASSEMBLY__
 
 /* Most things should be clean enough to redefine this at will, if care
    is taken to make libc match.  */
 
-typedef unsigned long old_sigset_t;		/* at least 32 bits */
-
-typedef struct {
-	/* next_signal() assumes this is a long - no choice */
-	unsigned long sig[_NSIG_WORDS];
-} sigset_t;
-
 #include <asm/sigcontext.h>
 
 #endif /* !__ASSEMBLY */
--- a/arch/parisc/include/uapi/asm/signal.h
+++ b/arch/parisc/include/uapi/asm/signal.h
@@ -57,10 +57,20 @@
 
 #include <asm-generic/signal-defs.h>
 
+#define _NSIG		64
+#define _NSIG_BPW	(sizeof(unsigned long) * 8)
+#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
+
 # ifndef __ASSEMBLY__
 
 #  include <linux/types.h>
 
+typedef unsigned long old_sigset_t;	/* at least 32 bits */
+
+typedef struct {
+	unsigned long sig[_NSIG_WORDS];
+} sigset_t;
+
 /* Avoid too many header ordering problems.  */
 struct siginfo;
 


