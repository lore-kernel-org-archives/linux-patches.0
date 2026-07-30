Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3422446065;
	Thu, 30 Jul 2026 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423397; cv=none; b=c0W5lnlbYH5MnGNtNXljcB/JUrrH4Kl7VPn5MIoxG+FHXahxUHkJElZSRc97U4MZcZSaT7ItdQNcx6wvVbio6cI9p/AvKBkw8BaZtHLdQJ0bWnccqUfkKc0TJO+qzgBX2s+iMNadp/MXKIy6zwrodUSWMo6M910bsTG5cLJl91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423397; c=relaxed/simple;
	bh=RwLoZ4V5xPW44Siq0SXw/mSNu0JWbDJay7eHc9ZK+7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeR/wRaWEjsThR+eHtBIi/4N1gS6Mlnt7Mk+NI/H2M2JRjSOQLDSobD+nAiHm4lnuw7bZ4uvJkgazvnwKYRCCEoBDHQYffVoaJJQmLvGxzyqLMfrsi6ZPB+LkJ5S/r+Rnjp5xZ02SQK1prVzP53KUNtKgGQ4EIQTUIWNtuHPL8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqfBytn+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqfBytn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7B31F000E9;
	Thu, 30 Jul 2026 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423395;
	bh=mlbUzL599d/84bNkRaVncvlrm5wT0UhIZH7nSIveGIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqfBytn+JLXstW7etezqVooN+0QHurgmxQKGkex6iHcxZMQGMjqdCvp2EiW7VgAC1
	 jn+tJ+9AQbeDWxxsy7Kn4l2/cykixkodhuS3lAyzLMjZUqz6ujXd+BZ4UWov3I55uo
	 dso8OA+P8++RtRAz+/IA61mYzJWYOPIXhYjhlU9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6.18 009/675] seqlock: Cure some more scoped_seqlock() optimization fails
Date: Thu, 30 Jul 2026 16:05:39 +0200
Message-ID: <20260730141445.314855836@linuxfoundation.org>
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

commit 90dfeef1cd38dff19f8b3a752d13bfd79f0f7694 upstream.

Arnd reported an x86 randconfig using gcc-15 tripped over
__scoped_seqlock_bug(). Turns out GCC chose not to inline the
scoped_seqlock helper functions and as such was not able to optimize
properly.

[ mingo: Clang fails the build too in some circumstances. ]

Reported-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20251204104332.GG2528459@noisy.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/seqlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1224,7 +1224,7 @@ struct ss_tmp {
 	spinlock_t	*lock_irqsave;
 };
 
-static inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
+static __always_inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
 {
 	if (sst->lock)
 		spin_unlock(sst->lock);
@@ -1249,7 +1249,7 @@ static inline void __scoped_seqlock_bug(
 extern void __scoped_seqlock_bug(void);
 #endif
 
-static inline void
+static __always_inline void
 __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
 {
 	switch (sst->state) {


