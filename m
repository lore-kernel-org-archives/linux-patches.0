Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A6819EEA1;
	Tue, 16 Jul 2024 15:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145333; cv=none; b=iJv5BJcac5gpGlTxBCLrtwDCkXAN+mnLfPqLrUSSRPIHiaFVKt49g+G87ZGTL+ARiUmNq14H73KWqzfkYKB4D8v+DnZHUR6oU+NM+tyR2f4x+AQEhwe2/++owObIgbnykw8DLhT2sho2gXyIKTWnPWEXZko0NrBFdPdxe8bK1lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145333; c=relaxed/simple;
	bh=5pK/tMVTcYSg84XVui0HoXD1gkCHb7FvcWh59nWHyJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2+0GTrtgw+hM5Ts75/KPsoHQLM/993ura4Czbd86FMEDqLahpP2S4y+6Gi7jije+55bh8Ii1ry/RlaViIhPimyhIaj6pGHr2qXxW/TIrqJj5HBoAljO69056RDiVqNVv/IeA4coptlDra20c8O4N6d9gwumJN+keGOQf4Fmyi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJfqJiFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJfqJiFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE00C116B1;
	Tue, 16 Jul 2024 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145333;
	bh=5pK/tMVTcYSg84XVui0HoXD1gkCHb7FvcWh59nWHyJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJfqJiFpuXsarGAeMQbF1SLI04MRgodHRaVPlx3O3Vbgeq2jTg1z5qIcpBQGu/Wav
	 wK0a5AyHhzwmcWi/6uA2ZrK9momSToEYR76ovVbX10AvvrpRn8TDlbK4p34cHlhn6g
	 2QvBrgnZFlMYqHzwYFRqtixo69UfZxnKALMVEJQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/96] s390: Mark psw in __load_psw_mask() as __unitialized
Date: Tue, 16 Jul 2024 17:31:41 +0200
Message-ID: <20240716152747.672325176@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 7278a8fb8d032dfdc03d9b5d17e0bc451cdc1492 ]

Without __unitialized, the following code is generated when
INIT_STACK_ALL_ZERO is enabled:

86: d7 0f f0 a0 f0 a0     xc      160(16,%r15), 160(%r15)
8c: e3 40 f0 a0 00 24     stg     %r4, 160(%r15)
92: c0 10 00 00 00 08     larl    %r1, 0xa2
98: e3 10 f0 a8 00 24     stg     %r1, 168(%r15)
9e: b2 b2 f0 a0           lpswe   160(%r15)

The xc is not adding any security because psw is fully initialized
with the following instructions. Add __unitialized to the psw
definitiation to avoid the superfluous clearing of psw.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index c907f747d2a04..26861b09293f1 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -250,8 +250,8 @@ static inline void __load_psw(psw_t psw)
  */
 static __always_inline void __load_psw_mask(unsigned long mask)
 {
+	psw_t psw __uninitialized;
 	unsigned long addr;
-	psw_t psw;
 
 	psw.mask = mask;
 
-- 
2.43.0



