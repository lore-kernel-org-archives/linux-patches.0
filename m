Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BABE1DB127;
	Tue,  8 Jul 2025 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994016; cv=none; b=jQRCnx2Wefuq/ZbLA+iNVZX1wqiFJ9RMPIc/pJGI+F0alx6HgcUB0rP7+XUVkC+Om3jhhwEkCDn72UOHsXutZ5ZTk6Zns8ScNKBShPlGTxARUhNsM429rGiSZfBnzd90OjKHmB35HIt4bjSypfegh5Bqx0ZV7sE80fx0E7OQlF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994016; c=relaxed/simple;
	bh=Vln/AmmbcVF0Ucw7i3KlNauP6Z+Ti3LVmQD08X8cjQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwlzidVBuLNJkEZlWAidDimiPOfYZYsMA7xvTvjZazS71qtZOglYfj9sOSg2UpEUoN7ITjNjnONUNuQLYxRrPKApvje09/KC2tfsH8CBnDrqbw0kB5rVSt3yGGK6ikJB8yVyIKg1xEsUEgIPkYms4Fx/fqYvuduW/0ln6lvtP10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7im4tHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7im4tHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ED1C4CEED;
	Tue,  8 Jul 2025 17:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994016;
	bh=Vln/AmmbcVF0Ucw7i3KlNauP6Z+Ti3LVmQD08X8cjQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7im4tHVirDfDIz5rPUPhRG8bgzy6JJwo9IZOd0SwcL85oqCoqhYaB3uP+sprlvCo
	 agSPzs1VxjeB7TRiyFC2qPujBLdHfIJLkcQ4QDRftjm1/LEkzeIJjcixr1qERI+MBT
	 EKI/kxGPDN5+cHpuLFfbAACdcO+Ebf3EoEGZFC4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Oleg Nesterov <oleg@redhat.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.15 096/160] ARM: 9354/1: ptrace: Use bitfield helpers
Date: Tue,  8 Jul 2025 18:22:13 +0200
Message-ID: <20250708162234.165776309@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit b36e78b216e632d90138751e4ff80044de303656 upstream.

The isa_mode() macro extracts two fields, and recombines them into a
single value.

Make this more obvious by using the FIELD_GET() helper, and shifting the
result into its final resting place.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/ptrace.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -10,6 +10,7 @@
 #include <uapi/asm/ptrace.h>
 
 #ifndef __ASSEMBLY__
+#include <linux/bitfield.h>
 #include <linux/types.h>
 
 struct pt_regs {
@@ -35,8 +36,8 @@ struct svc_pt_regs {
 
 #ifndef CONFIG_CPU_V7M
 #define isa_mode(regs) \
-	((((regs)->ARM_cpsr & PSR_J_BIT) >> (__ffs(PSR_J_BIT) - 1)) | \
-	 (((regs)->ARM_cpsr & PSR_T_BIT) >> (__ffs(PSR_T_BIT))))
+	(FIELD_GET(PSR_J_BIT, (regs)->ARM_cpsr) << 1 | \
+	 FIELD_GET(PSR_T_BIT, (regs)->ARM_cpsr))
 #else
 #define isa_mode(regs) 1 /* Thumb */
 #endif


