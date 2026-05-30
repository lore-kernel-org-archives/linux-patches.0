Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D6A21B191;
	Sat, 30 May 2026 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162979; cv=none; b=nlgBpZZjkwZOpzH9iyOGs55nEZlmj7GeH+TYEvZt+1j8sALMCjMwOtnxLfqUb5IYm79nOVnw30cgY+jYJdiAQpfFM0pTszSv1t10L09tKREcj/R5N5uM4Gqu6wQWZdjtb6n0E/TiM/L8lo3Arq+AOTYsWrTPwRh4RkxjRuzX2mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162979; c=relaxed/simple;
	bh=hW5/nO3GhSEtRoo0k2Q8Hrgl3yjkcQ89bx0amtCvZ4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rliymRYofg+jeNHa+aK92sL6NDKsvdoJdRB/QTyP8hfzCW+3vbtz7bKDcvXch71hLLPFYoE7VBstiqj8k9lkVK5pJcxQWh4O+/cy8NtCh1EEttDe+KcEYCvMkHCCOZPaFm0IVKJbvT27OagkUER8exao+5LXXwDStYznKZwOBCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYVNUFnV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYVNUFnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FEB1F00893;
	Sat, 30 May 2026 17:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162978;
	bh=B6hapUauOa+KNOX1O1IDG6O/4vBl+wKa2CNjH1KRTZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYVNUFnVd5p+RnSNi8eE3bNxAp2+8WpnNERcdyKHSnUAvKzozIKqzUOHsOfbWPn4Q
	 EZqydDHsHtf0b2TvPDljejM2jqWiSkyH6BRgEFvPmpAm8yO89odvsM0wZLhrf99Mt/
	 P+TbeWf/SFhGv4B6l7uoDQqY6qpt81K5xAQwa4Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 121/776] s390/xor: Fix xor_xc_2() inline assembly constraints
Date: Sat, 30 May 2026 17:57:15 +0200
Message-ID: <20260530160243.503440262@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 		"3:\n"
-		: : "d" (bytes), "a" (p1), "a" (p2)
-		: "0", "1", "cc", "memory");
+		: "+d" (bytes), "+a" (p1), "+a" (p2)
+		: : "0", "1", "cc", "memory");
 }
 
 static void xor_xc_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,


