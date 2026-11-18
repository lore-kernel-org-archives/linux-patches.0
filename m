Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061479;
	b=sQWDnwUkG9BQBwe+WIs5TxYAPiF1zcF1KMe/nDLHAe9td7ObhMi9ag+NGhfoUe/pppJe
	 a3W1SdfWNL7cXkzyiLjpjRayUZQMcDrt8UwBbNRW5qKkIiqTqSUt4py1XRczujwx1KlQw
	 K2CtHcYXalgUO6sIaUtMiRH6NMC5TQLDrNAt0d9DTMW2Pm4PP6r1WTMXn4HCp99bzCaOV
	 JlOop4TInG2LW3xI90qXHfqv7ewcEENPpH4kC3yj9ZC3JQHfFSpu3pbtjxR6GApFCPra6
	 Qvjed4QMMlQrtWXuN3tXmbtbg8i8q2zcLyv9PagrkcogABH2v0tW8Ev8wFMTPYOY/MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=57+ca2qjI0mQUVE11l7+dD0tq8NgIfYfszQIuUbSvYU=;
	b=orh2rKr2c7h0LAHHLx9OfR/fsXLf6MMDXuUGV3XhQpJY4jkSfdPAfrvjKSqu0Uq5PaMH
	 58EmfRpqu+gFCqNE7qTyH6QiTk9rw0EzJ1KS9LUcRj54wZgxrTH2yqz3tXbPbBkZhpxGI
	 xTNv85w0LQEI99naBsSqWORHe1rc07RADOQM5z5uFhpccUB1K6v5oaWTWmVX/Z/lSF73Q
	 UF8VmyQ8dQBynHx2r7c8w5CBtvKdkMBMU719eQEk7WaaqX8n7sVpgiGYJmXgGnQ/mSu0u
	 qwJDVreQK86TVO3xe4JNyv+1cdg3S6dd3fc1AdzFQN91qD4pK3RTq+p1q9rjYiRRI+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=deEwD+v8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA985606A337;
	Thu, 19 Nov 2026 04:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=deEwD+v8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE1B1F000C5;
	Thu, 19 Nov 2026 04:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061478;
	bh=57+ca2qjI0mQUVE11l7+dD0tq8NgIfYfszQIuUbSvYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=deEwD+v8JnFO6UTZxcOqCu/pPFomZDvltCGMjH61gWPak5jPq230ho3kuUe6+ReAn
	 LTYmK9A3W9xJAsHQ7uZbVrXN44CPbxJ7hrzZ5cGc4BVhfsaKBfcK2ojS6vxnhjKJQj
	 /4fc764ki6L6CRyhJeXqLclUNS1XD9d2rfN/q1pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <kunwu.chan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1568/1848] rcutorture: Fix divide-by-zero with fwd_progress_div=1
Date: Wed, 18 Nov 2026 16:00:06 +0100
Message-ID: <20261118150025.210845257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <kunwu.chan@gmail.com>

[ Upstream commit 5b748d8aa6833f2dec3f545311be69a2064bc6d1 ]

When fwd_progress_div=1, the forward-progress test computes:
  sd4 = (sd + div - 1) / div = sd
  dur = sd4 + torture_random(&trs) % (sd - sd4) = sd4 + % 0

The modulo operation with a zero divisor triggers an integer
division by zero (undefined behavior at the C level, #DE trap on x86),
causing a kernel Oops and panic. On x86_64, this manifests as:

  rcu_torture_fwd_prog_nr: Starting forward-progress test 0
  Oops: divide error: 0000 [#1] SMP PTI
  RIP: 0010:rcu_torture_fwd_prog+0x90b/0x1160
  R12: 0000000000000000

The existing guard only handles non-positive values. However,
fwd_progress_div=1 also makes the random range empty because
sd4 == sd.

Change the guard to reject values below 2. The forward-progress test
only reaches this calculation when stall_dur() is positive, so
sd = stall_dur() + 1 >= 2. For fwd_progress_div >= 2, sd4 < sd,
ensuring that sd - sd4 is at least 1.

Keep the existing fallback to the default value of 4 for invalid
values.

Verified with QEMU/KVM: a 138-second run with fwd_progress_div=1
completed 81 forward-progress test cycles without a crash.

Fixes: 1b27291b1ea4f ("rcutorture: Add forward-progress tests for RCU grace periods")
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 5c4bdbe76df04..d182e1ab2aab4 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2176,7 +2176,7 @@ static int __init rcu_torture_fwd_prog_init(void)
 	}
 	if (fwd_progress_holdoff <= 0)
 		fwd_progress_holdoff = 1;
-	if (fwd_progress_div <= 0)
+	if (fwd_progress_div < 2)
 		fwd_progress_div = 4;
 	rfp = kzalloc(sizeof(*rfp), GFP_KERNEL);
 	if (!rfp)
-- 
2.53.0



