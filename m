Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1A41D86F1;
	Mon,  6 Jan 2025 15:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177557; cv=none; b=EJ+gpPyJ6PIhSMYPRKiBFMXmvJw5/Q0Q7UiAxuJpqDKliOt0ufjMfTKX9k3+fGyJjrlV2A9NuavXVrhgpg5dJTGXiu//ueFuo5Nb+20QkK/mTZBoaBnOcrHSslqXMfiErmnLvz5T579WhGrsMHeAXGJUwx+9KImDXUG/J+TUd5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177557; c=relaxed/simple;
	bh=ELo5rd5fPRUf9o/SwScdwtOPggdyRAqZlHABHpBbJcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEbyQA599PNiSiUqIkBR0c59ER6cRyPsRQJOuybcvCl1YYIYKb73qUtO66iCOr5jIimHMu8RNhWVURG42UTAMNvCLXzH/UcFoc2GlxzFFrSE1ONXofq49DzfzZSdOkPsTzIYYArKKoA+7yFLskHu9bL8GP/Xkldgy9y1V1HgwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdfMOWSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdfMOWSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE437C4CED6;
	Mon,  6 Jan 2025 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177557;
	bh=ELo5rd5fPRUf9o/SwScdwtOPggdyRAqZlHABHpBbJcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdfMOWSBCp+bFiOjpe0m66j7Sm2zhve7QQ1VV9brpT+Kf2KMq0oH4+rnbdb1vMttP
	 /8DFpxCujBUE7CdL3BO3YK1tpAhM56Bspmk/Hg+P4J3vFdhlqv1atb+MmezR1e+V1E
	 WJVDE8614+wNdafideZz/BfKJa+7y+bIkPziEEL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marco Elver <elver@google.com>,
	Aleksandr Nogikh <nogikh@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 203/222] kcov: mark in_softirq_really() as __always_inline
Date: Mon,  6 Jan 2025 16:16:47 +0100
Message-ID: <20250106151158.446580657@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Arnd Bergmann <arnd@arndb.de>

commit cb0ca08b326aa03f87fe94bb91872ce8d2ef1ed8 upstream.

If gcc decides not to inline in_softirq_really(), objtool warns about a
function call with UACCESS enabled:

kernel/kcov.o: warning: objtool: __sanitizer_cov_trace_pc+0x1e: call to in_softirq_really() with UACCESS enabled
kernel/kcov.o: warning: objtool: check_kcov_mode+0x11: call to in_softirq_really() with UACCESS enabled

Mark this as __always_inline to avoid the problem.

Link: https://lkml.kernel.org/r/20241217071814.2261620-1-arnd@kernel.org
Fixes: 7d4df2dad312 ("kcov: properly check for softirq context")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -165,7 +165,7 @@ static void kcov_remote_area_put(struct
  * Unlike in_serving_softirq(), this function returns false when called during
  * a hardirq or an NMI that happened in the softirq context.
  */
-static inline bool in_softirq_really(void)
+static __always_inline bool in_softirq_really(void)
 {
 	return in_serving_softirq() && !in_hardirq() && !in_nmi();
 }


