Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791F950C28B;
	Wed, 30 Sep 2026 17:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789612; cv=none; b=bmo9wwbXoyFtKNT/7d20I5GmNhLxREnWA25iaInkdA2phAjV0vw9BjLkw1BSxWIbkbVIem0T1MA3hXZpAcrQIc0RSyvZQ62FMsu2mdOR2znf7HZz4xgCiihgmkrRlajQQu1nRBLf9zb0vYkSPO1uXZZZmQcKJD7gcZUqjwMos4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789612; c=relaxed/simple;
	bh=jwJ/0KBxIym6rcQwoKxacq9zeOn0Bu878eMhpYGQUyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndhKxPjr2vvWtSO7a74FBQOmBTO/r+O6de5bpUpXoADCQYTXeAjDnsxvKqDsnJhGl6WSSlJ5VnS2L1yfhmKyv7Fbz7Whz4MM7hHzN7IbNwYwr1oQUtxwFOlY3fwICpjNu7p0SJt0IILmK1OZrlrro2I03OJRxULxUrQSHKZBap8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yb3G7JHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yb3G7JHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37CB1F000FF;
	Wed, 30 Sep 2026 17:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789610;
	bh=aygSTNaKFfG9WfTmF1MYEJbZ6LJFgUL5fxql/sC93io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yb3G7JHonDagnfCt8aZl/mrV0FifRAf+Lr2orTLzFSWbfq3Fl8T6/e2aDdRMcVVeD
	 Fy5wrHr7Q8JzzGVZLOfxGRSvq25fksIquUbLx6NsPDaQzJfExZks5ccsHT0ukv0x1q
	 JzNDpsBJun8nql02fW2rxsbvoO8xFnnl0XNgD9/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Chi <tanchi25@mails.ucas.ac.cn>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.12 536/877] RISC-V: KVM: Fix HSM hart status error propagation
Date: Wed, 30 Sep 2026 17:24:07 +0200
Message-ID: <20260930152426.210967525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -106,9 +106,9 @@ static int kvm_sbi_ext_hsm_handler(struc
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


