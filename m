Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5D91D042F;
	Wed,  2 Oct 2024 13:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876742; cv=none; b=dOC9MZqH60hDd7EhEGBz9QsbTdts1zgx/iNbu4lF5924ykGAnv0Ddm42peY72P5lwiI5cXCTIW96tEfj4avcI+0/s5wu4cOywA52d4nRTrpX+TYPP7uFqwtCkK7iJ6CAMk9S8mFaORzp4oXOHo6TwwOI+I2FTOhBAQ2ah26JStM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876742; c=relaxed/simple;
	bh=n15GDlzK2VDFFlEK3mkXXJ6vgQ4CrVY6sdKPNFMJfZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qi0R3jPzGh1ctn/Xytrjehn+CUqLEGlbxEVodaOMMmMOjfuNfXh376S29MCl5/xoAh9MLWw76pE1fBKvHWQVKmfwTQ1wbHF3KW0zpZvvawIRfaZemN5iGPpudKXuh3OPw43ebG0YHxTYhdSkKSU9xUqYAvVpT0UYNEINYV6rz3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNzlqq2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNzlqq2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712D8C4CEC2;
	Wed,  2 Oct 2024 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876741;
	bh=n15GDlzK2VDFFlEK3mkXXJ6vgQ4CrVY6sdKPNFMJfZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNzlqq2yvCDVZoRkSkNMgY8MzzSyMiMrhOf+VnzIISwAodKUcu+4G3+AIm+Ndn4Aj
	 llJF7VSZEA1O497XjprtMKYvWZViNtcnCXeBlQV40c+JW/dPLY+clgy/sQC3TigxzZ
	 1CTe+qbdhUhItI4vI+PjbbwnJ0hddJqdEwPaT2KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Frank Min <Frank.Min@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.11 547/695] drm/amdgpu: fix PTE copy corruption for sdma 7
Date: Wed,  2 Oct 2024 14:59:05 +0200
Message-ID: <20241002125844.338828244@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Min <Frank.Min@amd.com>

commit 3cb576bc6dfb8940228b8130638860b631dd428a upstream.

Without setting dcc bit, there is ramdon PTE copy corruption on sdma 7.

so add this bit and update the packet format accordingly.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Frank Min <Frank.Min@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
@@ -1022,13 +1022,16 @@ static void sdma_v7_0_vm_copy_pte(struct
 	unsigned bytes = count * 8;
 
 	ib->ptr[ib->length_dw++] = SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_COPY) |
-		SDMA_PKT_COPY_LINEAR_HEADER_SUB_OP(SDMA_SUBOP_COPY_LINEAR);
+		SDMA_PKT_COPY_LINEAR_HEADER_SUB_OP(SDMA_SUBOP_COPY_LINEAR) |
+		SDMA_PKT_COPY_LINEAR_HEADER_CPV(1);
+
 	ib->ptr[ib->length_dw++] = bytes - 1;
 	ib->ptr[ib->length_dw++] = 0; /* src/dst endian swap */
 	ib->ptr[ib->length_dw++] = lower_32_bits(src);
 	ib->ptr[ib->length_dw++] = upper_32_bits(src);
 	ib->ptr[ib->length_dw++] = lower_32_bits(pe);
 	ib->ptr[ib->length_dw++] = upper_32_bits(pe);
+	ib->ptr[ib->length_dw++] = 0;
 
 }
 
@@ -1631,7 +1634,7 @@ static void sdma_v7_0_set_buffer_funcs(s
 }
 
 static const struct amdgpu_vm_pte_funcs sdma_v7_0_vm_pte_funcs = {
-	.copy_pte_num_dw = 7,
+	.copy_pte_num_dw = 8,
 	.copy_pte = sdma_v7_0_vm_copy_pte,
 	.write_pte = sdma_v7_0_vm_write_pte,
 	.set_pte_pde = sdma_v7_0_vm_set_pte_pde,


