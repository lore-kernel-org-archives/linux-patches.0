Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046539;
	b=k0RoFyleCYQRbuJjw5bEJKKedjcbIhWSEWfSqttoULVd5JH+Ku8iR6WBPlOtUIbGkfrC
	 p2jqVupHHcyjQyvDspDJt2svDOk/6IVYzdx7OrUxgg4MXWTgIylplOh+hazeKbzkqXl+Y
	 3JyO0AR/IbNxjJMYJvfEI6WLAplS+Bvo9Mts37s+CSu3B5WODNrZ8TDD1eju8kgI8I8vZ
	 ZrKTKGhH2RcjXqrMi3/P0G7usWQNWTZ8BByYGP5nw0ZtlbpIaV0ghoSJet7Lt7wVf9MwI
	 t6v54JhKUvWHQeElxuScPEgXENUyE5VobNigEXMSf4zpLRtGgBxBA+VVyJUPt+baJ+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qvz5i3p6LZdCK+sMUiRQPFpy6KD+wKBJVep44bhkxWE=;
	b=BkFoulgdp0MxVTHl4C3iRk9XN/qW7pvluQmguysmzso59OIeWW11/2tZMaaFrFWXt4Xn
	 jbutwI45kQRDH0hXi9GvOnyn+5udqad24g6WpgshEPccN+ZCwWngq9bEPI8WfRQXUuaKd
	 dgI1LIAvioO/CI5fCJt4+GVRnDrb9aqiTgpTtWfEEiTS1+vPW0evNn+IFl7c8WzoutwkI
	 boEvOlnHHBSekLBEfMuBwOp8+Y617Ue7WA+j/S39sHnIZ+kNYiqlitIGTGIg5LNuoVQY0
	 CmNzJ41IYrhMywGg1T0NaJ/W+qiaa/Sx7672VLQSx87tjPNHIFFcHQZRf8cbaTBSEvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2yJDUew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F7F606A334;
	Thu, 19 Nov 2026 00:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2yJDUew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832A51F000C4;
	Thu, 19 Nov 2026 00:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046539;
	bh=qvz5i3p6LZdCK+sMUiRQPFpy6KD+wKBJVep44bhkxWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2yJDUewojCoJZ53AEqIYvzvPaBIR5+9Jl0milWL0cdXtl8zciZzcfw0nIZkvAfBY
	 qAlBwS6vG2TEynuWkmWLYS7AN1PAKSQXmNTUdnEG91ATMYsaBn/aAVM9a25R0yf/T/
	 jCFa3SLrBDmn8yEGRbfW3molZX9leASUYlET9ZZ4=
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
Subject: [PATCH 6.1 1317/2857] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Wed, 18 Nov 2026 15:39:11 +0100
Message-ID: <20261118150248.870309535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



