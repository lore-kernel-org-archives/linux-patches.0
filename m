Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226B630BBBD;
	Tue,  2 Sep 2025 13:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819671; cv=none; b=GSc2nYT/6EqTXZj2Ilz/pl1GVLJRAPWisuXV8MqErHhK5sN0yus54QYJ+pgLdxmCq5uN6NSGfSanBCIC4Aj1R8nzqELgvkFHdnhMd96UeOZgzGjVkxZaf2ZUXaJWPIpe2sp2zx1C8oIO5xEv4FNNXRel+ME2cVVGt5McS5JPDaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819671; c=relaxed/simple;
	bh=kGt/jN+giUl8wS3KvkFpQO9WqWJMbxeF0XG8w4jU0gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BrWuL7W/wkhT1Z+WmTfLjNLFJAduKF124tgUy4Z1rapktg14CuZ+WFtrF7JtR1OVDmqxjtr9cj0h5liYMxkIjHmDAh7WUofUkJ2lM1IsYA+ODMQGthcgfIBfB5bKRYFzXmjpqUFVy8ezoGtc1xSxF72IPgDS4zVaJkUmvGchnnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwDtJ9VM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwDtJ9VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4D7C4CEED;
	Tue,  2 Sep 2025 13:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819671;
	bh=kGt/jN+giUl8wS3KvkFpQO9WqWJMbxeF0XG8w4jU0gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwDtJ9VM+zofQssju0lnCkRGT7R6OtxVxrEgn7Um9zj87/4JZym5n853oiHJtANw9
	 YRF6I/9M+jT2p4pWLnalZQW5j7QK5fwmmaq9SpAV2iKXwsXlxWN/jQekjd5dgv+vph
	 d5bUW11g0VKgdiu2gKYiOTJPohk3IY3aTYJowiDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Nutty Liu <liujingqi@lanxincomputing.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.16 105/142] RISC-V: KVM: fix stack overrun when loading vlenb
Date: Tue,  2 Sep 2025 15:20:07 +0200
Message-ID: <20250902131952.303920784@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radim Krčmář <rkrcmar@ventanamicro.com>

commit 799766208f09f95677a9ab111b93872d414fbad7 upstream.

The userspace load can put up to 2048 bits into an xlen bit stack
buffer.  We want only xlen bits, so check the size beforehand.

Fixes: 2fa290372dfe ("RISC-V: KVM: add 'vlenb' Vector CSR")
Cc: stable@vger.kernel.org
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Link: https://lore.kernel.org/r/20250805104418.196023-4-rkrcmar@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu_vector.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -182,6 +182,8 @@ int kvm_riscv_vcpu_set_reg_vector(struct
 		struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
 		unsigned long reg_val;
 
+		if (reg_size != sizeof(reg_val))
+			return -EINVAL;
 		if (copy_from_user(&reg_val, uaddr, reg_size))
 			return -EFAULT;
 		if (reg_val != cntx->vector.vlenb)


