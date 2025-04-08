Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7F1207E14;
	Tue,  8 Apr 2025 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115161; cv=none; b=H1OjI7jXyjW9793LHOxNTECoBFryx+jc6Xv2535otywTcxtjgJ44LmwbGoXcAwM8dDQrYRQL1SQtAZn/HvXhL9LPb+cz2h2Eoh7+MIHi1Sdjosopo7qhDkb2yufcHoje3QfuO1Q1Sb5uCbicN4ganpgfWAXDZJyTcNWFz66Pi74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115161; c=relaxed/simple;
	bh=IiUDAgAMwKQZdwDugKPFrL0/qPYPsN8E9PHJIf2mOK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1wc/RRZ8GeGr6uDB1rMOGpf2L4vyu7sWbyLlYt1LbBBBLmScLwploY/nOejoSW61+S8WhxHMiaz5J5/K+PlCQuImYdOELmGkmiH98CPTIH8xapWkZN6H7MS2kG12KDHPURh9JvUvk/tRHS4yd0cUA0vtlk4Ft1ct6bupfFikUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtukVkQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtukVkQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1DEC4CEE5;
	Tue,  8 Apr 2025 12:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115161;
	bh=IiUDAgAMwKQZdwDugKPFrL0/qPYPsN8E9PHJIf2mOK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtukVkQMyfQWCi3WFfp/TnbGuN92YLrzBQqvkZs4LzWraAgnonM1t4lelIRD1F5Gp
	 EyN50jQTd2qJGWSmVoh/tRToXWegrIveRrin/8xzYQ6wzYEjRYmjk+byQgoK4QdLJ+
	 aKyBUiX76AlfsXS6zm40sxJMjZoHUTgjhZ2hF4eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 371/499] s390/entry: Fix setting _CIF_MCCK_GUEST with lowcore relocation
Date: Tue,  8 Apr 2025 12:49:43 +0200
Message-ID: <20250408104900.483092350@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 960c08700cf69..6df182bb955a4 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -481,7 +481,7 @@ SYM_CODE_START(mcck_int_handler)
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



