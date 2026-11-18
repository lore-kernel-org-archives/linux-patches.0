Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060139;
	b=HhUZ2DFSI4dN2DTP0EANlCd73iSDcHzhi3fnL4ED/vPxU9Dd7SIjDbQmnem6aH3iYxXw
	 1VuQyzKAbpNWXvn3j2n0EgUk1eafmQihZIfoPsEqGfIxVbAFAeEpik69A7bdqcZA8tg/c
	 tiEd9T5PoqRLph/S1vTikOLUtyPZV2Qq19zFfIgcbQBHamTuz3YBONxN9bMiX9kUneNzs
	 /VUPwmrO2RvpPLisdwTORi6RloaUiExDokNU4bGQn7q6oa9opheLFNMiJx7VGerBLInxq
	 ZmjbVSlvtln0Cq3v4YyE9zs1K1Scltd6Bo3WnvFv3A/KFN7CJASvhwMjs9wQeBQDqUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hGdYcmNtfUzfrjOjK+ozoIZLSbdVYZ15dXPCQLnv8A8=;
	b=lqKsVUUF+iDIoaC27PfAzrGJb0Iq/nnt6QaE+uHBhQzSa5We6MD9WhCzXggAxtzB3vEk
	 Pk0AeEJzKsLi3PReUhMABf+trEUhGep+e4RRJw8yo9p4jKGSIJBOOkR2x0UbrUfR7JxrX
	 bOkcUweuJRhT+u0BUFDMFZ9li7+ylm81oYnPGJUnqTEm8lVP+NIIc7VmsJ9NbLq8meNQN
	 tzLTIVCEOlZaDzfvMMARFlYVhWRYaRPUUd7kBIOzwMAHBjnXQkaIQ0BqqWV8fB9wlUdBb
	 2yo6RGR2rNF5rjXOwth+J4rV4HBQxYy5YaXUY9txkKnNtVqu7Giy17Y+rtwzDKo/tfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlLao8UH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289C8606A325;
	Thu, 19 Nov 2026 03:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlLao8UH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C7E1F000C4;
	Thu, 19 Nov 2026 03:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060139;
	bh=hGdYcmNtfUzfrjOjK+ozoIZLSbdVYZ15dXPCQLnv8A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlLao8UHO5DrC8P54EH0hRuUgQ4ocMV1h1l8aqQWEAoiBWqjIYjniu2/xYu2Lg1O7
	 LzC0g3TilcCW1iSCszb5iw77mQJoptJZ7HanNzoj9/KFoeiQMBH7GcwPMrjTneybn1
	 6Z7lsTFvaDvcPJ16PWEHVehBfjk0Ta1tssaekCp0=
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
Subject: [PATCH 5.10 1091/1848] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Wed, 18 Nov 2026 15:52:09 +0100
Message-ID: <20261118150004.439013420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Changed the vfree() argument from image->elf_headers to image->arch.elf_headers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec_file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 0cde47a63bebf..1226d665a5872 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -284,6 +284,8 @@ int load_other_segments(struct kimage *image,
 			vfree(headers);
 			goto out_err;
 		}
+
+		vfree(image->arch.elf_headers);
 		image->arch.elf_headers = headers;
 		image->arch.elf_headers_mem = kbuf.mem;
 		image->arch.elf_headers_sz = headers_sz;
-- 
2.53.0



