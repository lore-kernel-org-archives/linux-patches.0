Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83EC1EF958;
	Wed,  6 Nov 2024 12:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896619; cv=none; b=Wj4ZcYHZiYTOvlUO1rbxtazALcvphkK3NHR7L6ANB6oy7+4a2+xsUP4vWjWTmCdjYDoUZtRm1P9o86ydun9TXVb/Xz6Xx7/kyrC1iNJLokkAhWW9EggMR8pNMRAjBP/+jKwF8wbuIqwtdLcnwy42VXD1oLoJJ36mTdgmvnLAKxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896619; c=relaxed/simple;
	bh=TiY0Vk6Xis7lEcnMauJoarQ5m1vcd13KJawC+1RWPa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSQ5HmwczTetfMSSteobfDSKOdpCCLZBYk/bwHn/YZtlIYv7i4G+/SgHZ9eUXnkyqgJPB29s2qszXqZ97JyCZmg4CE27itAN7RmpAcAwNEhZYdmRwRTZvQDIaiKJPr/UhZeW2plW0rJfTrRRgZ1q0horXuR6XrKnagv/VUfphTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9yCPJ1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9yCPJ1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C55C4CED4;
	Wed,  6 Nov 2024 12:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896619;
	bh=TiY0Vk6Xis7lEcnMauJoarQ5m1vcd13KJawC+1RWPa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9yCPJ1USZ8hXvTgOE92FltUzTMCsGncb8+iSG0WH6gMrUSiCEfzs1ufLB0i3GM13
	 gtvOFNVIJ2XPcmV3sI6CBWyTPPCjDptfOqolC0XIvyVt/SGFqyaS0O473F2x3myZaL
	 84nea8N6zN3++nh0jAjrjd7+Jh+dghyYm67sZs4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/110] s390: Initialize psw mask in perf_arch_fetch_caller_regs()
Date: Wed,  6 Nov 2024 13:03:43 +0100
Message-ID: <20241106120303.634862369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 223e7fb979fa06934f1595b6ad0ae1d4ead1147f ]

Also initialize regs->psw.mask in perf_arch_fetch_caller_regs().
This way user_mode(regs) will return false, like it should.

It looks like all current users initialize regs to zero, so that this
doesn't fix a bug currently. However it is better to not rely on callers
to do this.

Fixes: 914d52e46490 ("s390: implement perf_arch_fetch_caller_regs")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/perf_event.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/include/asm/perf_event.h b/arch/s390/include/asm/perf_event.h
index b9da71632827f..ea340b9018398 100644
--- a/arch/s390/include/asm/perf_event.h
+++ b/arch/s390/include/asm/perf_event.h
@@ -75,6 +75,7 @@ struct perf_sf_sde_regs {
 #define SAMPLE_FREQ_MODE(hwc)	(SAMPL_FLAGS(hwc) & PERF_CPUM_SF_FREQ_MODE)
 
 #define perf_arch_fetch_caller_regs(regs, __ip) do {			\
+	(regs)->psw.mask = 0;						\
 	(regs)->psw.addr = (__ip);					\
 	(regs)->gprs[15] = (unsigned long)__builtin_frame_address(0) -	\
 		offsetof(struct stack_frame, back_chain);		\
-- 
2.43.0



