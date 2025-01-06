Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E1B14900B;
	Mon,  6 Jan 2025 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176908; cv=none; b=pHqHdXkejDyy5Q7lu88KVCbiGvz325T3SdYKWAPb27bL3AlTqOproqKBp14wz37ADyIZupfL4kg8VSvRf7j5fP+tR+NALUoBSPQRhV+3Nfm5zOmOX7Dr/kpaKtVZZ0Liis+g6YkkqIs7QRWt6T3kqYK250FuWRlniyfrRCjUGt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176908; c=relaxed/simple;
	bh=OPpt48QnJNAFASUL122AL3UBvkkjFQBlQT/sYymk9Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJFRNIU3q0nc7E9A+aziMO8EJzT/6C4ZHoQwThaXBSoXxFs1NWIyNA0mJ5mXdf5UnvH3EYej6n9oislwEvZMQ5hHUPWRIH+NKDMbotTdF27NioNJW88mI6no30lnbttN6tjOEoCW34BPtqN+h5Hr7nm+qN8hYqwyESOP4VCz5kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpdimR/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpdimR/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6821C4CED2;
	Mon,  6 Jan 2025 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176908;
	bh=OPpt48QnJNAFASUL122AL3UBvkkjFQBlQT/sYymk9Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpdimR/p+Q3mXbScBGg+lZ0RIzodumTQ6EdMoZA5ZGVclvhX4Omu/HE8RSRQNRT9D
	 GbBmUXAcOfeOSveQH769fG1YqNqh4fWOkLXnBV2Ecwg2hPHnlFpFETQsA0GyT6BThb
	 P1C5yo17oyQtzimF2gAcVZmTj/CMTf/7hcKp0fJ8=
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
Subject: [PATCH 6.1 70/81] kcov: mark in_softirq_really() as __always_inline
Date: Mon,  6 Jan 2025 16:16:42 +0100
Message-ID: <20250106151132.072897008@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


