Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A21282F29;
	Mon, 17 Aug 2026 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978857; cv=none; b=VTgGWP4IIMislQqyZlULjBUe32NHslkLRk2vM2buenlpOoap8waZq4wilB1e9BG2uQFO5IZfu7rgOk00wTjE1sivjkZQfbciGx11Pq0dePEF+J0c0vU+n8iTt7Gfi+R6ZDIr9xtjhIOWGP9e3GmXhRoGzu9EkjOK4pIxpjOKYTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978857; c=relaxed/simple;
	bh=c1MWoGcqll9p/UM70j402+l+e1DprC/+0IQO1DVTD7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJnkv8obN9geoVmwmlryUwdnvjKwchSyPFihXJ0Y9MUhG75kE6xwCkmhyB3R2o1F2b1st1VJQ5IOGYSYVTW6q38qIJNbE8PbX8iiP/GhjM/3nCqJVF21CUci9qM1gYS5+MmjxQEVrAcrC6P72kV2Jr2rUBpr4hIaF2xHMMvBqJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOrEori5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOrEori5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6D01F000E9;
	Mon, 17 Aug 2026 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978855;
	bh=5x4FayLftZH7Z67lWiGU7tqSC3VCphQFaCqsdsJuu3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOrEori5HRvUuG1c4iffNTY8HEBqtnb2iSv7mkb5fGX/fjK1I9Lm6EH+Ylllo5B3Z
	 6TAXcP+eLt2GPKrwqB+0FRHsMs6TWcfoVnC7fGK3u93tltJj7rqX4phBnHJ13wTJTN
	 w0uUy7rL5/iNcRok/P7tLWhFEDpUcSiKkoul27qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 005/609] seqlock: Allow KASAN to fail optimizing
Date: Mon, 17 Aug 2026 15:25:01 +0200
Message-ID: <20260817132543.304856999@linuxfoundation.org>
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


