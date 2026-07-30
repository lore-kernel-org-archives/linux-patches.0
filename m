Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781364446FA;
	Thu, 30 Jul 2026 15:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427062; cv=none; b=HGf2vpWBhwdB3TPs2Q0zIPErJ5SuJSNUpe2WLfhXq0JZkZdyzjtGYXAokSA7rBm3zszoPmYkHIZ4AqTwExOjMI+ppXO8n+w+UJfGYQDGpXAdhtoP0HhxFmFYx4iba5/DbwcIXPXqIOICTtLbZqf3gVbqGd9tbjWQbAFtkLV6/bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427062; c=relaxed/simple;
	bh=Ew9ZJnLhxvivkmxINfnyYL+s+bj5DtCYJJEEGRBctRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCEcegwtAlXPKXViJl8mA2wCdTKdIo3hK6yB84JZeTFoyVQpr5dGmkLsfXbOQWTdsOeZHKkeq1OYmHv2TkRDJLZGqROZD89gL91vYYm0zyNyVX97W9rRaQbErRZ7I4OMRKise8YgFDGtN01dLjZSTGqPvuxoh9fNPPoWwSrwX0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4K+mZjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4K+mZjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36281F000E9;
	Thu, 30 Jul 2026 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427061;
	bh=PiS1QEnRVIUcIMb9c0Rty40rBqGvtH66rCoUs35s+eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4K+mZjlYtnm1jkd8YprFJxtN+X0c+XlC4CILxTBmoKIweNQk6/p3gTL1DK7X45oj
	 mXLOuUeEukyvK+xFPL2TPf6AWQ/BP9bjxSDHTm5Oc1Z5oGll4jNHkAuvmA4v/81i3N
	 YHDcIJ/9IpyFLzP1SKZeGbGYv156SZXhyTojfS0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 009/484] seqlock: Allow UBSAN_ALIGNMENT to fail optimizing
Date: Thu, 30 Jul 2026 16:08:26 +0200
Message-ID: <20260730141423.608915680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 88331c4ec23a28c1006ec532fa64763d4c695e90 upstream.

With gcc-15 and gcc-16 with UBSAN_ALIGNMENT enabled the compiler fails to
inline and optimize __scoped_seqlock_bug() away on s390:

s390x-16.1.0-ld: kernel/sched/build_policy.o: in function `__scoped_seqlock_next':
/.../seqlock.h:1286:(.text+0x22030): undefined reference to `__scoped_seqlock_bug'

Fix this by adding UBSAN_ALIGNMENT to the list of config options where a
not inlined empty __scoped_seqlock_bug() is allowed.

Closes: https://lore.kernel.org/r/20260515092057.810542-1-arnd@kernel.org/
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260519110315.1385307-1-hca@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/seqlock.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1291,14 +1291,15 @@ static __always_inline void __scoped_seq
 
 extern void __scoped_seqlock_invalid_target(void);
 
-#if (defined(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 90000) || defined(CONFIG_KASAN)
+#if (defined(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 90000) || \
+	defined(CONFIG_KASAN) || defined(CONFIG_UBSAN_ALIGNMENT)
 /*
  * For some reason some GCC-8 architectures (nios2, alpha) have trouble
  * determining that the ss_done state is impossible in __scoped_seqlock_next()
  * below.
  *
- * Similarly KASAN is known to confuse compilers enough to break this. But we
- * don't care about code quality for KASAN builds anyway.
+ * Similarly KASAN and UBSAN_ALIGNMENT are known to confuse compilers enough
+ * to break this. But we don't care about code quality for such builds anyway.
  */
 static inline void __scoped_seqlock_bug(void) { }
 #else


