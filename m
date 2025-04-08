Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820D126A0EA;
	Tue,  8 Apr 2025 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113690; cv=none; b=mM6yLsSw0JJFCWJqejAuKL4mdcL2FAfKXpf5bSuuW7CME3VdmjVUQ/d1XGacfgkfMlf/uUOBpIWZ+sn89lEd6ZDhY6y039MpMlIGMm7hoSnFPCoAQBr5VVUIh87DLuVsOCLhJOjIBxf/KQLgIsqxkHJp/qhvzHBQQTZ6MrDyzlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113690; c=relaxed/simple;
	bh=TACpO9qeZTnGK2Oe8POEFrFi7e4ftCWCKR2iRfysiLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI+/X/pemn9MPCeVLSC+c9SExu4CDNxb6mRQPY+dgvs4acXrTiibMLnxCKDYrFTfAL4tyFEE+uQJsq0fOC5JG7qvZUBiO7P1BxmSe+ZCYhAmBMNQ+85bv7zwQXu8+at+2JCtOpGs2c9G3LpTXPnL/127FmM4M9IfYInJ7glRE2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ok6wLYUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ok6wLYUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A91C4CEE5;
	Tue,  8 Apr 2025 12:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113690;
	bh=TACpO9qeZTnGK2Oe8POEFrFi7e4ftCWCKR2iRfysiLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ok6wLYUA9wxe0XfcEL5RFp3J1dkQEBMuDC4gQrwtTXHkaQT3avn3wT3wslJ4QSz1p
	 3y9sXwVnDWG4RNU3PalLL1n8uajWuAHR7/zu5zZDwjysigoCfoL/4cf+jCiGmiuPl4
	 OmtcP2K1PwEJ4goJ3osBimYaZXvgZumSeCLbnXdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 236/268] x86/microcode/AMD: Fix __apply_microcode_amd()s return value
Date: Tue,  8 Apr 2025 12:50:47 +0200
Message-ID: <20250408104834.953239608@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -603,7 +603,7 @@ static bool __apply_microcode_amd(struct
 	unsigned long p_addr = (unsigned long)&mc->hdr.data_code;
 
 	if (!verify_sha256_digest(mc->hdr.patch_id, *cur_rev, (const u8 *)p_addr, psize))
-		return -1;
+		return false;
 
 	native_wrmsrl(MSR_AMD64_PATCH_LOADER, p_addr);
 


