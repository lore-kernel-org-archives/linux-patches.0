Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B560330BBB3;
	Wed, 17 Sep 2025 12:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113758; cv=none; b=IC7g9t2z4aKHxFBWWqbbsmsq3ufu3oKjRbK+Jrn+dWuVviTQeQb21f5R1Rjk+wWBdt5qNYwHXim/6Xm7RgV4KD3zw2nuByzYq7O02yhwJCDuZ20wm7zaDNAy94on+f0gqTmXkL0uYDzIGkxaneNDLxEZqdqO7Su1EWd88uArYqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113758; c=relaxed/simple;
	bh=Jp0/tySd52t0LMGRuSmy/aSs5FLggJYCyNTV8QA6Mwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuVNkkdqEc6I/cPmznppd8eyebM+jJEWufkCHUrwQs0xT91vM9Qn5gMCVEz70PsAUi/Jh+ydZ3WYdPNaugS1x1aiAWcBuKtDSwvpoPli7thT47LOKCFDcpIJGfpllQo1cNvbYfjj9hzkI/U8fTU0OYH8AqLVGSjpJUOX27Ej3FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEMPtpYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEMPtpYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D93C4CEF5;
	Wed, 17 Sep 2025 12:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113757;
	bh=Jp0/tySd52t0LMGRuSmy/aSs5FLggJYCyNTV8QA6Mwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEMPtpYi28/XlpDV80b4SVwXh0KzAaJ5OIvQb8SJmkUwjyNQUvEZMYq+t7cvwXe/l
	 v1fGMnVox33Z26eX0Zv2rrk9sTmHQZpUiJ12ce75EWeoGsRmV5nB4yhJJIB1H9Ctkp
	 48l4je6xMFr6DTxRYqPt8uWuftPn4iKs+kH1VhOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 043/101] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Wed, 17 Sep 2025 14:34:26 +0200
Message-ID: <20250917123337.886844033@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

From: Sang-Heon Jeon <ekffu200098@gmail.com>

commit ce652aac9c90a96c6536681d17518efb1f660fb8 upstream.

Kernel initializes the "jiffies" timer as 5 minutes below zero, as shown
in include/linux/jiffies.h

 /*
 * Have the 32 bit jiffies value wrap 5 minutes after boot
 * so jiffies wrap bugs show up earlier.
 */
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

And jiffies comparison help functions cast unsigned value to signed to
cover wraparound

 #define time_after_eq(a,b) \
  (typecheck(unsigned long, a) && \
  typecheck(unsigned long, b) && \
  ((long)((a) - (b)) >= 0))

When quota->charged_from is initialized to 0, time_after_eq() can
incorrectly return FALSE even after reset_interval has elapsed.  This
occurs when (jiffies - reset_interval) produces a value with MSB=1, which
is interpreted as negative in signed arithmetic.

This issue primarily affects 32-bit systems because: On 64-bit systems:
MSB=1 values occur after ~292 million years from boot (assuming HZ=1000),
almost impossible.

On 32-bit systems: MSB=1 values occur during the first 5 minutes after
boot, and the second half of every jiffies wraparound cycle, starting from
day 25 (assuming HZ=1000)

When above unexpected FALSE return from time_after_eq() occurs, the
charging window will not reset.  The user impact depends on esz value at
that time.

If esz is 0, scheme ignores configured quotas and runs without any limits.

If esz is not 0, scheme stops working once the quota is exhausted.  It
remains until the charging window finally resets.

So, change quota->charged_from to jiffies at damos_adjust_quota() when it
is considered as the first charge window.  By this change, we can avoid
unexpected FALSE return from time_after_eq()

Link: https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control") # 5.16
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1043,6 +1043,10 @@ static void damos_adjust_quota(struct da
 	if (!quota->ms && !quota->sz)
 		return;
 
+	/* First charge window */
+	if (!quota->total_charged_sz && !quota->charged_from)
+		quota->charged_from = jiffies;
+
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {


