Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA8C26A087;
	Tue,  8 Apr 2025 12:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115351; cv=none; b=Pm1E7W7Un4Otw2vYZbbB68EEdWZIhRZbVCJiHiYgC1WzcNuF9edda41Jufzqsj7UmTDsbplmhtRRy3bh/inb1xp9VxfyUZSa5sbQ8j7lvhYPIk7yNSZqLujMS/C3KGGQreosEO942OQYYR2N/oe/kdXp+YbXhvfE+3SqMP2bcck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115351; c=relaxed/simple;
	bh=2XOkP3TyCvlb16Q4S0xo76rtwLv1cIJWIwHrCKgO24E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJMY/DKBpv4SmWBpY+osBn8Sz0+KZyfKag6jRQGez2fnsNcjH8xNA8oYEQ8kAVek78ksFv14bK85M6JAoormgz5ekRIj6Jeqi2Hp3cpgtcPd4aCCYwW+Lemb3yO3pjkHLuBpGX4+Wa8XC1cbWDE1LYmo8cnbtTbQ3mbXyNoAjZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+svyk6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+svyk6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346B8C4CEEA;
	Tue,  8 Apr 2025 12:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115351;
	bh=2XOkP3TyCvlb16Q4S0xo76rtwLv1cIJWIwHrCKgO24E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+svyk6rP9WtjHzq9/EzQyJgHutfdi6R716DofLIZ+UrHFFrFOfQkpqxlUvcsMF2z
	 NP0EOXLgu5pSYonytzNlmZXukFjL5d/L0vrly8OegMfhwF0JCbAd3Wc+b+TluL508H
	 2i/t11vffHHSgUtPpQfLT3qnDB0SIBWAVLwMyQqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.13 442/499] x86/microcode/AMD: Fix __apply_microcode_amd()s return value
Date: Tue,  8 Apr 2025 12:50:54 +0200
Message-ID: <20250408104902.250140563@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit 31ab12df723543047c3fc19cb8f8c4498ec6267f upstream.

When verify_sha256_digest() fails, __apply_microcode_amd() should propagate
the failure by returning false (and not -1 which is promoted to true).

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250327230503.1850368-2-boris.ostrovsky@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -600,7 +600,7 @@ static bool __apply_microcode_amd(struct
 	unsigned long p_addr = (unsigned long)&mc->hdr.data_code;
 
 	if (!verify_sha256_digest(mc->hdr.patch_id, *cur_rev, (const u8 *)p_addr, psize))
-		return -1;
+		return false;
 
 	native_wrmsrl(MSR_AMD64_PATCH_LOADER, p_addr);
 


