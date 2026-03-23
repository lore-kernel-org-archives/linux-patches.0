Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0FB3BC693;
	Mon, 23 Mar 2026 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278879; cv=none; b=SGHAPR9t2s+iMU2j5/nknCIHMqTH2R71T8mA50YQQ1PsRMcKnAY+MxdsZMPgcPzT7dRrRFYFMD51d9umLGEN3hxiH0gk8PttdVxgt9ds3kLs6ymZ1DE299rkLKmbiwwqdkNEQauJ/dUtOiIOZxN71kv6XYPw+l1yAyYnXloDJbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278879; c=relaxed/simple;
	bh=UfneRwN8TikomASAENpG1HkB6Fnhsf6+aRza4DY9hIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvPjrctATjrd5pEVeXdheJCSjRJ/45imgEEmZ7+YZY8OYZ1seImD7fSGL4E9j9L/A688pi3FZbtlJJ+LLiAuTbDpUskZAVljbzH8eehKYeYygyo+aysp7RZtT6eXUsIzH7ewbnTiIehjeusWKn9OphDP5PlHkz5zCqGmOwUBXjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkErQR2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkErQR2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A406CC2BD01;
	Mon, 23 Mar 2026 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278879;
	bh=UfneRwN8TikomASAENpG1HkB6Fnhsf6+aRza4DY9hIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkErQR2qftlxiMIDPKwDKQQmTDkCyzfx1cB6ILFbHYcxGeHiH4q/lA+or5ZEd1XCn
	 88HgRbVct24fFaTuW58veNzDAly3Cnaz5NInLTHOB9SPHZfqNnPhA8jWEuQUFCNJp/
	 L4l+l5rxuaZoeowcq7yYrxfuctpupUtUDw4ZslHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 447/567] s390/xor: Fix xor_xc_2() inline assembly constraints
Date: Mon, 23 Mar 2026 14:46:07 +0100
Message-ID: <20260323134545.037826160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -29,8 +29,8 @@ static void xor_xc_2(unsigned long bytes
 		"	j	3f\n"
 		"2:	xc	0(1,%1),0(%2)\n"
 		"3:\n"
-		: : "d" (bytes), "a" (p1), "a" (p2)
-		: "0", "1", "cc", "memory");
+		: "+d" (bytes), "+a" (p1), "+a" (p2)
+		: : "0", "1", "cc", "memory");
 }
 
 static void xor_xc_3(unsigned long bytes, unsigned long * __restrict p1,


