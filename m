Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C485281520;
	Tue,  8 Apr 2025 12:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116905; cv=none; b=eAW6dIEnq2yDriqQToW2LGDb937xJgcVhSgLzClxvN1Lk7K57mTArM/2Vb8oM+n7MFJ3XxZyJ1T11C4r2YwH/5TdcxCkcR8kfVLM8yPERrJbX4sDbiTE3BGIn5yjeH6KYaEkQ+xTQhne3UEspv5rduqj59gdb4kC4u2ppgSMha8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116905; c=relaxed/simple;
	bh=VmolB/ZGH7XnH6eVh3froFCKHirE7Emhg47qRmHU/lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTvtGcdl1RyeVIYVobBTqLrylgmCD6SB8MfI/VbeO57hCqsGE6xv+2Ep3CzTkqQ1VpbMsVzUlWiv6d/G8v/Ab5+LiQR5/mZL0q8BZf1xPXIV7mrlo+kDUr0W8Wx6M99B3Gsq8iybhjPM2nRYocBh4CHBpsmDNeFKAnJxmLKGRlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tnd3Rei1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tnd3Rei1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3BCC4CEE7;
	Tue,  8 Apr 2025 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116904;
	bh=VmolB/ZGH7XnH6eVh3froFCKHirE7Emhg47qRmHU/lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tnd3Rei1f/ZsQvIWB4u/e31tbn3mQmYIrHT2lq5l3mEkJ1SvQ4kha7R4kP7bJQQmz
	 QfVYRg/Va9n3xyvxOKQqeLw8j0vQs9mSNeDJ+0Dqe8QmuCoCq8k9AQI6aNZ36VM4sn
	 dk14BPo1kYVc2yokjgrC6Nqeii6dIPNK9icBymYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 313/423] s390/entry: Fix setting _CIF_MCCK_GUEST with lowcore relocation
Date: Tue,  8 Apr 2025 12:50:39 +0200
Message-ID: <20250408104853.095852683@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 594da4cba707a..a7de838f80318 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -501,7 +501,7 @@ SYM_CODE_START(mcck_int_handler)
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



