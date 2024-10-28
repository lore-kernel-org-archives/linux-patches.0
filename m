Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C05189BAF;
	Mon, 28 Oct 2024 06:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097622; cv=none; b=Q743mSofD2Lq9bGMnFphpU+SCAMcURXvJJGeOAgbVcCToFQu72Rf7CaypasrULTFDYEeMFHpu0J1hCVCc1NhVDmweI6oHYWa0nec+xhiITpOwaYIEBAed8DDOwJw0d+I8qrB0/edzpHwUlT0t3Q0GCHDd5bGd61MwNDlDYQBnNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097622; c=relaxed/simple;
	bh=VpTBm2xfcBDMgkss87kyoPzmXrF4Wsaan4/LvJy8fPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vbh9E+vUs0kzDQckDhlHs0lzz1l6bqV3RYXCx/RvVvD49Pv00YdzXx0664HrWNAVoLJmxDPYy0hBkx3AzIrzrrpLnds2gmch7/xTIf6svKISoDLo0dpzbv8/d+FUNTlAHSqE2Ue21MzZRc16weEZErZ1azmoAcxFiaf7anB0xug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0BZv5uJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0BZv5uJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACD6C4CEC3;
	Mon, 28 Oct 2024 06:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097622;
	bh=VpTBm2xfcBDMgkss87kyoPzmXrF4Wsaan4/LvJy8fPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0BZv5uJwx9l0XNrsJm3Jt2UfDRhwZTs1FhL7UHx7NN0F5r1mXYRRC0WHX7384exR
	 O4INZbcR1HBCgWA4CCQPH1KffVNdzRsWhtGDaQXxMwqo1FzUjeLe3PaJbU56RNKjWf
	 2NM8s3TRaXvWTWPUlgxJEassJxuEVokybQcCKexI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/208] s390: Initialize psw mask in perf_arch_fetch_caller_regs()
Date: Mon, 28 Oct 2024 07:24:15 +0100
Message-ID: <20241028062308.494456322@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



