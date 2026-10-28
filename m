Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211143;
	b=se1Pa9bUzkhdetCUskZDx+PjqPd8YJhb72YXZozxofsVZ8xndWlwff+NY9pldwdWufUI
	 EMx9WfiWHUPCK4v0Y+C59cco4v6Fr7yiE2mbtaJCdCye1lrakbPS0iYayMkSu7SUyBicy
	 5SN1vxRVqAFQ1NJp608h/hFlqAgVuoCqTkG6ZdQnA7THgucW3+tpeM+mRz0ylKrrhZ1we
	 W4uhl5CLhAScxvwe6f4+n3IrVjCLFxtER4cy340YUGbPKBGzcvJvBlW7YBNiu5DWhPeY6
	 fu8eLuVZ3lz25YAMEvaDzMx1qil8kbZ1hppHJVkVugb0+EoD9JxjUiMEOl5vWZWSQXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wSyU7QnhuqpVOuG/Fsxw8FKU5a0wE/lu7mflwcqIMwc=;
	b=TcLLPiYTlenjV5/1GAlO56AyslLUaAVgWlGwBMQ27MHGpUoQ4xrtGxF1mGbCz7dorCfG
	 2nYd1dIucDpRiL/AceTXXlk9VXHfXHjmVAENs/8XvRhQfycq0jRuQOBzS7aZDtQxx41xM
	 yS24CJ+5N22k7d7dkcZuQmSJPhHJ8QYWzB44mIdaugV596ANFvZUdppecOzCphb6egJ7y
	 zVq9wjJRVRSku81PRNM6KB3dbe+f6tWf9Oo/EjxU78AioIbq3e7t5C258Oe979aPely/P
	 Ruw6jGmWoPebjumBk474HZ3mI3usESP3JUQXenobYp1NCseIMXVt6JOj8U5dzfnaCww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIhVZn6a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3544C606A972;
	Wed, 28 Oct 2026 18:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIhVZn6a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A911F01825;
	Wed, 28 Oct 2026 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211143;
	bh=wSyU7QnhuqpVOuG/Fsxw8FKU5a0wE/lu7mflwcqIMwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIhVZn6aYgivUiVD45HNitPVfYY02jnuzUceQgf8zAyddkrMuvXGKASD9t44o0m/U
	 qWUwC13S5+yH0n/XOYVFSe6Ladt3wafXRAFJgTzrVsKIWkfM3F5eITNeYSeWYx4Fvk
	 c1hQWeNzB/pBuBOgzDkojAxMZs0m7+HHD5AxW420=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/571] kprobes: Skip disarmed probes when checking optkprobe overlap
Date: Wed, 28 Oct 2026 17:56:17 +0100
Message-ID: <20261028170013.461509228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 7a39c732a22ec4a369af9e19fbe3d666ec83eec4 ]

On x86, an optkprobe at A replaces five bytes with a jump. If a disabled
probe B is at A+2, get_optimized_kprobe() stops at B when arming a new
probe C at A+4. It leaves A optimized:

              A    A+1  A+2  A+3  A+4
  A's jump  | e9 | d0 | d1 | d2 | d3 |
  after C   | e9 | d0 | d1 | d2 | cc |

The INT3 for C overwrites the last byte of A's jump displacement, so
execution can jump to the wrong address. B can have prepared optinsns
while disarmed, but has no jump to unoptimize.

Continue past disarmed and unprepared probes to find the active optimized
probe before arming a probe in its jump.

Link: https://lore.kernel.org/all/20260930053618.104498-1-leon.hwang@linux.dev/

Fixes: afd66255b9a4 ("kprobes: Introduce kprobes jump optimization")
Cc: stable@vger.kernel.org
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
[ sashal: Adapted get_optimized_kprobe() to use unsigned long addresses with byte-wise scanning. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 69d166f42d04a..f2bcfae09fd9d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -485,14 +485,16 @@ static int kprobe_queued(struct kprobe *p)
 static struct kprobe *get_optimized_kprobe(unsigned long addr)
 {
 	int i;
-	struct kprobe *p = NULL;
+	struct kprobe *p;
 	struct optimized_kprobe *op;
 
 	/* Don't check i == 0, since that is a breakpoint case. */
-	for (i = 1; !p && i < MAX_OPTIMIZED_LENGTH; i++)
+	for (i = 1; i < MAX_OPTIMIZED_LENGTH; i++) {
 		p = get_kprobe((void *)(addr - i));
+		/* A disabled probe can have prepared, but inactive, optinsns. */
+		if (!p || !kprobe_optready(p) || kprobe_disarmed(p))
+			continue;
 
-	if (p && kprobe_optready(p)) {
 		op = container_of(p, struct optimized_kprobe, kp);
 		if (arch_within_optimized_kprobe(op, addr))
 			return p;
-- 
2.53.0



