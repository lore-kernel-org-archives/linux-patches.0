Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982B96FB1;
	Tue,  5 Dec 2023 03:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G27ShXi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E24C433C8;
	Tue,  5 Dec 2023 03:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747118;
	bh=1JUG6VhzMG86lyvJJ0ZHGqL3mL/JeHg9jfxGsmAgR/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G27ShXi8jFJ+HcL2OUovismlQpMIj7FHwRXNcBV6LMVm4YcMrZHgTF6dRZ92PFHFO
	 DeqYOFOWy5SCX8lzcMMv8ShGXNfK5ymQaIIBNFYQ8DD3blj2778GKJIl6tyxcHQBA/
	 GUfTfpWT+OeIEBDt9SEcNMaPHyH3oudtQQTkZEA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 041/107] parisc: Mark jump_table naturally aligned
Date: Tue,  5 Dec 2023 12:16:16 +0900
Message-ID: <20231205031533.969677313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 07eecff8ae78df7f28800484d31337e1f9bfca3a upstream.

The jump_table stores two 32-bit words and one 32- (on 32-bit kernel)
or one 64-bit word (on 64-bit kernel).
Ensure that the last word is always 64-bit aligned on a 64-bit kernel
by aligning the whole structure on sizeof(long).

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/jump_label.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/jump_label.h b/arch/parisc/include/asm/jump_label.h
index af2a598bc0f8..94428798b6aa 100644
--- a/arch/parisc/include/asm/jump_label.h
+++ b/arch/parisc/include/asm/jump_label.h
@@ -15,10 +15,12 @@ static __always_inline bool arch_static_branch(struct static_key *key, bool bran
 	asm_volatile_goto("1:\n\t"
 		 "nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".align %1\n\t"
 		 ".word 1b - ., %l[l_yes] - .\n\t"
 		 __stringify(ASM_ULONG_INSN) " %c0 - .\n\t"
 		 ".popsection\n\t"
-		 : :  "i" (&((char *)key)[branch]) :  : l_yes);
+		 : : "i" (&((char *)key)[branch]), "i" (sizeof(long))
+		 : : l_yes);
 
 	return false;
 l_yes:
@@ -30,10 +32,12 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key, bool
 	asm_volatile_goto("1:\n\t"
 		 "b,n %l[l_yes]\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".align %1\n\t"
 		 ".word 1b - ., %l[l_yes] - .\n\t"
 		 __stringify(ASM_ULONG_INSN) " %c0 - .\n\t"
 		 ".popsection\n\t"
-		 : :  "i" (&((char *)key)[branch]) :  : l_yes);
+		 : : "i" (&((char *)key)[branch]), "i" (sizeof(long))
+		 : : l_yes);
 
 	return false;
 l_yes:
-- 
2.43.0



