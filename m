Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063670;
	b=5dDWWwudFyOLqxXU06cSBoPAViamEF8jXLopHz9piHEEQoKa23QbtioXwXWYSo0O6CEK
	 W7ggbTufGUGUqvW0KOTQZ4zEkj5c/BOf0wKfav7wwpL1DDKq/Gx7c+tFIeUZsXud52EDV
	 zVSqOCv68YGYRhQ/VVfYazIrwqS72T51JGgHPvZiSlTOJ2riRONlNUfgZglFhyPslgygf
	 zu/DiTx6ikyw01zWRHUBJLTZVn+vQMAzm2nVueCrN8kTZD+IqCE1ANCo0cR7SpCa64YK6
	 BofTro5AfyKZWAT3dCnHDfmGEWJSjH7Z8uwBicBxBdHy2ij1hlfd4RGUqAsBWpMNbqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HChrjCnUftQHUjMtT5fqb2R6OS0ktPTLuRGXJG7XdFk=;
	b=llvGQF/KLo3l0zL8EVhFkjHUus/0X2XOqc847sS9hN2ILm9W9hd/r5xKSemoBZemUsnj
	 DExfD4LGksFev66bQMN4dJB5DJ9DRiZya37a4/1vMAN/7dLqs4la8+tny8k8WgVAWKnb1
	 DX8zc8fSQWghwTGH4xZnvVZbAGXlsyphf5Ybd/RpWfJ6YXNsI2g2z/E/UsSllS380Vs4L
	 aemYvSMQcN+wGrYjqadB4ZVwrzzq6lAF2GnewK6ZAxuuzC1P1qBFOy3NtyJi0kt2phQSM
	 W6Hsh+UJyT8Fu85hiOb1uLHteLr9ZTHd1mllqLRAe1CnWidqaSdIayzOZ/v8qMJ446Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nyZsW4vi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2FA606A9EF;
	Sat,  7 Nov 2026 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nyZsW4vi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE491F0089F;
	Sat,  7 Nov 2026 15:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063670;
	bh=HChrjCnUftQHUjMtT5fqb2R6OS0ktPTLuRGXJG7XdFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyZsW4vi1Mc28hGj0syhU4CHpc8kcdlYu+IitQi0ypPXenOONUkjj/dVk7C4xeND8
	 lvPQ0wDcMtRRiAwQ1Exjp+xJWapjMIrULZjzbjqtu0Ulziyu6lj0pVZqYgVAa0O3pl
	 bWtiAIbBvib19UhMGF+LbK1u4P7rNzJyqAzKS1EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 764/869] time/namespace: Fix overflow when converting absolute deadlines
Date: Sat,  7 Nov 2026 08:57:26 -0500
Message-ID: <20261107134918.619113164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit d69cfd33b5a8d176124c564513b9ceb933595d93 ]

do_timens_ktime_to_host() subtracts the namespace offset from an absolute
deadline and clamps the result to [0, KTIME_MAX]. A negative offset can
make a large deadline overflow to a negative value. Since ktime_t is
signed and KTIME_MAX is its maximum value, the subsequent comparison
against KTIME_MAX can never detect this overflow.

For example, with a -1 second boottime offset, an absolute CLOCK_BOOTTIME
timerfd deadline of KTIME_MAX can expire immediately. An absolute
clock_nanosleep() using the same clock and deadline can also return
immediately instead of waiting.

The earlier tim < offset check already handles the lower bound. A
negative subtraction result in the remaining branch therefore indicates
overflow. Detect that result and clamp it to KTIME_MAX.

Fixes: 89dd8eecfe961 ("time: Add do_timens_ktime_to_host() helper")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020233433.20997-1-dennylin0707@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index 99dcdb3315db7..632f331572847 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -51,7 +51,7 @@ ktime_t do_timens_ktime_to_host(clockid_t clockid, ktime_t tim,
 		tim = 0;
 	} else {
 		tim = ktime_sub(tim, offset);
-		if (unlikely(tim > KTIME_MAX))
+		if (unlikely(tim < 0))
 			tim = KTIME_MAX;
 	}
 
-- 
2.53.0



