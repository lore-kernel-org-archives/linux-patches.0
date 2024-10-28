Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491D218FC84;
	Mon, 28 Oct 2024 06:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097252; cv=none; b=mO5F9yAd6E00e9qc0BA9uj6GYp3/a/GPnWdGTqMvkrxQhEv14LXvs2m1yG/3e6iLlxfxkX4w5RkUo5z1WrvZ7TtFqn7SaBkHi7iPMBCdbm0ifuTxocYwDDIvtGCeoQFFyXCRAvqzyGe83QWTTo3t7LYAcUDo9I5rOesv9/KdRHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097252; c=relaxed/simple;
	bh=T78wH5QcuEKYNuaL74OQSKhMwTuA7XRRO73q4+QXy6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7F5qUgoVYGb3LqoDk59Bg202V6FvPDH5+zCejiAklSlFivGV25sqzFZLHK+QPL/4iY1GAPtR8GNeKlbZcfAjLcPLMqA844UM3ls4kpKEH8yGnN9sjnW8NUAz7rfwQvcK9c/f6RUYl+jMOhZ0CJnLc1hFpk5K97eeuqm5xDP/Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSAoMtIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSAoMtIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83400C4CEC7;
	Mon, 28 Oct 2024 06:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097251;
	bh=T78wH5QcuEKYNuaL74OQSKhMwTuA7XRRO73q4+QXy6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSAoMtIjWvDb0XCeZ7csQsfKM+BujoQnILo0ZHaAMoHtH4SfE8VydwOHJ3jXIYHlY
	 u2aFwDZPZfK0V7g4QcfVUTVBiKi+POY3r6qTJD9ZslKvYKZeVXFm74PCBjtDqcT0jL
	 Bid1iQaTKpU68YRT2r3TPimEMlA1GhRlZ/qmPLGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/137] s390: Initialize psw mask in perf_arch_fetch_caller_regs()
Date: Mon, 28 Oct 2024 07:24:46 +0100
Message-ID: <20241028062300.100100405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



