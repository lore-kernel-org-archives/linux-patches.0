Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885F234F49F;
	Wed,  3 Dec 2025 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778091; cv=none; b=BMZYAPgP3xYTqTTJktoLgiocD521QnIBHUPzQt16TWsobSWhxRsw9m7zCcZ5NHPXfSnQiNF+Q3PLUXacxigO3K9779Fsw5XCp3gCtN/VWEJETmZSde3p2zKAFtPzhfrEF+sb5EeNuQSn/lpx80XiMx0QWeeNC21y0AKfjZXbtl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778091; c=relaxed/simple;
	bh=HZv0MeEdyyG3Kb02Q0PRfJYzhbOhoCp3opoULliwxZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHWgAkGJmB0RYC0SBvkPlZJc6Rhu6XxYG3FgXxnB35YrLJyOyolX1TDFDShKDen7+Ips/ipjWmIReyQlQo2G3ugJwdVgZ6xqHoabK0hompKkQXSKFCcSMPXU2C9aijLzeGkHiDhp/rN9x3j0ehls4My0EUpGATn69DjV4zqDD94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8wfBOSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8wfBOSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DC1C116B1;
	Wed,  3 Dec 2025 16:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778091;
	bh=HZv0MeEdyyG3Kb02Q0PRfJYzhbOhoCp3opoULliwxZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8wfBOSCmEFfjhpn4o2+LrhP3ujBOIPsIeRmNpf3WnYNgKp5vXQpKAoJmAmDeoZv5
	 vL/U82tO1Hs9ZRqJbdwLA8IwLyLWivuZb+aRnUQ/k8/Id7wdxGQCIAsMkcoHZYiT/g
	 zjulpvHsbu/pGdTefoIc3PVkzgeX4WpTMNiyfLXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josephine Pfeiffer <hi@josie.lol>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/392] riscv: ptdump: use seq_puts() in pt_dump_seq_puts() macro
Date: Wed,  3 Dec 2025 16:25:58 +0100
Message-ID: <20251203152421.726006087@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 830e7de65e3a3..d36273704b213 100644
--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -22,7 +22,7 @@
 #define pt_dump_seq_puts(m, fmt)	\
 ({					\
 	if (m)				\
-		seq_printf(m, fmt);	\
+		seq_puts(m, fmt);	\
 })
 
 /*
-- 
2.51.0



