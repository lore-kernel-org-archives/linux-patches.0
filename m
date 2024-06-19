Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0541F4D9EA;
	Wed, 19 Jun 2024 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803395; cv=none; b=twREF7J7aKWdubegETO9VhnWIvpZ1Y05cGhdhzpbFhr6Q/+FRibk+p4cCDL4Ie2R5ZmxsIBbYuGnW16tQjNdJdjfnV3/7aHov+SYl5nD8wMdfLnFafvD1hFiyI8QZ7H6Kmex+RToSLX8zn4WU3WOQmVOISae/vC6PTv/WcnZEmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803395; c=relaxed/simple;
	bh=YoanIqUjafiqNHYOSbe7KqP8pSLezbGkoQkkfdp5UWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTXElviMjfCTgsOGuH3R4D89qn28mZ9fPLIdOjK5d0PsbLxIykHa3tdZvOSPiPGyUZZtSM5s7Ygr0nX26gchsbyCaOqqc1WcqJqiNhFbmioN7kye63FcRMNE7z8X2gds/ATw8u5CnEqnPMbS7qrl22B8QZuwFB2fwlaXAduIJhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IyrJgHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IyrJgHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3767DC2BBFC;
	Wed, 19 Jun 2024 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803394;
	bh=YoanIqUjafiqNHYOSbe7KqP8pSLezbGkoQkkfdp5UWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IyrJgHn/UfFrSKlBHgUi1gA7jk+OKmKOobEtu0JVV91Fvk8tiybZXNgD1xXOx3pc
	 4fvhfNtawCha6F3ZJyGfLfz74O2cXNzhY82naXhk0KbM5KsWtQpng40aNJC4ss2BMZ
	 /wox68k6/3lqVgu4CFfPXbYtsoZJX/VZw5Hb6Irk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.9 253/281] riscv: force PAGE_SIZE linear mapping if debug_pagealloc is enabled
Date: Wed, 19 Jun 2024 14:56:52 +0200
Message-ID: <20240619125619.714166665@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit c67ddf59ac44adc60649730bf8347e37c516b001 upstream.

debug_pagealloc is a debug feature which clears the valid bit in page table
entry for freed pages to detect illegal accesses to freed memory.

For this feature to work, virtual mapping must have PAGE_SIZE resolution.
(No, we cannot map with huge pages and split them only when needed; because
pages can be allocated/freed in atomic context and page splitting cannot be
done in atomic context)

Force linear mapping to use small pages if debug_pagealloc is enabled.

Note that it is not necessary to force the entire linear mapping, but only
those that are given to memory allocator. Some parts of memory can keep
using huge page mapping (for example, kernel's executable code). But these
parts are minority, so keep it simple. This is just a debug feature, some
extra overhead should be acceptable.

Fixes: 5fde3db5eb02 ("riscv: add ARCH_SUPPORTS_DEBUG_PAGEALLOC support")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/2e391fa6c6f9b3fcf1b41cefbace02ee4ab4bf59.1715750938.git.namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -669,6 +669,9 @@ void __init create_pgd_mapping(pgd_t *pg
 static uintptr_t __init best_map_size(phys_addr_t pa, uintptr_t va,
 				      phys_addr_t size)
 {
+	if (debug_pagealloc_enabled())
+		return PAGE_SIZE;
+
 	if (pgtable_l5_enabled &&
 	    !(pa & (P4D_SIZE - 1)) && !(va & (P4D_SIZE - 1)) && size >= P4D_SIZE)
 		return P4D_SIZE;


