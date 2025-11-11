Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DC126B76A;
	Tue, 11 Nov 2025 01:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824740; cv=none; b=c4dDgqeHuKaVwiMcjJKgzTbBq00irNwXakGRC1YutfDAG//5Mnx5fj+9Qudh9nzVreW9sH4GPq1t/10TwTpPO2X4zn8jzDoLt2xn33LxRoMLqn3krlBJ72egZYyCxgfv+9qrG53bSm5lt2ZAMKbO0gx9izxa/KxIukrrn9AojW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824740; c=relaxed/simple;
	bh=sp32J9Yxe24P3hFGAU4jSFUfFBuiNjPNw8yybqdLfjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiQWMDbcE2m49byBirQawK0L0Bu68BTS1+9pB61I4mbQeBMltmaHFeRUis9dh4Z9sFRwZAP0SAzCs1PBpFCqJZ/Mbx/ugw0DQo0wRvgcrPKSVGpriP6KjXTU4bM/0YleFTDPW+gHhEDqTij3xuWYqhkVyIAjq06EW6fCfdMRfoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSupIcm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSupIcm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7013C19422;
	Tue, 11 Nov 2025 01:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824740;
	bh=sp32J9Yxe24P3hFGAU4jSFUfFBuiNjPNw8yybqdLfjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSupIcm+jhJArqJud/QbTJmubt4/iz+plxSYrEV2zPLzgYIUDuvK1K9cQfbLYpz5G
	 lxq0jf1GyZRHR8FV4Zr3Bt2ljMjTev3ATNCPiwL3suGfSOJQDZ0c3q4A/espDNikkz
	 9qe4RlHbTSHNN1ByEpOpEUzu/DXh5VMu4zaGIE6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josephine Pfeiffer <hi@josie.lol>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 508/565] riscv: ptdump: use seq_puts() in pt_dump_seq_puts() macro
Date: Tue, 11 Nov 2025 09:46:04 +0900
Message-ID: <20251111004538.377621443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Josephine Pfeiffer <hi@josie.lol>

[ Upstream commit a74f038fa50e0d33b740f44f862fe856f16de6a8 ]

The pt_dump_seq_puts() macro incorrectly uses seq_printf() instead of
seq_puts(). This is both a performance issue and conceptually wrong,
as the macro name suggests plain string output (puts) but the
implementation uses formatted output (printf).

The macro is used in ptdump.c:301 to output a newline character. Using
seq_printf() adds unnecessary overhead for format string parsing when
outputting this constant string.

This bug was introduced in commit 59c4da8640cc ("riscv: Add support to
dump the kernel page tables") in 2020, which copied the implementation
pattern from other architectures that had the same bug.

Fixes: 59c4da8640cc ("riscv: Add support to dump the kernel page tables")
Signed-off-by: Josephine Pfeiffer <hi@josie.lol>
Link: https://lore.kernel.org/r/20251018170451.3355496-1-hi@josie.lol
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/ptdump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/ptdump.c b/arch/riscv/mm/ptdump.c
index 1289cc6d3700c..4bb09cadfb858 100644
--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -21,7 +21,7 @@
 #define pt_dump_seq_puts(m, fmt)	\
 ({					\
 	if (m)				\
-		seq_printf(m, fmt);	\
+		seq_puts(m, fmt);	\
 })
 
 /*
-- 
2.51.0



