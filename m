Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CB613B78F;
	Tue, 27 Feb 2024 14:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043348; cv=none; b=oMhkKhfwAU3evaR/4J8aHHiwOFZs7KvPdt6RhIGijN0Q2Ue1eIf7+1T4AGa377B+iZI5V0R01/sCt/YvRxCB5BgjSCV06ZhSghjgWVEYiCng5DVllkpwQ9MjZf+rvAaJuffQ/PCGjR1yqCLSYylkJAMAFo7L+2gkEKQ3Lr5tBsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043348; c=relaxed/simple;
	bh=oOQWcHrudQuPTnJzvVq8n/06mdfTyd/rN4Lc7Mwgi0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkJWxCpmQLbwBTgjK/reL7fkizc8woB/ZN1DQIGXwLiJFWcl0Bbw/iuc2s6nzhJvHp7poxk+nZX7MOOEnn9EkBBh7qaBrGQ7NIxFbxFGSOgS2yCSyXN2yWWLAcUCHSpdjw7YEvx8bHcoqMXMLpLzFWobLuHSd8A1jZNzDS5KMhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YY3creQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YY3creQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF8AC433F1;
	Tue, 27 Feb 2024 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043348;
	bh=oOQWcHrudQuPTnJzvVq8n/06mdfTyd/rN4Lc7Mwgi0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YY3creQvqbqbieceAmZ3rlpH7PTOpMd9C/Ll95aKNtig0v1QnGYPOkVl4c4LP9vvH
	 5/4zRXPAucR6dNWJZ3RGhq64PR7s4l6k0T9g2JCpktW9KNS6ZNG5SQfm8mli0a7daI
	 G+CrAExrJdvddpXyeJpnlP8x/Jdyv/IH973FzMCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@rivosinc.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/195] efi: runtime: Fix potential overflow of soft-reserved region size
Date: Tue, 27 Feb 2024 14:25:29 +0100
Message-ID: <20240227131612.746084413@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7c48c380d722c..1995f0a2e0fc0 100644
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
index d0daacd2c903f..6b142aa35389e 100644
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



