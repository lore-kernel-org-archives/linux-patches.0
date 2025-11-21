Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A1A2773F7;
	Fri, 21 Nov 2025 13:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731336; cv=none; b=hzFMGRVowVl0Yn+6AU3Vr+bgw2IPrYcnm4mUcwaJKK/dmZdLMWmQ8wZrtuoaSCrGNg+i1k3UFm4Oc/nkciPhze5ykLlfhrgIu4gNqFk1K5HocwBkaJOfDWCIHpYbEdZdb4RH6sY7BD+hihQNM5Q5OD5qSPazk8WKFK6IH9Ct5+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731336; c=relaxed/simple;
	bh=2a0AZKiIU/BxINWWLr7MAdTE7lydimUHETsKeOGc6C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGvW2fEZ4GBJbECbdZ+6u8q/yG+RVyiwTSEUQlqdRh5RwqAwSU/pkuPyY68A1NPNgLCncSZ7nz6iRUM7naPRRDybuDlXETeXb07sl6X9xlifQF6eUqHj5XkM5OZVE9Ml8ds57mREVmiybDRXotIcEg1iG977MZdTw0pzDyauYF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6ZD+iv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6ZD+iv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90987C4CEF1;
	Fri, 21 Nov 2025 13:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731336;
	bh=2a0AZKiIU/BxINWWLr7MAdTE7lydimUHETsKeOGc6C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6ZD+iv19VrAo7F2XMweZYFhhg1kb8gAhS0C7p/hdduW15v9A/u+pckwIl2aOdX5d
	 lfPRIHXnthsJjHPcuvpsARZLoJ5nQE/2/9baFw1yhJTiln6F183Qgnp04z1O2NljJ/
	 ZBRyd5AnQnd4t18w9FRRhzkEklwmzJn6OYN97BnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 172/247] LoongArch: Use correct accessor to read FWPC/MWPC
Date: Fri, 21 Nov 2025 14:11:59 +0100
Message-ID: <20251121130200.893976916@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit eeeeaafa62ea0cd4b86390f657dc0aea73bff4f5 upstream.

CSR.FWPC and CSR.MWPC are 32bit registers, so use csr_read32() rather
than csr_read64() to read the values of FWPC/MWPC.

Cc: stable@vger.kernel.org
Fixes: edffa33c7bb5a73 ("LoongArch: Add hardware breakpoints/watchpoints support")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/hw_breakpoint.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/include/asm/hw_breakpoint.h
+++ b/arch/loongarch/include/asm/hw_breakpoint.h
@@ -134,13 +134,13 @@ static inline void hw_breakpoint_thread_
 /* Determine number of BRP registers available. */
 static inline int get_num_brps(void)
 {
-	return csr_read64(LOONGARCH_CSR_FWPC) & CSR_FWPC_NUM;
+	return csr_read32(LOONGARCH_CSR_FWPC) & CSR_FWPC_NUM;
 }
 
 /* Determine number of WRP registers available. */
 static inline int get_num_wrps(void)
 {
-	return csr_read64(LOONGARCH_CSR_MWPC) & CSR_MWPC_NUM;
+	return csr_read32(LOONGARCH_CSR_MWPC) & CSR_MWPC_NUM;
 }
 
 #endif	/* __KERNEL__ */


