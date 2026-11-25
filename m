Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623239;
	b=n+iky+rx2fn3GbeV+zeemhNBU6FXpJbxAgaA24t4PS13kNOKOC4+Jlx2YxB8Zh24nCNX
	 9u4DwY+eOA5cOiHgxz8MdQZNsa0+Opb0Z4xjPIZSoxdZppSOhViRdfj53oLyLNKhtrvsB
	 2/plPtBt6EOhPoP8aJwr+dOTPuhJx96zmZGPnZP9qu8u4Qfg0qlAtEx6wzg4wyiLmUGHm
	 DmV/6UufsuQL2cexMEPSdPD3ejRciozPc2dzxba/klWG1cIoHov+6RYtT2j2OLBVL2RDT
	 qHvQVeKebcYu9asb6dtNZp53Z8748sh1YgiexR52bVtkMLF8+HXXTU4+7dTkVgl2PwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/lAPxKhj0ABK3AiU035+JiGamOm+4gUqztW38gAeFIA=;
	b=2zwmSSJspWYu+XL6z5D/Bj4rcF16EQUwuU8/W0WAvh/vvGCYVfxYUyephQ6TlO3Zw4vM
	 b7Hq6DAgKKXr6gFr3AHUW0KvoTDibRlPbU+4kTvftLRHLcprPFGyqmqFF1MFSZ+EYB1we
	 RfICv1stnm/sOnBwOwyMtFScTEUnPE2kmkzfp3AOZlBhnbKKYtJUJ3yQQykKmaNWgVMyx
	 hbtY47kN9AeHU6Tn4foJRGbecGi9WMkiIYN4yXiSVX/Qnq9Ns8sasPScpl84Gsoz3wZiz
	 DrbYv3Ww2k0OViLbIS4xP8AjRyhT64RRqpP2rz1Hmmv3ai7ekyGYK7ezDzvgsH5bwtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAKl+9r4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA85606A323;
	Wed, 25 Nov 2026 16:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAKl+9r4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007601F000CF;
	Wed, 25 Nov 2026 16:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623239;
	bh=/lAPxKhj0ABK3AiU035+JiGamOm+4gUqztW38gAeFIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAKl+9r4Gm9OpCa2054CLGS8ZAPv5wYf4pNbjpL2Ug/fdCUWsUKaYmT8T/5Qn0vrK
	 T0Vf/4c0LpfInDbdowtQ8Y8bDn1MAOHsEQszmKUNK6ckP2ACGi4WDu1gjFpGTnRchb
	 JQevVtTxPeLRFSJL/VFHodbAe4LlcBgALtYenCuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 796/990] LoongArch: kexec_file: Fix elf_headers memory leak in retry loop
Date: Wed, 25 Nov 2026 15:36:03 +0100
Message-ID: <20261125143840.691241235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

commit 065dd1636abef6b9962fd5af82accac69850bbe8 upstream.

A retry allocates new elf headers and overwrites image->elf_headers,
leaking the previous buffer. Free it before assigning here.

Cc: stable@vger.kernel.org
Fixes: 55d990f0084c ("LoongArch: Add EFI binary support for kexec_file")
Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/machine_kexec_file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -182,6 +182,10 @@ int load_other_segments(struct kimage *i
 			vfree(headers);
 			goto out_err;
 		}
+
+		if (unlikely(image->elf_headers))
+			vfree(image->elf_headers);
+
 		image->elf_headers = headers;
 		image->elf_load_addr = kbuf.mem;
 		image->elf_headers_sz = headers_sz;


