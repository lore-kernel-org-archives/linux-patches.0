Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CA641D11F;
	Tue, 13 Oct 2026 12:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894431; cv=none; b=Dfv4XTbl2L9v+slii0iPUKqj7fUCqbZ2FH6WUgS8BX4w9WZS/nSMvJnSAlbjJXFORBQ33V4Nm33TOutrXqYUsgFKtAJ09WmyTu2s91K+p/G3udSnbbFGwGVhI4rW2jcZuAR4hM6e0z43LAtxLzC2DeNym0Hi8H+nYg4LHUvLOKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894431; c=relaxed/simple;
	bh=pvCm+QqefFRR5htKWpIuUBoXgtJCnwe6BORMw4VWyYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SogoGI/ZiBjD4uXvEWg3XoSRGfy3XxBFSj3D96SPSaK238123S7OjyQbD4M7c+VdrknBuyd4Fb96yi40WkEvnZy7dO0axa2jqocqvzG/9KnQm8JCGMRATQ4TIY+kNTvV7cEWKp2NuIVK8LPVWA9b/VrXpZEf0LA9ZBQHCsIuk4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlo2EURl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlo2EURl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0F01F00893;
	Tue, 13 Oct 2026 12:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894430;
	bh=YO5CrfwaaYERcHioRa3MQlioge/IViJKa+ydANKN28o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlo2EURlk72gphFF+qjnEtcaX6tiC020TtBH1aYaIiEJHHfc47zEH/uN2x7rP1xF2
	 Zi6auwwHaCyyOdQRNewdUW7T6R2X7qClAPI0t/rzNwKu5F9VJJF3MvuQxjtKzhXKXH
	 WKhQf+WArMUlZaC2+1ML4LNlW4wdmIsZ4tN2nMO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.dev>,
	"GUO Ren (XuanTie)" <guoren@kernel.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Andy Chiu <tchiu@tenstorrent.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 558/621] riscv: vector: Fix data pointer constraints in context save/restore
Date: Tue, 13 Oct 2026 13:39:13 +0200
Message-ID: <20261013112934.052583134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.dev>

[ Upstream commit 572b25f3a6453d8e7fc28cc0cefe41ed15be166c ]

The standard vector save/restore asm advances datap but declares it as
input-only. An inlined caller reusing the original pointer may therefore
use the advanced address instead.

Declare datap as read-write so the compiler can preserve the original
pointer when needed.

Fixes: 03c3fcd9941a ("riscv: Introduce struct/helpers to save/restore per-task Vector state")
Signed-off-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: GUO Ren (XuanTie) <guoren@kernel.org>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Andy Chiu <tchiu@tenstorrent.com>
Link: https://patch.msgid.link/20260908-riscv-vector-asm-fix-v1-1-147f314efb2b@linux.dev
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/vector.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index b61786d43c205..c612d54846b8d 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -224,7 +224,7 @@ static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *save_to,
 			"add		%1, %1, %0\n\t"
 			"vse8.v		v24, (%1)\n\t"
 			".option pop\n\t"
-			: "=&r" (vl) : "r" (datap) : "memory");
+			: "=&r" (vl), "+r" (datap) : : "memory");
 	}
 	riscv_v_disable();
 }
@@ -260,7 +260,7 @@ static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *restore_
 			"add		%1, %1, %0\n\t"
 			"vle8.v		v24, (%1)\n\t"
 			".option pop\n\t"
-			: "=&r" (vl) : "r" (datap) : "memory");
+			: "=&r" (vl), "+r" (datap) : : "memory");
 	}
 	__vstate_csr_restore(restore_from);
 	riscv_v_disable();
-- 
2.53.0



