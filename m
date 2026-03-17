Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FC53F54D7;
	Tue, 17 Mar 2026 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766629; cv=none; b=fgnuKiGdZTtSTr4ZT+fw8aps6w50OOin4frXDMf+bXX4g4U4dUiEw8jl+9nXSdo9cdJVlgmDtfwTZbt9LVyx0MdyoEV7W8MuDo1pzsUOK9edRrHcC4GtLwj1QoiWiQnUQELLp0Ty8wlqKL3ln+/pGb6g0pRepZK35Ah8i0h3RSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766629; c=relaxed/simple;
	bh=VZfmLpdPqHyQVrI++ARq9Sv9M1KqLN9VjD7bYBknYDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2sgF6b1s51gtViH5s/XuOvdeEJKIYN2/OhwVZlG9lB1I2YdS7SVP0rPr7C1dXbNKozHf1vm1i5e7PD7v+h+tr6gbzj+N5MwrD2wVjXtN99L548HGjYzO77fFOfIyFpyC15Co1ju9rWLrWFoFipkljAh5p6+/WqR9mkB2+DLBy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grnqgBIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grnqgBIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C77C4CEF7;
	Tue, 17 Mar 2026 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766629;
	bh=VZfmLpdPqHyQVrI++ARq9Sv9M1KqLN9VjD7bYBknYDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grnqgBIA6m/jEL+BsyLbURMW3LCd+KFUlkjoED3piiJkTkSQC2p4+hzczbNSXe8H9
	 OILqzc+NQr13mPm+lUlfEygm7Pc6LCWXFAGM6r2+A/SCfABWrMEedF9OV4D2csgosX
	 TXPjPYaHC51Vp0ri4SWAIwEggwoDlqqadg6Agmxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Christ <jchrist@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.19 287/378] s390/xor: Fix xor_xc_5() inline assembly
Date: Tue, 17 Mar 2026 17:34:04 +0100
Message-ID: <20260317163017.564508009@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit 5f25805303e201f3afaff0a90f7c7ce257468704 upstream.

xor_xc_5() contains a larl 1,2f that is not used by the asm and is not
declared as a clobber. This can corrupt a compiler-allocated value in %r1
and lead to miscompilation. Remove the instruction.

Fixes: 745600ed6965 ("s390/lib: Use exrl instead of ex in xor functions")
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/lib/xor.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/s390/lib/xor.c
+++ b/arch/s390/lib/xor.c
@@ -96,7 +96,6 @@ static void xor_xc_5(unsigned long bytes
 		     const unsigned long * __restrict p5)
 {
 	asm volatile(
-		"	larl	1,2f\n"
 		"	aghi	%0,-1\n"
 		"	jm	6f\n"
 		"	srlg	0,%0,8\n"


