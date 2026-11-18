Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019646;
	b=LUm9AhoTGoN64Y+1v0DqF1UpvL7Ur6TpPeryhmJBtXtW67q8HQivmEsgBv+bT/IDj2YN
	 qdbgklWFHWAd8BFJu3V7rHlMB7sAQTxryTLYc9Z70G0o0oTWbEqJ2Ii0eqOMFaKoNnghk
	 Tjc6mV9gyOQ3a24bsUIFw2k8xUgDOUIpzVG7SwXRiEixMG5d2b/dJ+R0OvL8YC9Jqn3Gm
	 qk5HqDxgWZziW4xgzBRsAdv0KadXQdVNNgEKzFTMOK8rng+WUVV895nt9fEkx+koPJY0o
	 flfOxcKJ5F4BLMxMXYnrl5w3eSeo7U9s/oqI1fvvioaHMlAPv4CuFwywsrDMG//vz7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jJ4IspscW/pziZzL4VaLniQ+LeffvAsX1WYGKOybbFc=;
	b=l47wYG1hlEID8yo34h5y7TtnbsWijh9NesGENZ9PfNnbwFj87OY73mOp9eLeGqM/17ZK
	 9EO1kQaYupdwXV2jesBJL5h52aQbx0a6JX1o8WKETNvuCZwg4YLO8WpecI0RxO8iY8RJE
	 dS9L9DLoPRZ9/AT38JH/CmbRLAro1+RXH8JO8+IOqJ8VmHTF09uoPiw/zNI45MCkcll9V
	 T7AQtP22cbQdqTUzlODbfWQlB8qDLyzItEwf3bJGOGaY1yZlI673eZEFieFKOao0NgUhX
	 TOqiST9qrs3uOclpawUSaxk6NiQ84JuxzH3NuDfgd/HPwh0o98ZqjWAm6iqCab/MPgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKhJjJaU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01FA606A7C0;
	Wed, 18 Nov 2026 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKhJjJaU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1941F000C8;
	Wed, 18 Nov 2026 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019646;
	bh=jJ4IspscW/pziZzL4VaLniQ+LeffvAsX1WYGKOybbFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKhJjJaU+9tcQn7W1ipfFfHcKPNiqxuUCb1oF2Vnoy4XvnbCbfIED5Vf2czAMBO2g
	 GydHmNex0ejDdgmwC4TpMAEpcofq+5sG9EAgxe8CLehkcrbLAhv5J/7T/1bqdnUwFS
	 aO96iN2jTvbTglkv/9dyqhkiOqPTZTEK3fA2nvCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <kunwu.chan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1671/2651] rcutorture: Fix divide-by-zero with fwd_progress_div=1
Date: Wed, 18 Nov 2026 15:48:31 +0100
Message-ID: <20261118150347.859372555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 794937e13e7c3..83819424cf35d 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -3856,7 +3856,7 @@ static int __init rcu_torture_fwd_prog_init(void)
 	}
 	if (fwd_progress_holdoff <= 0)
 		fwd_progress_holdoff = 1;
-	if (fwd_progress_div <= 0)
+	if (fwd_progress_div < 2)
 		fwd_progress_div = 4;
 	rfp = kzalloc_objs(*rfp, fwd_progress);
 	fwd_prog_tasks = kzalloc_objs(*fwd_prog_tasks, fwd_progress);
-- 
2.53.0



