Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA65E517BA2;
	Wed, 30 Sep 2026 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787957; cv=none; b=tPxBpUFp4nZonSZ5e011uCsRBhSx8ArImU7uyF6yCE6jnpo1jr4at5etvmrkYOsDuvI6AJq1ey+oAvbooutDeiJZeRjs/f+mNxzHnRFYAz2yY2n3jqqzY68SMF9/H7sNujHrQvTniSEtPCrKqxxw11/ZVGIva/C+ZXiD927xljk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787957; c=relaxed/simple;
	bh=kTAqsheR0bjy+gob/alP3sI449Xg9pFTtPbGpAUcnus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOdZ2P2wazPYvW8WYYQZrN2KJOG8mlZovTQfCRcEi2kevDIYmEDNiEzv+Bd5J0R91lVXTlXeoUPn1tFk6kRbyciOWC2rrAiAm4jgPrm719nvDDzJloFgcpBJZ8C/DvAif6qf8qvT1nAawi1HDdHbtAKltoEjQhZDe0fu1vRZy5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pp3NdNu4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pp3NdNu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8941F000FF;
	Wed, 30 Sep 2026 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787955;
	bh=yHpdnGUb8Yw8cWXH2L982VZpZEEXqT3ZiEeh/lR/rS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pp3NdNu4GVpxwB6JWhg/KJekmFXoCA46gwI37Xh4kkPDz7UpaaL/ksdQ1srFoaKok
	 Y90pwP4pTw/pGZzgfgoCd7Ar5YPPl+47c/SgW2rmZXTamgfkcKER6LUIBe+lMbq9kw
	 AIEYLXytt7xj+iS7y9BrR5aRrTatybfrOqnXD63c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Chi <tanchi25@mails.ucas.ac.cn>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 7.2 396/457] RISC-V: KVM: Fix HSM hart status error propagation
Date: Wed, 30 Sep 2026 17:28:21 +0200
Message-ID: <20260930152354.541254707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tan Chi <tanchi25@mails.ucas.ac.cn>

commit 41e81f7e3ef96594fb840445343c0ee7723aa550 upstream.

kvm_sbi_hsm_vcpu_get_status() returns SBI_ERR_INVALID_PARAM when
the requested hart does not exist. However, the HART_STATUS case
returns from the SBI handler without storing this error in
retdata->err_val.

As a result, a guest querying the status of a non-existent hart
observes SBI_SUCCESS instead of SBI_ERR_INVALID_PARAM.

Use the common SBI error handling path for HART_STATUS after
saving a valid hart state in retdata->out_val. This preserves
the returned error when kvm_sbi_hsm_vcpu_get_status() fails.

Fixes: bae0dfd74e01 ("RISC-V: KVM: Modify SBI extension handler to return SBI error code")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tan Chi <tanchi25@mails.ucas.ac.cn>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260914031146.446157-1-tanchi25@mails.ucas.ac.cn
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu_sbi_hsm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -95,9 +95,9 @@ static int kvm_sbi_ext_hsm_handler(struc
 		ret = kvm_sbi_hsm_vcpu_get_status(vcpu);
 		if (ret >= 0) {
 			retdata->out_val = ret;
-			retdata->err_val = 0;
+			ret = 0;
 		}
-		return 0;
+		break;
 	case SBI_EXT_HSM_HART_SUSPEND:
 		switch (lower_32_bits(cp->a0)) {
 		case SBI_HSM_SUSPEND_RET_DEFAULT:


