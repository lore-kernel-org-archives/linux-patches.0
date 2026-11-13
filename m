Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590531;
	b=sE/f6YRBIc0Gn8mNi8iwW52SOjrZcd8R0nG2OpcBzwVjfzo2MnEjW3zZWlkVybH1kNqf
	 Or/qNuT+2+FafMoTdulglIF1UtlerGbYVIO5edf2gG3cOkb+vOQHLIrLKLODfFm+gJklC
	 2SnCIFcwcWafKrDgFqZMHeCvtnDNGCr7ahOHBocQ7oN1FI7R6C+Y4ZNNKLll3wu6rZKEq
	 r4g+6aej3ccQoO4fUFDD1ZCdFryDl8GjvOJEJFzyg9S0WUATjq5PqMgxZ9ivRXrHPWXjl
	 3ikasZzoKh3cThAWJo6M9hIKxZuC3L6W/kj3VpZTCEGkM24RlMWH5HNxx8jmFWvhwbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p5gGp4UT3iM6rBHZ0QiuoayoE+df9DyHvKKloUPtEE4=;
	b=N15VGTNtTx2eFe/yggHZqUsreQVsJQkI1qzbQHlJ0ol+d7OJBn0K/OdTwoLT13Xpb8V1
	 d2nrZX081eSwcv/TkdxFNwUpgRXEw6R6CgYfsPZvB9axFHYVGFF3B8wbw3Q3TYR75Gnuf
	 UVAPhFFNcmBIL0NRt5L8NUGSIzVnEgQf7PilR/s7lsfAtdOy+Y1CczashXS5rvm+iW/MJ
	 yOBR5u3NwhieecAIZLvRGJrI6TJO7qECRnrd/GWjtsAcwCtLg9PGyyDXPXqlp8qnKjnag
	 AEP1y9TC+oXzccWcqDEIMqBmgZK+4KHGD220sMcNb1cUuYM5lAg05SyD8cZ4GoItf+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDizGnaB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F43606B83C;
	Fri, 13 Nov 2026 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDizGnaB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADE11F000C8;
	Fri, 13 Nov 2026 17:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590531;
	bh=p5gGp4UT3iM6rBHZ0QiuoayoE+df9DyHvKKloUPtEE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDizGnaBoxdiNPbT9O2cM9Zt1vawS+pkedcu1FWqgsqXSsPNDu5G4xt7X1I20Q/sg
	 Av7wUpAmsU+fkz4dhzqbowlVxtje7vkDwIKzyB3Y3AH1o4pS942w35Y6idyJh4aIVf
	 GOqv7yfGC9BkIAAvWs+JDxAQb7uZDXD1ZEGOU+xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 456/686] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Fri, 13 Nov 2026 10:49:49 -0500
Message-ID: <20261113153836.322178481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit ac302aea3d824ccc99f29b8e499c365cb9a684a9 ]

A retry allocates new elf headers and overwrites image->elf_headers,
leaking the previous buffer.

Free it before assigning.

Cc: Will Deacon <will@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 108aa503657e ("arm64: kexec_file: try more regions if loading segments fails")
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
[catalin.marinas@arm.com: drop the redundant NULL check before vfree()]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec_file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 410060ebd86df..2034ca8287a22 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -128,6 +128,8 @@ int load_other_segments(struct kimage *image,
 			vfree(headers);
 			goto out_err;
 		}
+
+		vfree(image->elf_headers);
 		image->elf_headers = headers;
 		image->elf_load_addr = kbuf.mem;
 		image->elf_headers_sz = headers_sz;
-- 
2.53.0



