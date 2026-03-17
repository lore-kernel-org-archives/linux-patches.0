Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15C0346AC6;
	Tue, 17 Mar 2026 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766617; cv=none; b=VdZkosYIAh9FYB10ErUH84ZKEVi2SDTkI2RDIJyXwycdrO+jLZXN4uweZZ8d199hQRY3c+c0h2OKOZ/YcXAVcknAHTDfjz/Lr8bcPQLcfbriA7cNLOCwGnxKFkapfI5CzLW24eI7TUC9RIEy6DXD+4UajUOWIRejLn//Xs2NNtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766617; c=relaxed/simple;
	bh=5OctUbxMFZYQd5ez5iKojxcvG/G2/XGm8Q6ZeEO6dd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+LYE3TCGot/X19W04+gbb7eizk8ZR5S8vBbbI23yd4LOHL7Cad7WfFBM3baJKmMsdFNNfIURTaw7a9BLSUROnlmEXMhplEk5pusCr9xV6odI9n+mQcz2OV+etULabef8mfecUpPD0nXi5v/zq2Y8lWfpWntHmi2cvrqrnbGc0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEBLH230; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEBLH230"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD23C19424;
	Tue, 17 Mar 2026 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766616;
	bh=5OctUbxMFZYQd5ez5iKojxcvG/G2/XGm8Q6ZeEO6dd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEBLH2303VP4sR4lpmiuQ366EkKvZ8mwJiBIifyUJpq1mN7+32+hW1VxPb4Fg3C/9
	 xBM6sgaXfURC4p01mj9wAwWVesUZHX1drb0AIyO0vOpCygj1plR8rJIcYSSSw6y1x5
	 163ZgfxTAS8gEYujH0HBWPbs8Hq2mts2JrGXbvhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.19 285/378] s390/xor: Fix xor_xc_2() inline assembly constraints
Date: Tue, 17 Mar 2026 17:34:02 +0100
Message-ID: <20260317163017.488863697@linuxfoundation.org>
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


