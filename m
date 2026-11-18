Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026449;
	b=5hi3HOES8izt8kEBbSD6o5IPwPlyDcZwf93fLQ0KapK9kNaTSSLHiOfc+taOcjkyQWOR
	 PtjZApexYR299O6X0Bre4zknQBr9vT7+h4kkMIH3nwjIkWiNlgdatRj+OMMNudzZuUeus
	 33eCpUkMcBsqlVwwne4R13rKYlJ84Ft8CRPxhtaPtHKSKz0USfpqV7E8sCSR+9KMXakmj
	 GPvgiIVZ964GPcwGaiXU6+n4jwCEG/wel5YUjXo8eO/W5Xgbo5Z2NpdUymG+OHLQ8MEQF
	 tVPqJJQtlAVaLtKKAF9EHZE0JHOoUZN74vb+WaSGyvKK9PPpkjmtsAgDQJITq2Xnqyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ruZnClFbgZa9X5GcA3yDWt6uZ23lHnrzOCJx63bfKs0=;
	b=phcv4ZPqVPyNl9vZ5dJok+Y2QQuHW42xawL9d9I4PNpIv2h8KiiaW7QvWS/gBGHZMAAh
	 MT+YIGvQ+EDrFy0R0qJ2q6rl8uwNCy5D5rvn6Y/i8/RHzSnSUv2+oT3m8RKzIEJpJsQrp
	 XOi33IL/SwkDMbQKvUKqvDgKOM8gT+bnYalYQteoprFfjA0cEjW5f0V3Pe3M+5RjF/zD+
	 2LF2gierXK4UuFS/gBvj5z3Rmrqtei1sf/AbRZhmbxSDgznpCJjrmcfWZnr0I5Vj8CAIQ
	 73Vc4TJBG3qCMAoC2u+eHKnd0I2YZV0gGn2UgI8OZx+zjmZN9vO3U/o/Xpu9m4sg3zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3HvI2bU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1973F606A320;
	Wed, 18 Nov 2026 18:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3HvI2bU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24ADB1F000C4;
	Wed, 18 Nov 2026 18:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026448;
	bh=ruZnClFbgZa9X5GcA3yDWt6uZ23lHnrzOCJx63bfKs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3HvI2bUJPwa0VbhbnaElLfZkvVe6XjrY/W9FdHATa7vef33bU7gYkTi7hlFpeL0Q
	 cGIjRWC5ztukwz/2sCDcZJ90j8QL/Cvj+9nodzVF/FhpGl46T6ziF/TCe3cXQKEE0w
	 7QwnUX7RG4r+OQj91h/iRM0picLNa/RlsJKTgJ90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1439/2151] s390/uprobes: Fix off-by-one bug in emulated PER handling
Date: Wed, 18 Nov 2026 15:52:54 +0100
Message-ID: <20261118150214.354583451@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 2ba01cf7b2598571486425a0605f1434909b532d ]

The uprobes code emulates some instructions, and with that also
PER storage-alteration handling, in case a debugger is attached.

The PER storage-alteration handling contains an off-by-one bug, which
may lead to PER traps which should not happen. Adjust the comparison
in sim_stor_event() to fix that.

Fixes: 8d1a2427d8fc ("s390/uprobes: fix user space PER events")
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uprobes.c b/arch/s390/kernel/uprobes.c
index 5b0633ea8d93d..1d088c31cb610 100644
--- a/arch/s390/kernel/uprobes.c
+++ b/arch/s390/kernel/uprobes.c
@@ -247,7 +247,7 @@ static void sim_stor_event(struct pt_regs *regs, void *addr, int len)
 		return;
 	if (!(current->thread.per_user.control & PER_EVENT_STORE))
 		return;
-	if ((void *)current->thread.per_user.start > (addr + len))
+	if ((void *)current->thread.per_user.start > (addr + len - 1))
 		return;
 	if ((void *)current->thread.per_user.end < addr)
 		return;
-- 
2.53.0



