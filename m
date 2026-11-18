Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053468;
	b=AwnYA/YRMh7QUWR5glhAcbf0WkQHLx3b/djbfyao6/AwV971JJxzIysM652LCXVxCepi
	 WAPXF62XOlpL9TJ2Tj9ksMhZvmi6T+fRjE5Qu7zIItVdojjE+7vvSNq8zIt6GR/lkmWx9
	 E1FFQsNLFbI2rs7cqV20eWLtS743wQ9eM12t1ecibmvkq3i7bSrEWOCmGavQerb9yuKqE
	 Y4aDIxzyMwb8p7ppz0nR+jLWRYX1b/Zga7sKByw/hlWXZSXVNDTrLihr1+VWTDg3/qGfk
	 nLDSjsXfSPaQoHH9hub+LjjovNRBzw3HDhDu9kCoa9APGwDfGlzWy29T5dvTq/PQMRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=988qUJzD4lKSzSuhqa7hiOhW24LxiHBUacc9LidhWCU=;
	b=ckvFRP+6njYzTGysiryNmRArpmfHNP2S2tbB/ZSSFvDeEHMKDDKwk3nmMKMxAHA4uk9+
	 po/Rghy+aEl0s7O6c2X2iaUMeIrxWX2ECwa+JI9H7V9r/w+Rq6US85wlNMDhU8rEdzMxE
	 qPKc/NuIqvRxK+aMC81+ZeM4d1yslyMe7cr8dx/MRTlclAE4R99yAb3euhzw1KDllqPjr
	 /xwh+hnR8Oe9eGQGYxhzpBm+zLPInNGa8tqWimOkhbKpg6XyxHw/pP/B16hblKdkWZKO6
	 YeFQaZKMFpmhsgLApP5RYaBYIadsL29MhepOVTYanmtIrrHgqTyUGFhT51Y2jYcdcfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdv+2738;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F04606A31C;
	Thu, 19 Nov 2026 01:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdv+2738
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842301F000C4;
	Thu, 19 Nov 2026 01:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053468;
	bh=988qUJzD4lKSzSuhqa7hiOhW24LxiHBUacc9LidhWCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdv+2738hi0EsQ3Yv5MwFipsgXfDxxMvqkNkTfDaHRAlBmQvzbcs0R/L4C8iPvgTC
	 YzRgX8szbsqPkAOR2G3eiQbvBmFk/DgMpSa65H9+ykqxxljC711gXajMSRyW7Ag6T4
	 9n1lDVbpRTnaxwfLGmebY8WOl0H9x6pJYR3sTL3U=
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
Subject: [PATCH 5.15 0929/2214] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Wed, 18 Nov 2026 15:43:25 +0100
Message-ID: <20261118150049.521120505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 59c648d518488..ea0314523669f 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -115,6 +115,8 @@ int load_other_segments(struct kimage *image,
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



