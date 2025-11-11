Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5C3491F3;
	Tue, 11 Nov 2025 01:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825326; cv=none; b=Wfset+pZI8tZXz5YQseduQEsW68ACHby4rZ2g+ngr2UGrc46JLv2A0pQGRIgZKvvXpQ6SuikKDQACH7DsM7/XxEwKnnC9jO5sIVvAiAyJAH4eneLE83ZG+bwvoumP87ClWqOpmh/vGlXzR808nc26J17pjzkVYxcy/s2XCDf5SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825326; c=relaxed/simple;
	bh=nV9Fod1rFIxsRqi7DCVG0Q8/ZBKArjarv08p/n/dCvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnw6+js11fEhxw0qGaCxwtirvmg9RqPcSbsdw5iN81HXc89ZGVX97TpdXVt40g598xPaN//jC8XinbzGT4z0sMsI8c7UhMK8aQR1EXy149vm3WLj8dKjNtXRgz1YhtjRgr5jgW91eh5bu17uM52OcDDPqVSeF9/LWooMUeOwHAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZpUeMJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZpUeMJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1A3C116D0;
	Tue, 11 Nov 2025 01:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825326;
	bh=nV9Fod1rFIxsRqi7DCVG0Q8/ZBKArjarv08p/n/dCvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZpUeMJ6PXERmr3+3iHiltAMLa1aOwbaeELUTaa+qy7MNWJG9PPBGu/ujoxuLkXQd
	 BU4CuV6sXPxznPyw8NRNd3GgxP+oCeYh0/FU3fWId43Cc0ccAA2W5EZ/4LEnBHlzm1
	 mtSkYnvVl4dpSbP/AlMW6WqjUIZww9jJRaI7DOlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josephine Pfeiffer <hi@josie.lol>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 753/849] riscv: ptdump: use seq_puts() in pt_dump_seq_puts() macro
Date: Tue, 11 Nov 2025 09:45:23 +0900
Message-ID: <20251111004554.636507674@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 3b51690cc8760..34299c2b231f1 100644
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



