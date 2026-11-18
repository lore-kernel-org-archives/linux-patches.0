Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036906;
	b=obPmz3/edrp39CM77Rr9XE8qltlACYt/KEtUQMnfECfzkFvSUKCz/BqhMHm/INOHP2Hs
	 bGIy62MTTd3N/v344RiUux9HC76T+pCj7ej8Iuy9IJdI0u4I0wBxux/eI2cvT1aJzQY2z
	 PoLg6gJl/jPbQ3y7tVI420Wg/8abYSGKykFNXxAGj3be8R2dCXD1/VapPQon3a/6xZyVZ
	 l/y9r04ztA7O7YKgOFJss92fGMz+ra1P7Nbhd8houdKEgWYBfQ1L9qx6rUrE0ro7fzuTl
	 F0vvp+MFSWSHZIs9rWx5WYtSBvkxuI3K+uGpwgim+X8rtHR+De+6NPTYCOoNrJvOIQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l8Q2r0VLXgfWrR4CSLe0iHUQeib1CAPiCPTdxiVKk/w=;
	b=5eX3x7UNwuyhADlN9D5jCVDuTENfbx5f2Th1YhnXQhkICRTuMhWnurnEG5RY0l2ZVFNx
	 BBYrG3VVoVFriGtRgPw8PnlLmITkz9OwX9bAUeSpk/SYKhEU9GGM5Noxxb8OIZJCM8XxR
	 aomvCrqIaHduIAghrlSIojji65nDfAb9VxM5CB+3NwQ3O5hS5vAQqriUdnk1CXd8Ps3AX
	 a3bkEqwhFAym9IsvSoiGco7rrfo22RTnDR1TLUjEnyLdgpTDZNW+xHia4w32M9rymK8tF
	 mE9JREGFTk+YOhwHhlyKljbqw2Oe1vIhLvc7obOjjqqpbGCYWMm+AhqWB/LH6ErCWNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHhqcOeX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D66B606A31C;
	Wed, 18 Nov 2026 21:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHhqcOeX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754111F000C4;
	Wed, 18 Nov 2026 21:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036906;
	bh=l8Q2r0VLXgfWrR4CSLe0iHUQeib1CAPiCPTdxiVKk/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHhqcOeXky6yBN1B5aAmGRJne9BkFXgk186QkCG55bw7QGWmo5FYJ/McC1mDiaxW7
	 eBP7eKC1/rlY0UeDmQZMwB/r7Ygr2yGIZZlU3xG+CHaBa+ee0l1rHQ/YrtmWIbakck
	 5E+FxNkaUg62R5hJ8iqPwI4Y7UEUPGqCikyqNOqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1225/3318] time/namespace: Fix overflow when converting absolute deadlines
Date: Wed, 18 Nov 2026 15:30:47 +0100
Message-ID: <20261118150356.933556005@linuxfoundation.org>
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
index 95a18cae6647b..55a88dc5b7aeb 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -49,7 +49,7 @@ ktime_t do_timens_ktime_to_host(clockid_t clockid, ktime_t tim,
 		tim = 0;
 	} else {
 		tim = ktime_sub(tim, offset);
-		if (unlikely(tim > KTIME_MAX))
+		if (unlikely(tim < 0))
 			tim = KTIME_MAX;
 	}
 
-- 
2.53.0



