Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6255930BF55;
	Mon, 13 Oct 2025 15:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367776; cv=none; b=LXEgpfoyuzJmQFwm9R8pn1Nv4S9P7eIsLr/V2ftKvNlfH3PWtDLfSgjBBKBgQ4Og/808iohHfAtF609PVR7/0xJqxu4Uv3aBkF6xvAs5VdlQx6HAvhsP71QxlKEWPnFCwULHJowS+Ea+nJRwZACVSFom8zLlWwAg4eUZGHdDU2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367776; c=relaxed/simple;
	bh=Q10lgVH/CWaIyPgIfHEzfV59dHfrtu4SVnjsIM/nz34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gse3QCrMUBu8U+QErvgM6YaiNo95Bx+4+P4HALIPCaJT/57dhRcC/aaznytq8yAROFYAz0l/KMLm01Ic2MyLXh4R/Sy70pRWxk/I3TXg06rmKbuJO6oMq4UvrYULcIRnQijK4Lvkg+p79myjc4GyAiWZtuwgkYGF6ZpgZaFvTkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D61xtA2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D61xtA2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BC4C4CEFE;
	Mon, 13 Oct 2025 15:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367775;
	bh=Q10lgVH/CWaIyPgIfHEzfV59dHfrtu4SVnjsIM/nz34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D61xtA2UFD03+Rc7FmKd8xvpBgC2+UWl16b6WBrdg5T68//T/inEj5bQPcxl1rHMw
	 gfJERe+CpVFdVgJTNaN7G3n0clSPuW0u3NL3dLb0uXpnB0aiZURBWgdzzOqb3ITIcE
	 pE2WH30SvpjNHFe3F4a3tKir1VBO9uC/YQGurwW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactcode.com>,
	Jonathan 'theJPster' Pallant <kernel@thejpster.org.uk>
Subject: [PATCH 6.6 129/196] sparc: fix accurate exception reporting in copy_{from_to}_user for UltraSPARC
Date: Mon, 13 Oct 2025 16:45:20 +0200
Message-ID: <20251013144319.976097416@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

[ Upstream commit 4fba1713001195e59cfc001ff1f2837dab877efb ]

The referenced commit introduced exception handlers on user-space memory
references in copy_from_user and copy_to_user. These handlers return from
the respective function and calculate the remaining bytes left to copy
using the current register contents. This commit fixes a couple of bad
calculations. This will fix the return value of copy_from_user and
copy_to_user in the faulting case. The behaviour of memcpy stays unchanged.

Fixes: cb736fdbb208 ("sparc64: Convert U1copy_{from,to}_user to accurate exception reporting.")
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> # on QEMU 10.0.3
Tested-by: René Rebe <rene@exactcode.com> # on Ultra 5 UltraSparc IIi
Tested-by: Jonathan 'theJPster' Pallant <kernel@thejpster.org.uk> # on Sun Netra T1
Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20250905-memcpy_series-v4-1-1ca72dda195b@mkarcher.dialup.fu-berlin.de
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/lib/U1memcpy.S | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/lib/U1memcpy.S b/arch/sparc/lib/U1memcpy.S
index 635398ec7540e..154fbd35400ca 100644
--- a/arch/sparc/lib/U1memcpy.S
+++ b/arch/sparc/lib/U1memcpy.S
@@ -164,17 +164,18 @@ ENTRY(U1_gs_40_fp)
 	retl
 	 add		%o0, %o2, %o0
 ENDPROC(U1_gs_40_fp)
-ENTRY(U1_g3_0_fp)
-	VISExitHalf
-	retl
-	 add		%g3, %o2, %o0
-ENDPROC(U1_g3_0_fp)
 ENTRY(U1_g3_8_fp)
 	VISExitHalf
 	add		%g3, 8, %g3
 	retl
 	 add		%g3, %o2, %o0
 ENDPROC(U1_g3_8_fp)
+ENTRY(U1_g3_16_fp)
+	VISExitHalf
+	add		%g3, 16, %g3
+	retl
+	 add		%g3, %o2, %o0
+ENDPROC(U1_g3_16_fp)
 ENTRY(U1_o2_0_fp)
 	VISExitHalf
 	retl
@@ -547,18 +548,18 @@ FUNC_NAME:		/* %o0=dst, %o1=src, %o2=len */
 62:	FINISH_VISCHUNK(o0, f44, f46)
 63:	UNEVEN_VISCHUNK_LAST(o0, f46, f0)
 
-93:	EX_LD_FP(LOAD(ldd, %o1, %f2), U1_g3_0_fp)
+93:	EX_LD_FP(LOAD(ldd, %o1, %f2), U1_g3_8_fp)
 	add		%o1, 8, %o1
 	subcc		%g3, 8, %g3
 	faligndata	%f0, %f2, %f8
-	EX_ST_FP(STORE(std, %f8, %o0), U1_g3_8_fp)
+	EX_ST_FP(STORE(std, %f8, %o0), U1_g3_16_fp)
 	bl,pn		%xcc, 95f
 	 add		%o0, 8, %o0
-	EX_LD_FP(LOAD(ldd, %o1, %f0), U1_g3_0_fp)
+	EX_LD_FP(LOAD(ldd, %o1, %f0), U1_g3_8_fp)
 	add		%o1, 8, %o1
 	subcc		%g3, 8, %g3
 	faligndata	%f2, %f0, %f8
-	EX_ST_FP(STORE(std, %f8, %o0), U1_g3_8_fp)
+	EX_ST_FP(STORE(std, %f8, %o0), U1_g3_16_fp)
 	bge,pt		%xcc, 93b
 	 add		%o0, 8, %o0
 
-- 
2.51.0



