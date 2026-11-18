Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026263;
	b=UQDRTiVyRT+1UEyhNtfNquy9AK+ahASII7M7lhh+6McO9N3RGKNwPVrtQU1opvr/Jkbx
	 w0UL1MaTKFReevsbBsYIrMIRHUEcjGgvMSIt0et4ha5u6J1/pIq2FHwChnM0AyyJTwdXU
	 NHGpsnHXTaGLuJVCfD2meJGP6s3YfDj2rXkXqkO6yrfvbik8X9I0KrK3/vSI+b9KJ3hH0
	 cNE4fEIOaqF/lJFJCm7Z8sgIDJPBh3ESQZPcRGjx0nu5+4mJUFVjOPpGTNdPlZOuTsqe5
	 fP8GOL8Hy9djkzpRJRfGMTPq7qRftPGp0Pmlulu7mHNYGDmDFAvaGrIA9V8U6pZFRxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ift4K+XSMSXbzKoGVz1KkMDxWuR7BcaFty50sRCtgOU=;
	b=roqcyl1jTVyqBzLzq6POHjwozfRLtyfuDSJ4jz8f59QF3EPCUX4n3jef3LrJ/eIEnlyN
	 LwHd4+GL3NEy5HB/GjECcgAGwIRb+lpPqHfWTi/cOUfhkrftFraLeGhn3nef2fYbEI2k3
	 t1pBMcEyRdTmyo4OuPJluX5TPKyCBDg5HzSp3wqC2NvQ7R4U65S2HVxQ7EJiz6w7lckqH
	 ZNE1LZ4xPVAVabMLWs/5w5z0eqGJ+nPFCRYdsGSYQXJNAv6GMUBy+Ugon8Cv2HmG+mVy9
	 u13W8gKm8NKkfIa/uiqhXWIZHA3G72GjzYiU8rZSvfb6TAIA6bhHFB8crULyXIauQbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mqVvagCm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C53B606A31C;
	Wed, 18 Nov 2026 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mqVvagCm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8AB1F000C4;
	Wed, 18 Nov 2026 18:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026263;
	bh=Ift4K+XSMSXbzKoGVz1KkMDxWuR7BcaFty50sRCtgOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqVvagCmXV1Vl+ZaS3bfyIhmnUqPnMlAjwpd4wntKrUoEWjJsfFk8qqEI7VfnE/GI
	 /+8RKbsMo5ZBa+jL515KvcKapwQgFUzUdkK+aAtrZjfuepEelq+BouSQquZDGMUM9X
	 wl6Nfz8z8m9bW5gXIMSgFFqvraMkqlgZhroJsBIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <kunwu.chan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1371/2151] rcutorture: Fix divide-by-zero with fwd_progress_div=1
Date: Wed, 18 Nov 2026 15:51:46 +0100
Message-ID: <20261118150211.962443222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 29fe3c01312f6..d98029cff32ce 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -3531,7 +3531,7 @@ static int __init rcu_torture_fwd_prog_init(void)
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



