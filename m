Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6A6248F71;
	Mon, 12 May 2025 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071123; cv=none; b=Kjuna7X12+e9rwT4K3WjVN03LtKZyBAPKMfxYEV1CLh9XT2oM8944dJpl4CJ5OP8ogUcpJOIToxLL/HHqhFHtBN/bQCv8azpfchijGlyN65H7/jAIB9EZz8nf/0sw2D3GjcMs2AULdPGOAH6ZxgYrqJfFBooLQq17P81AwiS1V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071123; c=relaxed/simple;
	bh=tw+LOiRADbVpvkEXQR5i4TIsvzRW1hjuRiQsn1hyAfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzqOYeYrIgUlSWPSoD8/d8XLHefK0YTMudUHIcdVfu/hX47EnTLd3OJ0vM1YwfqRn8V4ywMeCXkkjjm1OaaXo5FtdTQ2CwtmISqD3h8biSwehTXQTJ7rlcKwZxjYw9UZONQrM4H+7TZRsVS4P2RiINFJ0lC52lIYplsqOv4V6D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxyTMLvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxyTMLvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0002C4CEE9;
	Mon, 12 May 2025 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071123;
	bh=tw+LOiRADbVpvkEXQR5i4TIsvzRW1hjuRiQsn1hyAfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxyTMLvGb0N65zRYzftdGgOPZkbcRYGAlZs5DYSlMAGZYtAnCw5p1tS1J+hp5akIp
	 izIRs7AMEObMvzQN7JFy52lDEDHWFXuWXr9LBPKGY3KMtM7CUzABkAogOH3pKdrA67
	 Is3ulwvUWDEh9Gx+KkESL5kUcrcqRbeCnlUT66KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/54] MIPS: Fix MAX_REG_OFFSET
Date: Mon, 12 May 2025 19:29:59 +0200
Message-ID: <20250512172017.535178081@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c44572e0cc13c9afff83fd333135a0aa9b27ba26 ]

Fix MAX_REG_OFFSET to point to the last register in 'pt_regs' and not to
the marker itself, which could allow regs_get_register() to return an
invalid offset.

Fixes: 40e084a506eb ("MIPS: Add uprobes support.")
Suggested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/ptrace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index 428b9f1cf1de2..b1da249dcd71c 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -65,7 +65,8 @@ static inline void instruction_pointer_set(struct pt_regs *regs,
 
 /* Query offset/name of register from its name/offset */
 extern int regs_query_register_offset(const char *name);
-#define MAX_REG_OFFSET (offsetof(struct pt_regs, __last))
+#define MAX_REG_OFFSET \
+	(offsetof(struct pt_regs, __last) - sizeof(unsigned long))
 
 /**
  * regs_get_register() - get register value from its offset
-- 
2.39.5



