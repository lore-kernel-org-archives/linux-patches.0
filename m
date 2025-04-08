Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F5B2676DE;
	Tue,  8 Apr 2025 11:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111999; cv=none; b=YEJST3YmRRv5cTMmL/Zn9ozTQbegf+Unkkwjv97QjiT4jFFn6DyE69ogEt1uXeDCBQylvJq9TKtjRLFsQkXzmD99d7SHD6eIAOo4l/Dt9OAFH1LHF3CAsCTaq1WmyowxUvwbk6rq9HQ9OzCALB7ySFYuBJ3VBQUUQmEGa+jTLIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111999; c=relaxed/simple;
	bh=BzEvyEOTTlj2YimVDPJUppu6Ld5ng2+XFOi4regKyWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON/vfL8qPVNwvyya2lnKKEYwo49u/5f+qI8AaTPUCKMpZ5xUcgaMz79w6QXAd4rpPvJgUHt/dwEzcaKAFTni/wC08H9P7Y3+T7XRPZfVm48/s/gAT2TJ7xeUk3RILxLy7k6B4ahHGQHSiO2WUh90umFmYfvbZ1s9jp7rC++4/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYHkPpoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYHkPpoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501B4C4CEE5;
	Tue,  8 Apr 2025 11:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111999;
	bh=BzEvyEOTTlj2YimVDPJUppu6Ld5ng2+XFOi4regKyWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYHkPpoKyyMdMvrrkXaBglDKxGokzjtABe1QcGeLJA/TNIzg5M8T8ndd51UaCcuNc
	 PbDWzU82q37Smcg5gMVOVzeLlm0gU+2ojSrRbvlZp7YM/e8hxOwHGZlBulf4/NlJHC
	 8e3R8+KB6uctXnEOGDtjN6cBajUIUeYwjfJch6/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 599/731] s390/entry: Fix setting _CIF_MCCK_GUEST with lowcore relocation
Date: Tue,  8 Apr 2025 12:48:16 +0200
Message-ID: <20250408104928.205816683@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 121df45b37a1016ee6828c2ca3ba825f3e18a8c1 ]

When lowcore relocation is enabled, the machine check handler doesn't
use the lowcore address when setting _CIF_MCCK_GUEST. Fix this by
adding the missing base register.

Fixes: 0001b7bbc53a ("s390/entry: Make mchk_int_handler() ready for lowcore relocation")
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 4cc3408c4dacf..88e09a650d2df 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -467,7 +467,7 @@ SYM_CODE_START(mcck_int_handler)
 	clgrjl	%r9,%r14, 4f
 	larl	%r14,.Lsie_leave
 	clgrjhe	%r9,%r14, 4f
-	lg	%r10,__LC_PCPU
+	lg	%r10,__LC_PCPU(%r13)
 	oi	__PCPU_FLAGS+7(%r10), _CIF_MCCK_GUEST
 4:	BPENTER	__SF_SIE_FLAGS(%r15),_TIF_ISOLATE_BP_GUEST
 	SIEEXIT __SF_SIE_CONTROL(%r15),%r13
-- 
2.39.5



