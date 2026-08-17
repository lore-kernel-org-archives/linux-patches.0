Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AF9282F29;
	Mon, 17 Aug 2026 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978859; cv=none; b=fUKjcObVWhhTeheyv5qMQG9/EOJa/fbDHQjmTNn/bC+8AmX3wQzDxcankWKizZjLKG28qBo+08ig6bVSIN6mhgvlnzezBVKw6RrHUDxPRVk19Jfwt4RhKigi7wTEfqkzc3aufbAkgsn/pzG+50prbhe6E00xq5IC0MzTDKiVUfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978859; c=relaxed/simple;
	bh=Yi+etOaYpv6+LSTqsexEam/GmkzOTezir87C5NMxVUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iD+HoSit7+JZI1Y6cRFbrUqk7N/0/jpoGka9kbO61y0BVeQK2F7QrrhR0HS+zH9S6oCMkm3i9C09NpXHTLSjsJdu1sQNJL0qEe6G1fwnuoCZAKpVdleHATd+/jCY3qzcoI2arKKBt3KO/Qz8IjnDQKIv423EkGlQg/01mTu4XsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyp5vvH8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyp5vvH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DB41F000E9;
	Mon, 17 Aug 2026 15:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978858;
	bh=89DOQYRqj7fa3cYF2WKq1WwtQM62IR6+zI0Ih1KyCXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyp5vvH8btz0OnxtJj60HQ+OlRm7+2/0bNP47ZF3/UOf8Pj1+ZjVbg1En0j8s1YGq
	 Wc26fjKOtNRQ4Gwx2nEqh3nY8rD/wbLVZ+xh40J2/pCrWgyJKjmoH2tkcAg4RIGEP+
	 9I8KsCfKV2N/JSkTFsQ6eEv9wmLwUZS10NHVUDj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 006/609] seqlock: Allow UBSAN_ALIGNMENT to fail optimizing
Date: Mon, 17 Aug 2026 15:25:02 +0200
Message-ID: <20260817132543.347957458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


