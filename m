Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591267;
	b=rG2rGOR+FT9aFPfV7WFrcXXaRgN3JkeyGdgWJ7xfdwD0d9CkiH54d9bqhS/T9xvEcsF/
	 ChyolfL6E9h6auhQLdf8ntqv3IfasThN4qsQFU1hoNHdeEGblAIy/XSUv4xSjfRYx3cRA
	 plBgQVcji73GbP+Px4dcscxmueFXJnYyJlpD4DQ1/Y0an1byjETIb/RE8gku0MqshQEah
	 MB8KkJYsa8OmjXKvJQ9so8BM0epdGHhfkMTwS9lVxtwft2u7ItxpXDxBoi8aFbV0iyFh8
	 hPIfCsXM9bJmoFa8M2io3CtJRs6AVs5k6A4foS6BKT8kJL4dmJowgKkbSh/nTSN8yQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BQc/EifJBJuKYpZtWXEnyqmxvhI1zh/xKP92FYFTkOY=;
	b=L1ddxw1dKI6nApy3kNwPSkGlYfRbVteIJtyRgL4g6dP5moyrzM7DED9JXBgIbMjiu/qW
	 kCu32TedwP5lKlEo9jszFQkMwm2EsGvP2T1qqJB72tkNBsWgc0jRyoerQ1HtEGfAb348x
	 CCoQloQwb7dwkr+Hn+fWfLq2RGu0OT7d6UCOlnGuVIJ5glI7ZM4uoq96SJUtEphMcRvkU
	 vutkSk1gyEH08GsnoeuVJandzDVyGqqjvUu7dtlkXUtcRV/2PyiAZrmxyfJlh2zsx9Uoc
	 TEtDQgdlkFtPmzM7cRFgwfLJA1bKqgAEXBEeOq7T5D9wPE1iXf83jveMMH0U/2/zKUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CxH9/ly5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6C76076FAA;
	Fri, 13 Nov 2026 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CxH9/ly5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFE71F000C4;
	Fri, 13 Nov 2026 17:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591267;
	bh=BQc/EifJBJuKYpZtWXEnyqmxvhI1zh/xKP92FYFTkOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxH9/ly5/Fitd/2vPUBCfKsEGp98kq3by4O6zcay3EnL7+y+N2i/oU72JgNviN3AH
	 24PdMI2ql+X72dnaJ0o1JbLNujhUsZeNt0TzNLpl7zboDO++xLM9GwWqgqSL3IfUvl
	 FQeSCRgw/r3B7qqOgxpt3VPCfQsE4m1/0TNtDMHM=
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
Subject: [PATCH 6.12 391/670] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Fri, 13 Nov 2026 10:49:15 -0500
Message-ID: <20261113153825.006047610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index af1ca875c52ce..dc6948967cebe 100644
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



