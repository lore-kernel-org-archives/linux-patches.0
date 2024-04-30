Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C4A8801;
	Tue, 30 Apr 2024 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475999; cv=none; b=PK0A8x8o56qmZ/vNQPIJwyHwIuZnaDslKdNoeEcOfXEydRigPLgLmq9fZRk+R3Db7LhXjOiZZel7dh6y5qhz6sH9maexqTrLjH7GuZDhA/y+sOKYQ7/e78LImv4FxmOcgu1CHzORsnlqwAUFudxG7FN5zH/Osn9zvaskNGD5akQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475999; c=relaxed/simple;
	bh=dmkHSwigI71YiAkUsRE6+hCkF8pbtD49c7Upj+kDe8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Agph7uDRs8ZIMw2w4a/uYHAqbUnp79vbp+QzrNkQG7NP1N+kZ44x5nvL+ZbwER3st64fdEJj91Johi+XCSXPEs+NgUmUuKas+6UzdOpBjskJxRzYUjL4dGOeH0pqFmsXQ9NMFahIiGDiYkBPM724+bLwRcxddGNE3mppZpZx/tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leQ1sM0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leQ1sM0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EAEC2BBFC;
	Tue, 30 Apr 2024 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475999;
	bh=dmkHSwigI71YiAkUsRE6+hCkF8pbtD49c7Upj+kDe8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leQ1sM0oNEbgMeiwSY/11jy54Qv+84iGSp+AZCA/8i3/nEx3xTZA8eA8LXEuZqRX1
	 t/nl8gNvW/CD+NpvBXK8pryWS2YC0aJ0CVNwapYoLrICDBAi3CbKEKVxAvZuK8iR9p
	 hTwJ4YZ2w9h6UxmqAmcQITMBIc+HkUTLj8uSmh9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Bo Gan <ganboing@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 74/80] riscv: Fix TASK_SIZE on 64-bit NOMMU
Date: Tue, 30 Apr 2024 12:40:46 +0200
Message-ID: <20240430103045.597968654@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 6065e736f82c817c9a597a31ee67f0ce4628e948 ]

On NOMMU, userspace memory can come from anywhere in physical RAM. The
current definition of TASK_SIZE is wrong if any RAM exists above 4G,
causing spurious failures in the userspace access routines.

Fixes: 6bd33e1ece52 ("riscv: add nommu support")
Fixes: c3f896dcf1e4 ("mm: switch the test_vmalloc module to use __vmalloc_node")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Bo Gan <ganboing@gmail.com>
Link: https://lore.kernel.org/r/20240227003630.3634533-2-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 17e22eb76a815..776528fd64050 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -675,7 +675,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 #define PAGE_SHARED		__pgprot(0)
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
-#define TASK_SIZE		0xffffffffUL
+#define TASK_SIZE		_AC(-1, UL)
 #define VMALLOC_START		_AC(0, UL)
 #define VMALLOC_END		TASK_SIZE
 
-- 
2.43.0



