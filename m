Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93C8328B61;
	Tue, 17 Mar 2026 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768131; cv=none; b=l9CyHmrRfcV807Zh+6BfxPu7F6fXv2fEFNKmdCqlnt8ztQ1pCd0Zf7RZqRTpOe3Hz9EodDG1wTe9qaY+wBS4MDqNRcCWHg66UMT90Q6Zot9vbKxpQeo02wi/Iyl0DqsEk79Wb6s3p4JNU5MQ11ta7PkH84BPj+vlswBsn1Cu1TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768131; c=relaxed/simple;
	bh=TdavJe4XyBR2sXcziIeP/ecLJapnZyx6NeuhaG6c87A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSHECaQRA8E04d9IdS5NSMbzEKlkru1YpynPTza7eInaJP/gz5oTHa/5YJ24C7saehdPHAymR/c9Q/XC3eXVEZpUa5QRGc70ZIFERSpiEQ9RDa6PgLcEXVJWKw5/XXxS6nBdOxvUhTQ8nItSXoj2WyRH1Rody1cbQMrkW2wOCLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDdliwI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDdliwI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496BBC2BCAF;
	Tue, 17 Mar 2026 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768131;
	bh=TdavJe4XyBR2sXcziIeP/ecLJapnZyx6NeuhaG6c87A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDdliwI/2qBs4f274E0fbS3CujgT2kZ/sTMez9Ijxze4xS+8JlH/u+r/JshaagQuF
	 C4uzdqC2PXNtTbky4qTTDSUZ3MQ6RYOJYZ5uFkVrP03grCjgVA+0HRVfpDjG5CitmG
	 7ra6hVrpBK/IFwDxA4JKpqditN9R/oduk+IM++tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 237/333] s390/xor: Fix xor_xc_2() inline assembly constraints
Date: Tue, 17 Mar 2026 17:34:26 +0100
Message-ID: <20260317163008.153719410@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit f775276edc0c505dc0f782773796c189f31a1123 upstream.

The inline assembly constraints for xor_xc_2() are incorrect. "bytes",
"p1", and "p2" are input operands, while all three of them are modified
within the inline assembly. Given that the function consists only of this
inline assembly it seems unlikely that this may cause any problems, however
fix this in any case.

Fixes: 2cfc5f9ce7f5 ("s390/xor: optimized xor routing using the XC instruction")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20260302133500.1560531-2-hca@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/lib/xor.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/lib/xor.c
+++ b/arch/s390/lib/xor.c
@@ -28,8 +28,8 @@ static void xor_xc_2(unsigned long bytes
 		"	j	3f\n"
 		"2:	xc	0(1,%1),0(%2)\n"
 		"3:"
-		: : "d" (bytes), "a" (p1), "a" (p2)
-		: "0", "cc", "memory");
+		: "+d" (bytes), "+a" (p1), "+a" (p2)
+		: : "0", "cc", "memory");
 }
 
 static void xor_xc_3(unsigned long bytes, unsigned long * __restrict p1,


