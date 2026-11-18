Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056068;
	b=ZpX+L/WLJiUVzvVbWF3nIU0y0V8SVir5iLXUM9IpfkyEoacl1QiHlOZC3NTwbFN3ALba
	 PFxCCurjwx+iQ4SSpZd/oLGBVC6C13yYoHk5N89yoP90h5+Q4McjIa/L+0Vr93pZNDMAU
	 Vo9C/blP1Jbt7vqKWS7PhspSNLAKu5AZfqkB7cnYbLdAQGfXpUFur0odSMR399Q7wEp9Y
	 ntEK027PyiNUcA4c3x5NNlVimECtXDe5+/1RJEmW8Yh1Aon/aFxCj915x0RDL2s8nGl31
	 tb/s9JPXQ2kx5HyGs9WXSaiOG+1obKxlprv69yO2j+/oQ43XGj/fPdwCqu7jYTuavAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NDFAvwD3aZH0aHwuU8MXbvecj0vmzH+UHqFJdiynxWY=;
	b=oztSdvIB9KLI8mYafaOhNto5eqPvmlNcQfibCepErrMxqmdrPxLM7xrJw94jynhQ0Agn
	 Xp8k8/OnHaDXuzoHSHmy2p0vBUAo7HjVPZ8AyCwIvUO21w2rJ5F+IXafpfZBRYvHJD2Kb
	 iWugIuo9zvyBRUWp0xeCWUno3KNfbPLj5oNAwnfs1TkaprejDOon3p0gXfdVajTIeY4bH
	 fTnGbuDEb0pwm5BGfbla/CSboID94m0NjPOSgV57KaT3gaiVfW1rRwXP+8wge+ByMoxtc
	 iJhF+2aN58N47iTGaRcgbByqWnSnVosJQSphnCeBfO6JAUPyx/yrIjbWT7UUOTu8+HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DMRBpEyk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB41606A325;
	Thu, 19 Nov 2026 02:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DMRBpEyk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CED71F000C4;
	Thu, 19 Nov 2026 02:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056068;
	bh=NDFAvwD3aZH0aHwuU8MXbvecj0vmzH+UHqFJdiynxWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMRBpEykFCe6npYJi5OtWQKLVTYukfOnrBywW0EUYYqzBmRtVi1fbFvAqqFWCrDGy
	 lnENSo463qmgGAuOkpyre4/yodDI6Kj/mCoASeM8gw6KD2ljP6h4av8VxQBWW/ldWu
	 utIv4R6ePISpxu65KZf15zI7Yrel5/yFaKdzpj/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <kunwu.chan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1854/2214] rcutorture: Fix divide-by-zero with fwd_progress_div=1
Date: Wed, 18 Nov 2026 15:58:50 +0100
Message-ID: <20261118150125.534306744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index a3bab6af4028f..513caff2f7db3 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2499,7 +2499,7 @@ static int __init rcu_torture_fwd_prog_init(void)
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



