Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB7A43D4E2;
	Thu, 30 Jul 2026 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423400; cv=none; b=QCRGL8i5qHNMI58p5M1HUQQx2fQGUGjvgBvPLoaK7h2FVAKHKr4BA3UBwbwDsGR8Nwmwh2i+IINfOQYAI4AlARUTaCu1FXC5/pZYD7d5CxRhqlBYSoyN1IsZHLiy3u+Ndk1s5aJx2H29sFhl77cMZKwPDseSGlzBJqLAmH5pTFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423400; c=relaxed/simple;
	bh=qY5HP49qiO7DtDAJ7eSVeo7nH6pwWN7NMFM/nBcuSn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSeVkSvUW12AbMc+P9b8H+V6kOKJ9Mt0WipDTwMPmNQd1ufayohnrxbtn6p+VXjHygiyHURyEeYMAOdrHsHDm8S3D8UH8XtVzAxju7pUnZjBjx9wx9/EI3V8WLY3qP3kPDcoq3g1mSXWtSRJXhtrslX0ErODdC0Y+Z0DKS2Pmg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJaG0Bu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJaG0Bu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA581F000E9;
	Thu, 30 Jul 2026 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423398;
	bh=pJCG0ANCdTHvVUd9TiXH7XdvU18mjqBiYSvxlUxYQgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJaG0Bu7+3zp5T6qqoKHMGrl4oMjY/rhARRneKqBIOo++D+GVBvAQz3MgHEkPaSJX
	 460C+D5ULgzyJpK3Ac48IAgNVW5o26WZqBql+06NRPzn+lKTZTQUYBPIBhKbVj6V4b
	 FX52hLb+bTW7Pe1Oo+1vAS/qyRlylsu5q5r/rl0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 010/675] seqlock: Allow KASAN to fail optimizing
Date: Thu, 30 Jul 2026 16:05:40 +0200
Message-ID: <20260730141445.336664358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit b94d45b6bbb42571ec225d3be0e7457c8765a5b4 upstream.

Some KASAN builds are failing to properly optimize this code --
luckily we don't care about core quality for KASAN builds, so just
exclude it.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Closes: https://lore.kernel.org/oe-kbuild-all/202510251641.idrNXhv5-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/seqlock.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1234,11 +1234,14 @@ static __always_inline void __scoped_seq
 
 extern void __scoped_seqlock_invalid_target(void);
 
-#if defined(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 90000
+#if (defined(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 90000) || defined(CONFIG_KASAN)
 /*
  * For some reason some GCC-8 architectures (nios2, alpha) have trouble
  * determining that the ss_done state is impossible in __scoped_seqlock_next()
  * below.
+ *
+ * Similarly KASAN is known to confuse compilers enough to break this. But we
+ * don't care about code quality for KASAN builds anyway.
  */
 static inline void __scoped_seqlock_bug(void) { }
 #else


