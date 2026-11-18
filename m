Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031510;
	b=Xa6YIYTVp7XApqUiRo3qYNfshXNtRZqc/TYaW4mlLedhO+pfaUo7l+8b+YP6Pmh5L4Yp
	 op0fUnQFHUEDRX+EesiknKo/hkQ6vvU0HN7hDtyhTFvJ0i9oVz/EPiceKoKiMlVIznJSH
	 HqYKKs1rxNpN6tY3opLhRZY8QICzvmMSB9Mi8W8VBVN4hzdiIOM3O2+oGQXFBA86DPnSH
	 jsNeBuRT2OhqTpzn7kGF/X2dgq/FdDe6eDNu2llMp145j2eVl6+HodCv1/lX9idYRewGi
	 ff/jim7dbHmYkIDkdaxS7+BMWT2o2msVz9yTFWcvfrL3e8kW2T/T83toR9IHqXObwBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IOokM4XUHGbSu4626biSmzrOy7pQqrI4B/9+FDly6qo=;
	b=sUWXH31jSbaawfpr5Dvtyb2Gxt87XcrHSlcWrtPhvvKRU0wcjND2eehhDxySaNoGM3Sn
	 GS4ON2GcrsekEkPYyARym8mLq9gZk59iJ7IiZl1XduI7JTHHCn3h1lV035pPUdHYVf7+g
	 1tnSFI2QHZQUYir8IqRWRpxUTJc8Sq8DvBhq1q+f/4l+bLjqTpr19qz08lV7ANaPhlGcQ
	 d7o5r4r2KoHX9ZonrX3M063kiVBX/3isGpjRUnTOJ20Y4tfnzP5YXoCBL4yWtWIXOx+3P
	 tRPkRgMfj/MTW3oXSmE1dPA369/cRgf3uDADnzPwAmvofbMU/REknCJGWjjtR4TveSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2DrszXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE368606A320;
	Wed, 18 Nov 2026 19:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2DrszXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4723C1F000C4;
	Wed, 18 Nov 2026 19:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031509;
	bh=IOokM4XUHGbSu4626biSmzrOy7pQqrI4B/9+FDly6qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2DrszXgl+YAhti8xrStmWP/X2mfK8lX4ztc0t5E/uoC0/WORLsFerGOcjUHnnM+Q
	 m5gxGWLO1prDcm4CnmQVHSN68iPk22+vb0EU5wi9FBNC4klY9QPx/EnB1R6lzeG/mJ
	 HVt07AOZZ7kK4VsyWHR4sPEfXIYpnMREPv8EKRFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <kunwu.chan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1084/1756] rcutorture: Fix divide-by-zero with fwd_progress_div=1
Date: Wed, 18 Nov 2026 15:53:31 +0100
Message-ID: <20261118150053.354582777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bb75dbf5c800c..ac1c872703f31 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -3034,7 +3034,7 @@ static int __init rcu_torture_fwd_prog_init(void)
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



