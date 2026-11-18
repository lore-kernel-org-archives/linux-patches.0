Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041303;
	b=yUARcx9ChWiEhJWWHfNUMAr0m9xmo1U/9nPyUYc1zCN+4OQ9KBju/SlZZDHhDemQTfxi
	 qvSfvJ8+PymACEMC5ERQ/8yAAco91dXJc98H5M0xuh6nMoyMHzMpNIOZ7PdyYrJr04RzT
	 8Sv9ABzBcKwDp/UJuSIT/G3d0i0yFjdPxguVH+nGSHjths7apK/I0Xj4GHH2Hg9o5VGfB
	 OovH6bd94hXEWaqpGV3CcIHPl8zrRl32ahhPHtCmxxnMGpJxgWr3/JqgW/wrLBzHU1y9s
	 kd0Wfr9y/Kz+9wvG/JrhPWBsKq6YAVRJdXAYa060LgWHpKnzY0O9jCbsAY7dACW6Y6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q8Fx1IqI1Ugl823nxGKcmycs5XwFlA+0ogyLrs4BTC8=;
	b=O5n5/jBNPO931TMoyqfqDpIwUAeeZLLGngRNJ3yQqoz0zPcmrxiH8cLDbqObQoEUqulV
	 vveGvyy2hNbjsHOTrrbGphp0jUsyBP8KDintpVAtA8dMAPzdjX0UcNiUn1O/Z5PTuQXJr
	 lBJoJgASffsBxrgJ74UFPuEYfFRZRgQWK7skwd4SczxOW78Wo0z7TZ2kY1k8bJ5lkU4Wg
	 qJRQrbef0OaSNqWNjOs84tR7ab6uv4pLQLK7b3BCIRoeXgq6jSMWE1CfZymeb6Dpu0x07
	 exe41S4aLGAo288YM5OnWlxqQUZQvL4ZsQtyoTZbvoMQyAIaGy9A4HECU8qp6dqYwfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZJOyb7q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20AC606A32A;
	Wed, 18 Nov 2026 22:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZJOyb7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0464E1F000C4;
	Wed, 18 Nov 2026 22:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041302;
	bh=q8Fx1IqI1Ugl823nxGKcmycs5XwFlA+0ogyLrs4BTC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZJOyb7q6Zx1Mp/IqqdzPRDXNSyHWLEXE4gpr6RT+RojGaKMekQzaiD6c1tXDVjYM
	 eCZ/IfZMzuxRLMUI16irvc1p9yfa9QTd+QdJle33Pd/r/6e5vU26Pbl0C8lkBFU860
	 PSV7n6dwfMLwPy0mv6M2ebGdZsFPYZ9Ecvzt0uu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <kunwu.chan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2758/3318] rcutorture: Fix divide-by-zero with fwd_progress_div=1
Date: Wed, 18 Nov 2026 15:56:20 +0100
Message-ID: <20261118150443.474852714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6a42accb14634..8e4fdd968a541 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2957,7 +2957,7 @@ static int __init rcu_torture_fwd_prog_init(void)
 	}
 	if (fwd_progress_holdoff <= 0)
 		fwd_progress_holdoff = 1;
-	if (fwd_progress_div <= 0)
+	if (fwd_progress_div < 2)
 		fwd_progress_div = 4;
 	rfp = kcalloc(fwd_progress, sizeof(*rfp), GFP_KERNEL);
 	fwd_prog_tasks = kcalloc(fwd_progress, sizeof(*fwd_prog_tasks), GFP_KERNEL);
-- 
2.53.0



