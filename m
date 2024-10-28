Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA48A8837;
	Mon, 28 Oct 2024 06:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098128; cv=none; b=i8PTIHUu3CtVgx1lP1BwidErGHQ0QIjYIdvKJlB+gbqp2Y0wyedrZYWgl7oHv4X6u8WQAlUUN4pGI8BMGStcHohwN+8j5+8InQ+7NReu1iMyMgw5X/GHQqdpTH/rY0/ep3d/pXYEOqq1tZ4jJyFPX+jMLxMQ4ibacSYqV+Ivt8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098128; c=relaxed/simple;
	bh=rsZ9LlPgvm+yU/1HIO8hGJUW/AN6n6l8SShbJj8NG84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK5TdcinZrTA2kJUlpV52YUFZZ1XZ0DGVclsUh3yp0r5yQrbr396AilQ2WpokoUkyU5eNaMh7FHeREbQL/+UnGhNGLfmkGoKPnogO1mp52fHmbYjeqYc9Bu+m/2oJSjC1zk1ZPT58mpb/tQ6kLf6zV20Hz9DnZYsz/r7akLhxzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mW/l+Owv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mW/l+Owv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FF9C4CEC3;
	Mon, 28 Oct 2024 06:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098128;
	bh=rsZ9LlPgvm+yU/1HIO8hGJUW/AN6n6l8SShbJj8NG84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mW/l+OwvWCffy8lQ3aCF+OtOtTyC/Tykklf28VA9kLO8tjhnJjQVa2xoP5/zkZn3Q
	 TAgTgQeW9d3j70hwxuuSnkduzOHDOuZ1N68LDiNgwl34HBiYi0/rYcflcZguoc+/+/
	 IM2g4nMoSaG6k895Via30E40yJYpX1AmDJHHPgpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 088/261] s390: Initialize psw mask in perf_arch_fetch_caller_regs()
Date: Mon, 28 Oct 2024 07:23:50 +0100
Message-ID: <20241028062314.240284927@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9917e2717b2b4..66aff768f8151 100644
--- a/arch/s390/include/asm/perf_event.h
+++ b/arch/s390/include/asm/perf_event.h
@@ -73,6 +73,7 @@ struct perf_sf_sde_regs {
 #define SAMPLE_FREQ_MODE(hwc)	(SAMPL_FLAGS(hwc) & PERF_CPUM_SF_FREQ_MODE)
 
 #define perf_arch_fetch_caller_regs(regs, __ip) do {			\
+	(regs)->psw.mask = 0;						\
 	(regs)->psw.addr = (__ip);					\
 	(regs)->gprs[15] = (unsigned long)__builtin_frame_address(0) -	\
 		offsetof(struct stack_frame, back_chain);		\
-- 
2.43.0



