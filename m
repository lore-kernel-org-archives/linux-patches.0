Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58F54756C7;
	Fri,  7 Aug 2026 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116959; cv=none; b=V7IK9B1BSo4e5+kJiwC8nDJgS8LzjvnZv4KF2+Ouh4KuotW2g7lI0xiLeoOkqfRMYOrbHVLFk0rPNpccBc52PLsr97Op/ILVLogmDl/SM1pUkQh9CKSJLcatHGo4Qo4tNeVcC1/n+LCXQ9I+2SknCbdEbqnNtc1jeDnvQuuGBT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116959; c=relaxed/simple;
	bh=BN4Jj1RNgEA6Gv9z1oV2N68hd/07SuqCnbiUAp+j3fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=susx0MEUbytnxi+GXfbMY2BDrfioij98X1c1iPGoiWcTEKMMXalGSg5ozMV8xuUnRnOltP50zxU3ER2/cMWpRKNkPm+4NqW3o3RsVOCq+CJXkeXIqBwAUFec0ydMA6dDFRM2iSA0NM+KUENLPm92U+6thp3VJO+30Tzs1ToeEN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWkH8S2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWkH8S2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B491F000E9;
	Fri,  7 Aug 2026 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116957;
	bh=kuqZ62Cf98Voqw/ujM68tfUACPmGNTvRulHgpQRpJ9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWkH8S2IOfNr+ViKcJQgYsSkwDia5xisV0wtOl7mBN3PxXix0yjk7opDfU5Hg2D/Q
	 Uva1Kis8PKFhEVn1boDRRgetHmYjRDWxc/0U5XU20KPTfRdBCLQTAhRNBeRSHVHWyX
	 i15N0hUmEUGjiUspllfGiOg6mG+LJDZHwm9KRRTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 149/438] x86/boot: Add volatile, clobbers and zero-length test in memcmp()
Date: Fri,  7 Aug 2026 16:35:45 +0200
Message-ID: <20260807143431.185572831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauricio Faria de Oliveira <mfo@igalia.com>

[ Upstream commit a8c171c107c0b61a5e7e10cedab0fb72aeaf640d ]

Add the volatile qualifier and clobbers parameter to prevent bugs with
instruction reordering and optimization.

Also add TEST for the zero-length case to set ZF, as, if the count register
is zero, the REPE prefix does not run the CMPSB instruction, leaving the ZF
flag undetermined.

  [ bp: Add a comment about the len==0 case. ]

Fixes: 62bd0337d0c4 ("Top header file for new x86 setup code")
Closes: https://sashiko.dev/#/patchset/20260701-pvh-kasan-inline-v6-0-ba99045dfa9f%40igalia.com
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/all/20260721-pvh-kasan-inline-v7-2-38979a50cef0@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/string.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index b25c6a9303b73..3a2bba7c25e9d 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -32,8 +32,15 @@
 int memcmp(const void *s1, const void *s2, size_t len)
 {
 	bool diff;
-	asm("repe cmpsb"
-	    : "=@ccnz" (diff), "+D" (s1), "+S" (s2), "+c" (len));
+
+	/*
+	 * Make sure ZF is properly set in the len==0 case because in it,
+	 * RCX==0 and the REPE; CMPSB won't get executed.
+	 */
+	asm volatile("test %3, %3\n\t"
+		     "repe cmpsb"
+		     : "=@ccnz" (diff), "+D" (s1), "+S" (s2), "+c" (len)
+		     : : "cc", "memory");
 	return diff;
 }
 
-- 
2.53.0



