Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C528249C4CC;
	Tue, 13 Oct 2026 11:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892255; cv=none; b=NwalTwbI9SLQoyPz4HDN3qpQ9LCgwNlpbWi61vnugJOd+pefhe/rOcKynWSETWFkzzx5rvkoe4de9csjvMuvkBoLQ8hI/UZwsZlsCEzx19KLdGaYgEwi9LVMvIcMXYv//zoLvUhLM+FyndMWEKwiFjhu4oaVfH5zNVCtKf+v4SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892255; c=relaxed/simple;
	bh=G0cyGKckN2WstRTQ0EZEzsW8xurMvavCUa+LScBKyVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWnoHtvhEycoGN0+++cICPKJzLTYMCdf2mh3x5YfXQdNRw4Hb9f0sRglotgJybhD9ZZztrqDtHuAPQYBx2NwRoS1ldnfgJc2pWRetLD7FoldBchRV0KC82woDf3blXbpDzwvloMVpHv9Eaau3lB3ABlHi8y4ANisERB1yJRiNA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mh50p2kB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mh50p2kB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2983A1F000FF;
	Tue, 13 Oct 2026 11:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892254;
	bh=0n/ku7I7SJV1L06UjAweM2WhsQGoo9ZvucgahEgIo3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mh50p2kBpzWVZ2i0H/xvu6CQs55JUrx9ZeK0fxRxoPJcife3EEYQAzelelPcQamdz
	 We5dg4IhbVY4OPz9Z4SK+9oHeOgYn/UbUwucCaTSNXNehE9kQpvzPaZj4jxo38iHQ6
	 x8Nv+tiCdgNQi5MtQ59QOZMOf6KTLAAE0BqE443w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Michael Neuling <mikey@neuling.org>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 111/281] riscv: lib: Fix ZBB strnlen wrap-around regression on huge counts
Date: Tue, 13 Oct 2026 13:37:07 +0200
Message-ID: <20261013112857.841260005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao Mingyin <shao.mingyin@zte.com.cn>

commit 282f4a8aa95c5a01b96e55eb5da297560e5f2986 upstream.

The aligned scan boundary is derived from the last valid byte,
(s + count - 1).  When count is huge (e.g. SIZE_MAX, which FORTIFY
strcat/strlcat pass when the destination size is not known at compile
time), s + count wraps around and the boundary lands before s, so the
ZBB path returns a bogus length.  The original implementation
(5ba15d419fab) had the same wrap-around in its (s + count) & ~7
boundary computation; after 5d588c684833 the wrapped boundary is caught
by the pre-loop guard "bgeu t0, t4, 2f", which then always exits for
aligned strings of 8 or more characters and strnlen() returns 8
instead of the real length.

This silently truncates strings built by fortified strcat: the dm
sysfs name attribute shows "live-bas" instead of "live-base", the
truncated name pollutes the udev database, and blivet/anaconda (as
well as LVM/dm-crypt/multipath userspace) break on RISC-V systems.

Detect the wrap-around and saturate the boundary to the top of the
address space, making the scan equivalent to strlen().  The saturation
clamps the increment to ~s, so it stays branchless and wrap-free:

	s + min(count - 1, ~s) == saturating_add(s, count - 1)

Normal counts are unaffected.

Fixes: 5ba15d419fab ("riscv: lib: add strnlen() implementation")
Cc: stable@vger.kernel.org
Suggested-by: David Laight <david.laight.linux@gmail.com>
Suggested-by: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Acked-by: Michael Neuling <mikey@neuling.org>
Tested-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Link: https://patch.msgid.link/20260915152656708z04s4oSYY2BGj34F36RZa@zte.com.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/lib/strnlen.S | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/lib/strnlen.S b/arch/riscv/lib/strnlen.S
index a8911605c248..5b3bbf0a3098 100644
--- a/arch/riscv/lib/strnlen.S
+++ b/arch/riscv/lib/strnlen.S
@@ -87,9 +87,25 @@ strnlen_zbb:
 	 * Aligned boundary.  Use the address of the last valid byte
 	 * (s + count - 1) to avoid loading a word past the count
 	 * boundary in the loop below.  count == 0 is handled above.
+	 *
+	 * Saturate the boundary when s + count would wrap around (very
+	 * large counts, e.g. SIZE_MAX passed by FORTIFY strcat/strlcat
+	 * with a destination whose size is unknown at compile time).
+	 * Without this, the wrapped boundary lands before s and the
+	 * pre-loop guard below always exits, returning a truncated
+	 * length.
+	 *
+	 * Clamping the increment to ~s (== SIZE_MAX - s) keeps the
+	 * computation branchless and wrap-free:
+	 *
+	 *     s + min(count - 1, ~s) == saturating_add(s, count - 1)
+	 *
+	 * Saturating makes the scan equivalent to strlen().
 	 */
-	add	t4, a0, a1
-	addi	t4, t4, -1
+	addi	t4, a1, -1	/* count - 1 */
+	not	t1, a0		/* SIZE_MAX - s */
+	minu	t4, t4, t1	/* clamp, so s + t4 can never wrap */
+	add	t4, a0, t4	/* saturated s + count - 1 */
 	andi	t4, t4, -SZREG
 
 	/* Get the first word.  */
-- 
2.56.0



