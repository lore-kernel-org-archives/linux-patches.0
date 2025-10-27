Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3EE31E0E4;
	Mon, 27 Oct 2025 18:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591104; cv=none; b=D89MuMa4Hh2jU9be6Pyh7NLT68Fq5su84XrwjSYcWgHG2C2/QRFj9ACtTdMj5ZFA2ROD/RRawxLeaJy6veV/qbvJN/1Cyqvrgt/AE/otLrq1EIuL+/n+MgYLbvFFxypeYsoqKnWwgyazNlvb4cxefTqR60mX+7RzV4NBjFbiOKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591104; c=relaxed/simple;
	bh=uG3B+w1wrubvPyhFD7/lZvx5pvwDV7mHCwBejWiH3oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bhN9nHyhllZsGCOBxr1KF8bihLFcSrkYv0TYPX0s7bp68SxTHfzj9v1kRB/RFcZvIsTEScP4UNZWnFmEddFESUUWlm1IbnFqgIXwYcTdeS5Pr4OaHn/YNlSoGolpvv9zdd7ORXu3qvaccFxUWpoINBXObDeAsyj/qpfyWXTDkVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiC0eoUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiC0eoUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2121EC4CEF1;
	Mon, 27 Oct 2025 18:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591104;
	bh=uG3B+w1wrubvPyhFD7/lZvx5pvwDV7mHCwBejWiH3oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiC0eoUR354JmPXcAYXkHWKQVkqi6Q3rrH62cwlFh0DAVvhoKjv2Pwzbvjq0TtKyO
	 eaUpZGolNlPwRxQMemzpbs7Fkrq/jM7O760/COYY56bgbM0dIbmieVnXb9hi9HB84l
	 mpKz7bjQ9b6GR8iPmdF1XnGsHbc5U9JhS9wJjmY8=
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
Subject: [PATCH 5.10 068/332] sparc: fix accurate exception reporting in copy_{from_to}_user for UltraSPARC
Date: Mon, 27 Oct 2025 19:32:01 +0100
Message-ID: <20251027183526.411661857@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a6f4ee3918977..021b94a383d13 100644
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



