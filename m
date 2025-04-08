Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D527935B;
	Tue,  8 Apr 2025 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117061; cv=none; b=I378qOD+lge9l6piaCFJ8AG6pa3eN2d/7Mw8vQ6PNIjFQTrKgEZ1jmhz80BPaamCS0u+wbHVgJlnz0gEY9yglM5JSBiDPSiXYplYAH/IusqApKQJ9qHS/lB2vLxD9GFU1kACoPMzH7nz8i89oNoZLi6I9gM3Xd8KDrtNRSGG9dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117061; c=relaxed/simple;
	bh=aVlVpnbuf3LLREPjR3W9Dk7pfNgs98O2KOZOIueSoXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcHWn7QMM9j44JJ7qNG3flx5lcBPhzSs3Jg/1R3hP39P49kQhAk5X6SlevGeVjhLe+30TgGfy7TGMRJoa4wPJZR/DD7jEfcYtAkT+BARCYEBqX5vVCdbg3Hdc1g7VBwHZ4tAPQrCTpUuqilccsU+tr46ph8h8tuvPBCvoLysH00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVobBxb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVobBxb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04821C4CEE5;
	Tue,  8 Apr 2025 12:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117061;
	bh=aVlVpnbuf3LLREPjR3W9Dk7pfNgs98O2KOZOIueSoXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVobBxb/nyZpaT0PXyh7aEY7iHnd63Rn/ofz2HsufmRYpgVQODIZzhK7wIHB89kqT
	 cZgqS9XYV3qD3EeOI0CmUKySRofvWoWxg29f/pZKUjZ9Uhhir9ZTpXQhLXVJdV01f7
	 vjuzqIoNE/DPw+opjfk4d5yrbojARm3YJfU8nIVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 370/423] x86/microcode/AMD: Fix __apply_microcode_amd()s return value
Date: Tue,  8 Apr 2025 12:51:36 +0200
Message-ID: <20250408104854.486392470@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


