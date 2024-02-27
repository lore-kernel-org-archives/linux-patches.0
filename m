Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ACC13B2AC;
	Tue, 27 Feb 2024 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040785; cv=none; b=AEK5A9gJQ0xgmxJUx9tt7kpQhI+cefhO2AZPTWcuoGtFzn/CJupeMNecFq3HisKpTuNS/ZiDTV3tXUUj4OT/0EjKJ4+4rb1Fu/2n8akaqCfzMSmL8Jwksg999KD8KjA2Uo+yELZ8jx9bY+bL4+lFSe9og4eOO7JFaxUogHVtZS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040785; c=relaxed/simple;
	bh=TZO12brkz2oLsxcjpQYe7EUJQdoL4hn+QXLne44rXS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GclnCI+zec7vvQZSuuCkUXx94/ZTW2b94Dix9A81ZhkSl7ARbVMg9Bccb2UXd4XPqcMbhpXXQGSqWtSd7V14M7vCsScHEpYFgMYdl/kbp15aIceMmi7XW2MtkoGBr39jzCKMChA0dFbPN7jwAmxA9UIItTMUUz7YtekTv6RuQrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/DIOvXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/DIOvXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17FAC433F1;
	Tue, 27 Feb 2024 13:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040785;
	bh=TZO12brkz2oLsxcjpQYe7EUJQdoL4hn+QXLne44rXS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/DIOvXWJC4o2R+RGwnX4LsXrieHbquTlf/XD1HWmL7YQGIsyulDoUDbI1qQ5/KV7
	 MQ3mF5xOu/OatfqxrrACfjkZL9IYJIpSt/hbn2smsNrp5wqYJQ8WNvAkMfMhQunwOI
	 OZIPb3KIdUh3r1pq8W8NyKQF6H0Q2AHasc3oTw4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@rivosinc.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 107/334] efi: runtime: Fix potential overflow of soft-reserved region size
Date: Tue, 27 Feb 2024 14:19:25 +0100
Message-ID: <20240227131633.936443879@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Bresticker <abrestic@rivosinc.com>

[ Upstream commit de1034b38a346ef6be25fe8792f5d1e0684d5ff4 ]

md_size will have been narrowed if we have >= 4GB worth of pages in a
soft-reserved region.

Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/arm-runtime.c   | 2 +-
 drivers/firmware/efi/riscv-runtime.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 83f5bb57fa4c4..83092d93f36a6 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -107,7 +107,7 @@ static int __init arm_enable_runtime_services(void)
 		efi_memory_desc_t *md;
 
 		for_each_efi_memory_desc(md) {
-			int md_size = md->num_pages << EFI_PAGE_SHIFT;
+			u64 md_size = md->num_pages << EFI_PAGE_SHIFT;
 			struct resource *res;
 
 			if (!(md->attribute & EFI_MEMORY_SP))
diff --git a/drivers/firmware/efi/riscv-runtime.c b/drivers/firmware/efi/riscv-runtime.c
index 09525fb5c240e..01f0f90ea4183 100644
--- a/drivers/firmware/efi/riscv-runtime.c
+++ b/drivers/firmware/efi/riscv-runtime.c
@@ -85,7 +85,7 @@ static int __init riscv_enable_runtime_services(void)
 		efi_memory_desc_t *md;
 
 		for_each_efi_memory_desc(md) {
-			int md_size = md->num_pages << EFI_PAGE_SHIFT;
+			u64 md_size = md->num_pages << EFI_PAGE_SHIFT;
 			struct resource *res;
 
 			if (!(md->attribute & EFI_MEMORY_SP))
-- 
2.43.0



