Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E233321F3F;
	Mon, 18 Aug 2025 13:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522989; cv=none; b=NY3/gv/IUX8r/X39mNESe20p95rBkSnKZG2HZX5ABavGuAp80w23zVoUPOUrrBPkRxxp2GDVR2xhAtP/a1ss7R/sRdVisuuMOnogML9lyH9P/VYVlA5eT5orLQIakVSIrZ/ThOME4MJ/CtmfM9KpRBVuyPb1tAqgJxIXeO0WauE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522989; c=relaxed/simple;
	bh=+xYW7sx+M4qyZM/B28F/m2v3c7lfz3ySfCx9ZFcYZT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIJEr+dvdU44nLFcManwAk/RA5tsboGlexyQ+jN4ZTnD1v4Vusrc5njmUDCPgEce9rWlEt3Sv544hsx4R7TCdyyFLm7wPhUNUpmqPuCxCwaJAl4esCUFoUF9r5o1reygaIZJJD7cLQ44+mP/e1R42SsAhFs+ShcfP2FeraUm2rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdyX45UM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdyX45UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B553EC4CEEB;
	Mon, 18 Aug 2025 13:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522989;
	bh=+xYW7sx+M4qyZM/B28F/m2v3c7lfz3ySfCx9ZFcYZT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdyX45UMmZTSE8Z0s+FQJtwJXiYiO2UchE/zyy+ChhzASWeuUx3KE8fd6NupWtCBL
	 ozH4dyW3iiK0ejqBrmZG7qCfjjo3SDK0oM3/DD7+Y+dWXK6nEKeu9hZ9JNWbbRVuR/
	 PYg+KQnGdwIys+8bzmYX3xc74Ceq+765Zr3ArfT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 036/515] LoongArch: Make relocate_new_kernel_size be a .quad value
Date: Mon, 18 Aug 2025 14:40:22 +0200
Message-ID: <20250818124459.834654857@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit a1a81b5477196ca1290b367404a461e046e647d5 upstream.

Now relocate_new_kernel_size is a .long value, which means 32bit, so its
high 32bit is undefined. This causes memcpy((void *)reboot_code_buffer,
relocate_new_kernel, relocate_new_kernel_size) in machine_kexec_prepare()
access out of range memories in some cases, and then end up with an ADE
exception.

So make relocate_new_kernel_size be a .quad value, which means 64bit, to
avoid such errors.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/relocate_kernel.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/relocate_kernel.S
+++ b/arch/loongarch/kernel/relocate_kernel.S
@@ -109,4 +109,4 @@ SYM_CODE_END(kexec_smp_wait)
 relocate_new_kernel_end:
 
 	.section ".data"
-SYM_DATA(relocate_new_kernel_size, .long relocate_new_kernel_end - relocate_new_kernel)
+SYM_DATA(relocate_new_kernel_size, .quad relocate_new_kernel_end - relocate_new_kernel)


