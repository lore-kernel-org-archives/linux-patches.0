Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87553B38B8;
	Thu, 30 Jul 2026 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427060; cv=none; b=ug0N7AWxkWhVyWDaJQ/cgNyR6EcS1NbDehRaJVMu+YpvkHoCkHjXAcyH+Z+NS7EyhPqDeqn5cQhMrM6mw/jeQ0iexJ1tns+KWwlGzxVEp10j3aCkGgWt9R4WRP/3oP5Xp3jf8bS6j8jMG9XEYUxtgFa+ei38GGtVAC6RYggBnc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427060; c=relaxed/simple;
	bh=wKstPeIK85fkaZq9jVBklujMvVscpT8Xm9OEAHV8Keo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAvy5bR7UfaosANucR2Fj7EtEIUA3v4WOeYC5bYziV5E/cFfwVkxGVmBrACSLwIisTUZlbwY6uwknME5QR+3njVcUpMh8wzuQsu3y4kVJL8tifiw5s+SY/U/bqcyvFM3l5gs+5jZTpNTRJsKbyHLUMKMnldzQpThjooX0fs1PeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9p78/QI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9p78/QI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050991F000E9;
	Thu, 30 Jul 2026 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427058;
	bh=+DzmcZ4FjIlSEE9BSjGxDZBUBTjJwmUh83KKU4jDXx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9p78/QIntZ5nLZfFzi5jSCz+zwqJvmGdEbbo+OI4XSzK2OGHaPuyyP587tC900mD
	 6xLhPVpKAXNb1RYzLYRMoONUUPaPnxlk0qmSAISh+iIqax8jfy6peNw5NmUq4qvkIT
	 erH8SifF3O1hOTIq66c2ZYk15MX9cO+D2afXWqjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 008/484] seqlock: Allow KASAN to fail optimizing
Date: Thu, 30 Jul 2026 16:08:25 +0200
Message-ID: <20260730141423.586609651@linuxfoundation.org>
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
@@ -1291,11 +1291,14 @@ static __always_inline void __scoped_seq
 
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


