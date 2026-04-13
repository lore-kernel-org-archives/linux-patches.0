Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF3731714B;
	Mon, 13 Apr 2026 16:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098998; cv=none; b=ufLHpHqU6OH/zbCXNkkfsHmaKSX3VLzm+BiaVsomwJROBNJYKsaXyLjv3DVVM0BFHNbs7cbrPn7CFJRjg5z+7468gXQukh1iZ5nNMxlCAtcY/yDwvlcDxTZWRh+fVkpekzJQSMQjsBRAqmhCVg+Sr/8Ip4clwCjQ5ga9PFl2ytU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098998; c=relaxed/simple;
	bh=HOUz5dxKfePz+oHtXWRExLSc+IMuU8GVg2XvqYAL4Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJvANuFSUyCufeUANfeIrueQ6kieGQQ52gBNxaBr8DXay3/ACOuU2Wb3AoKkwnA+FXV3Y2v0D09Co3xZqhT/Gy9gg+KbXuY7VZSLTtiazNrHekCPkAXNuxoeJyCpr85rGjcvdEjb06JibCzJdoCVZ9bDcizZS3wk0QAj5olDFW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZkWeTp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZkWeTp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83B6C2BCAF;
	Mon, 13 Apr 2026 16:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098998;
	bh=HOUz5dxKfePz+oHtXWRExLSc+IMuU8GVg2XvqYAL4Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZkWeTp8CRej7F994CMapNQglI11ayQO89F8xSIPSsU8r0J5Rhko8UWNdLhO2vVZt
	 M5bXr8iV1B0Wgx4GqIREiC5O+9ilCiYl6GDEUr0hsyP5VeB7DA0N/OC7VmzbyWDU72
	 ismptm1MaOGUYPyxj+fpHS0UsYWI8BW349xk4NRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 169/491] s390/xor: Fix xor_xc_2() inline assembly constraints
Date: Mon, 13 Apr 2026 17:56:54 +0200
Message-ID: <20260413155825.370513060@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit f775276edc0c505dc0f782773796c189f31a1123 ]

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
 		"3:\n"
-		: : "d" (bytes), "a" (p1), "a" (p2)
-		: "0", "1", "cc", "memory");
+		: "+d" (bytes), "+a" (p1), "+a" (p2)
+		: : "0", "1", "cc", "memory");
 }
 
 static void xor_xc_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,


