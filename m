Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049524;
	b=SnQz8P8+GUVsd4eYa0BOW+LWZQJJSXNBbZDCdagEqNeTBk+ldyoSZNgdm2Q1dSLle1NZ
	 2ykbRuUznnaPrQTyC8nQt4oM7Jyuvx5RQaWcJH5SgrUfWDe4pWROqBBdGSC96mHtdMVIz
	 bnmRc8O5i29UCyJ0RvYAc22b9abuhkWrXe4mOaD4HcW/HOe+Bm1Sul+TRuvPvm5ffD5kp
	 HuUD4i7+/2qIyQLhkuNl2AmJOUS+kyd/uDya1Z8I6mHwQxB5szmD+k/F4WI56/Vn3avFz
	 UbaI7XVpF/F82WIN1xO1QzKSRVlA1bTfjZJxH6OF18L+NplRGgm9Rxj4vVyqg79AZjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xS/JDs3GFalG7Mwd540eUxHGezETJp4TOVNqGgMucy4=;
	b=jk20khR6yNH1NH8hmdIYQyRFlNrPkqKauhNjMf3T8K789jgEJBon4LUPuHypQMmJT5jl
	 tr9zSgS4CQJdaX8/JKIQz31GybnHRmFoepcz5616G1RtSsq55iLw2Pz7NDbfg8HdVUO61
	 8kyAKcz1p6wHStWcWEu7thrB6XsjtR0XdRzcgtRVuIBwO/HUb1bCAbkZMpfyKhI2l6D3Z
	 ZgUilpye49uXyYdlWBXlqxTROd+5X1F/w7aZbWtOmXe1h2yNj9CxeUBIFYLuCy1UfpCbR
	 QdtVaqT0CFtMfS6r4rb0XrAb5HqmcZSIGEQln9RWlF35/mzer42lNhud/q//FSN00rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQpSGjlw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB66E606A320;
	Thu, 19 Nov 2026 00:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQpSGjlw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283C91F000C4;
	Thu, 19 Nov 2026 00:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049524;
	bh=xS/JDs3GFalG7Mwd540eUxHGezETJp4TOVNqGgMucy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQpSGjlw5dN5p1I3ZI2Dh1QMNYujLq0iyJaYgezN36XpDQqA0yqccT6C4i3Vnpg+Q
	 clXFaVA+hiI6KY4A+VITlnFXLKSdq5qJ7g2iuA+RtZ3S1zBB+LZw6LGcuDS15CBC0O
	 dJ7PcdzuwBOLxlGS0GRkMWtdfObGJpavHqgoHAdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <kunwu.chan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2382/2857] rcutorture: Fix divide-by-zero with fwd_progress_div=1
Date: Wed, 18 Nov 2026 15:56:56 +0100
Message-ID: <20261118150327.291926444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f6c67d3b68714..8309df2443d68 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2912,7 +2912,7 @@ static int __init rcu_torture_fwd_prog_init(void)
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



