Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585850;
	b=3eRqy/wDTVqM/Ueba11uKz1Ol1UCZWMuqDcj+uaE6ixBVkFMnWQn+t03TKSN1JEUFmZ0
	 rlfR/ILNV9SMBEZlzF+zNwFJvQ9KDot2BHm9k8DcbUZRbZm8CC3AX//Pw81gwe5NcPhZh
	 s6Rqq5GZrbC+sFk1fVyzCPJ3PoyB/MSCrpTsS7jjZbbnZ85zP/GwFD5cGp6VqAzQH+vTp
	 na55H9NTZUvvxd8YkqIddKno/s7gNbiL2yd4MRJ5E1cIMqioDG1tul6C+buKvlul3nKT+
	 332nmWIzBQPfTpJ2TnASc5xkJGekj2+NCV6aORxblaGp2vcXTAPKiL1GPyrKF30dBrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zmEIlOpUgqJyPMPF90YyoqDiywhuFo7wbNuLT57EKr8=;
	b=hIE51MfRmsCnv4pZjncXD2oFtQxZbdcfSKYTN3t2lgmRz91pLQKKN+8TB8BXlsD/1pHw
	 EbI/W161C2Mz39ABioZZYFYQ6n8tmpE1m1Crgpjyg0AxHAPhj3wYYrclKC/o1pE7Q84y+
	 187Nh4suZU9qV0mw1t5qvXWmi/a2Want+5TjMfv9Niw48UTnyVmXEd2di3DTBznna4aC/
	 GXCZTo/obDUwe/UrKbIgnSUvUSx7uOnJartmcBsKT+B5DjIqOLNdlvvLAoJUfGlF378Iw
	 b40f1EXWAmHJI2xQ8sQkvLJnIYzrdIrYaQhisp3ZQyCbWHjTJncSVfrhsAr5Y8tKSYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnX+SVVr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA27606D2E1;
	Fri, 13 Nov 2026 16:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnX+SVVr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31AC1F000C4;
	Fri, 13 Nov 2026 16:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585850;
	bh=zmEIlOpUgqJyPMPF90YyoqDiywhuFo7wbNuLT57EKr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnX+SVVrWOrMtClMjfslC61txPx3hEohuJhOPksQhnjPMJ16F/oocbHD3ofLJUDS3
	 Db5TlqEqYCzdGzO7aC9DN1CobhI4MxK84bO61as1aNmComNhGrNKVPPvrAZKCJCDYi
	 pXH+3IZee+l0e9MIraPAPF7p2mHf+WZLvPr0EbbE=
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
Subject: [PATCH 7.3 427/507] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Fri, 13 Nov 2026 10:52:11 -0500
Message-ID: <20261113153811.220113751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 854d872dfd0f5..14f453dd09465 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -112,6 +112,8 @@ int load_other_segments(struct kimage *image,
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



