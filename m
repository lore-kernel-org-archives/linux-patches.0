Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A114734CF;
	Fri,  7 Aug 2026 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115015; cv=none; b=i06w6ewLd+PFZS1F8oypZQ6Go4gJ7mSbYRdIGRUIfb5WIPp9VHPuAAgnTQ46y3OFTTDkadFHB/cR8LipaNfzkjYHbKX9PSKR2qeZgHjtbbdBr2GBLSvyOLGnT7V9MCAKiIURBnOGVM3WgnGgs9/obrN2AnuNOFNW//ihBx6GBDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115015; c=relaxed/simple;
	bh=FdveJJh/zzHo2U5QnpMVzvsiw0ua4++b2kr7xVQgscQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHpTaUTQV/c+hGXJpcmagGVFdQjYhLd+XnYubhagwVuNKMqzINSr7laIHIw5F0TvmwyAjfKZlNWYvSO0e1yu2v8zgRnLCLARxmUl8hF/FRbGfAFhpciOxuYPs/nKhlvO/PAm/U+fg4XzRVy2DOFp3MdVoxKka6QIkJYftsbqZP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZAjAdUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZAjAdUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599651F000E9;
	Fri,  7 Aug 2026 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115013;
	bh=ZHA9HcrJ03ol/CKHTo1lMz/zjXt2qgxgDlKgPrb1m/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZAjAdUmbHutMQ3/fOLbvct0rlOakap8xNNUnmj90R6K6+nyzmRWtXI5EPkbu61W5
	 fELc5FnQlG4X5Dw42nE0kcZJrSh9ftVfOJzfIEqVTDPGQpXns1i+MSx+rWDeVx7w8R
	 hDkO9AGEDNzycAiG+yBCaoFTeTn3NKdUj+pLKGFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/396] x86/boot: Add volatile, clobbers and zero-length test in memcmp()
Date: Fri,  7 Aug 2026 16:34:46 +0200
Message-ID: <20260807143427.027197053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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



