Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F13418DF8B;
	Mon, 28 Oct 2024 06:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096884; cv=none; b=MqdIsTDPFqUsZ7MWLNF4UeUiLMeP9TKx/0iEPmWWDgUn0Ety9+TuUb993vFq91ttHvLSKMmuxnbFsoyDZ2BAnK8UNtyJ1SFWn1kFleSlF91Z/kqPU0Aw8AQL6Izt5HU+ggFgA+Z9m/zH2dNztuztOgpBKDs07d9ewYQ9KGJMeR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096884; c=relaxed/simple;
	bh=ZsuP0SJB0MV8TV4VCvdgM45pQ7XpkfR8OSjRdk/EtQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwDMspbGXA8zOPMDw+RySUJFyLGGYybVln4Y+s8HkKbMThx9Rs65x9VfmkDbJotS0/+lwbjA8gOMdcJ4qpcQsXhuQg28s67ylpear9bGT8/znxiy1ecRSkM1NOA6f2kA8ruCQ40+1Ry8THSrHKyqIx4IkWUJX3Ol5juN/gBwP+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNiSN/6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNiSN/6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65EEC4CECD;
	Mon, 28 Oct 2024 06:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096884;
	bh=ZsuP0SJB0MV8TV4VCvdgM45pQ7XpkfR8OSjRdk/EtQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNiSN/6OguZC1R4txOWR7Y76ygOfLQ1vZZFF2FfG2hf/gVSyb8V8r/aVJIUfLCse7
	 +GGHd4MT4+5W10RzgqAAl3J01VYzcYQBM4+LejrYPZmKVP5BAeX2M4cDAc1E4vFoBM
	 9WswFVk/IuJC+beZ+0bx1KMEEIeSdOSa5vQMmHb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/80] s390: Initialize psw mask in perf_arch_fetch_caller_regs()
Date: Mon, 28 Oct 2024 07:25:08 +0100
Message-ID: <20241028062253.411697789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



