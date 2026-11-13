Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590582;
	b=2ZKg6NeDKxTs3CsOChtmuNnu61dMtqB6GMPzJFTpTUUcJarNsAVYOTvNAMq7YdNxyExB
	 r/iAjCe2VBNNRUlFzk/9jMf92YQlJA3aZC04nDEtVJfgG6KOh494wwCZrSasaRuQEEg2z
	 Pa/BKzFmzGD/VJOG4Li7hjK4tWicgjwvJeKh54oojInppby/NTXVCsV6oaNHRWhvtOulc
	 uSq8mGc5nKZAgb/EpEj7jYNsnPcdEQ5JVhE2BA9fK3cYiAasjJLeE0tyIeKmkdHiWw8UO
	 9wsJIb3tLu9nGqGRDENkS8DeBEubN09egFQ8SirnwbuimnuNHRy6vBJD3tvrKRjX8KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kkjnJfRM5ablRvWEzriu5bCopK1W4qO5GQWtzHpsXuU=;
	b=LZsL5Tke24ArE4MFoV9bCeXUiWw1IOi9zTvOcfmxA8WNfDQU8Fu3VSOg+cnXkNxYN4bS
	 HK9WmwlRkyuldnGH/haI+P7HL1URie/dJZQtophyoHW3uNUm8Ju4TTMkhrkknMC/Urgq6
	 pl0nqDVG1tAoHqWre18oWO9Fs/id/V/PlSfj+CN6DJtzwO4b4SLqRKA8ZGGPn7bv6DLxw
	 5DOBO9iVFWZUqCSAfQ2wIekFhzV9RJ1Y2ctcNmJQNKhnDj9ot0RvykdZH+UBp7R7mQHDd
	 TqjY1ETJaEGSgzu+0z35C6vJESt6q/k5YZCCaRJADxODeDDiXdB2352bX5t2Bd+lAgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5bl5es9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53117606C081;
	Fri, 13 Nov 2026 17:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5bl5es9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04CA1F000C9;
	Fri, 13 Nov 2026 17:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590581;
	bh=kkjnJfRM5ablRvWEzriu5bCopK1W4qO5GQWtzHpsXuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5bl5es9tKPa9CIDPMyJnlmTzIWlKyDCRc3c1XpbR92Dah6Cww5D0GDwYXHPa5nBF
	 QJ5VCxzH+ElWcx3kwz+yPk8Jab2miLX9TQG2XvV8xpO/5OLy+5AesI2oa/RPYUi4Nb
	 i35kHJRg3OMfMfNZ7pp7ODW17Ir2C8tomchKzak8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 454/686] x86/nmi: Ignore negative NMI handler durations
Date: Fri, 13 Nov 2026 10:49:47 -0500
Message-ID: <20261113153836.256759786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ade63af6cfb7b3ca19ced28730fd6461e8d1d410 ]

I am seeing NMI handlers in the Meta fleet reported as running for
about 584 years. Over 30 days, 11 AMD and Intel machines logged 637
such lines, for example:

  AMD EPYC 9D25 (family 0x1a, model 0x11, stepping 0x0):
  [ 1650.616627] INFO: NMI handler (nmi_cpu_backtrace_handler.llvm.9643156322683129580) took too long to run: 18446744073709.551 msecs

  Intel Xeon Platinum 8321HC (family 0x6, model 0x55, stepping 0xb):
  [360448.230129] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 18446744071018.936 msecs

  Intel Xeon D-2191A (family 0x6, model 0x55, stepping 0x4):
  [81787.188959] INFO: NMI handler (ghes_notify_nmi) took too long to run: 18446744073709.545 msecs

nmi_handle() times each handler with two sched_clock() reads. When the
second read is lower than the first, the u64 subtraction wraps, and
nmi_check_duration() treats the result as a duration. In the three
examples, the clock went back by less than 1 us, by 2.7 s and by about
6 us.

The wrapped value is also stored in action->max_duration. Every later
real duration is smaller, so the handler is never reported again until
the next boot.

Whatever makes the clock read lower, a negative difference is not a
duration, so return before it is stored or reported. A clock that steps
forward is not covered, since that cannot be told from a real stall.

A backwards clock is still worth knowing about, so print the size of
the step once per boot. This uses pr_warn_once() rather than WARN, as a
stack trace says nothing about the clock and panic_on_warn machines
should not go down for it.

Fixes: 2ab00456ea8a ("x86: Warn when NMI handlers take large amounts of time")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261027-nmi_negative-v1-1-b436a005eb8a@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/nmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index be93ec7255bfc..eece49c490e07 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -114,6 +114,14 @@ static void nmi_check_duration(struct nmiaction *action, u64 duration)
 {
 	int remainder_ns, decimal_msecs;
 
+	/* sched_clock() went backwards? */
+	if ((s64)duration < 0) {
+		pr_warn_once("NMI handler (%ps): sched_clock() went backwards by %lld ns on CPU%d\n",
+			     action->handler, -(s64)duration,
+			     smp_processor_id());
+		return;
+	}
+
 	if (duration < nmi_longest_ns || duration < action->max_duration)
 		return;
 
-- 
2.53.0



