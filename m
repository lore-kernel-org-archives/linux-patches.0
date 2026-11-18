Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038049;
	b=H7eNzvN7O//7Mx+dc5cEX6iuDuqXeEOnOFmwcuoGx/ehKGZcBG0k2F3ohfmzwIJL/QLw
	 U4KMTFsxEH1sbj8S3zPZin01neq9WC70llhVxddFAeI9Y4db/+6ziBrW3kk/sdPbV4l6x
	 0OX40u4WDzxRDatGU21Cm6GkT+SwwkojhqzAKSjGDUycjZEms0Uw0pFgB7vw8LjucDF3U
	 v6wRHcL6ieQMWk4bummZ4i1k40wOD7oAC0KgBXfM5FouyMagFvdY5QGmpfUIM42S1yanm
	 jy3tptsUybmOfLh68qUmYLxN7C4kV4aKkWL2wW4iU7MV7x5jB/XcpNg8z8RcLcwAVrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yK/fJ9WFyb/nfLMFcRF5GbMMgzEeLLshWZVVzIdifQE=;
	b=T+la8+vQqHDD30DLV1TYSaRSbAf/cRWKCkhvf+2c3PSUSt2V/wnnBc0a/sN+FoWSH6Qr
	 HOosBOBAEGrkJqIzvGka+wxZsoBCTTqxkDcQgGTCzp/Me4F4uTWfISKRselM/vo1LHSdi
	 YRrTincmYIvoN5n3R6Xod0eK4LcxOdWcpt6g53Wpv/haPtkPQU/qTvnzCU8rfp9C7wvA5
	 XSnjimtpDsf/+xSnpu9ihUmkNKr9+68JrXEFUT7updVrSsXfRVh184xMXgrMoz/DMA1Gk
	 AV4mUVcgl5t4htyArhbjpggCujI3YsQKXLeQS2FIFeMP5IEW+/pxRYCt5r0W6gPCCMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHXHzQav;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A10560A2603;
	Wed, 18 Nov 2026 21:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHXHzQav
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C4F1F000C5;
	Wed, 18 Nov 2026 21:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038049;
	bh=yK/fJ9WFyb/nfLMFcRF5GbMMgzEeLLshWZVVzIdifQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHXHzQavC2BFQa413DHlAZAdMSZrmrArfTDGwwU67hNimRazty1eXiYQ+/3fWpEQG
	 MwDfsavuAcsKIXOdQMx14IYrf/2ZwROjJKoMwDM1s3T8R3m0iNN5G+y7MxLdtkSpGh
	 DSfZn8x4kXw7zSO0SA1NDIFeK9IxSuf7RAmq4SyE=
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
Subject: [PATCH 6.6 1565/3318] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Wed, 18 Nov 2026 15:36:27 +0100
Message-ID: <20261118150407.989990014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a11a6e14ba89f..c3883808270e2 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -123,6 +123,8 @@ int load_other_segments(struct kimage *image,
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



