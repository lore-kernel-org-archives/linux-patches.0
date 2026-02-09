Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C479125B2;
	Mon,  9 Feb 2026 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647774; cv=none; b=H16fZTqayO5A9Ickc+5P52tLlq4SHIxMmRqRr94ikjmwiL3ygMFyLgKNzT7DyJ8lnjWcXCMQ/t7Ww1U515Hb8KBf3AMAyXFUQsplaFO7MAOBkpzXqbzPLzeei9RHJTr8mSVvtI5F/EtAEGyGuVGXdK6gRMV/Q5ZekGsUxkQWwWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647774; c=relaxed/simple;
	bh=iQQyQeccomaOLttv2iYnyx4rtnpAl+8/eMgATNtWw0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6sjiCzbzV/zj/NmB/Nq6NWfcTiQEnmHtp2LKv6vqgU4xC18m23eU76zOGi/KpZHH6KkH/6pvzUJvmBKn86XLX/rkenNoYLrNTQqojiqksAhJiZMAnyXSLK3MbvLIz0+G9vx5pyD2hkefxaiX5zpoZ+JsTMjTRr8BS8mDIFACIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUy2wXXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUy2wXXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7B5C116C6;
	Mon,  9 Feb 2026 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647774;
	bh=iQQyQeccomaOLttv2iYnyx4rtnpAl+8/eMgATNtWw0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUy2wXXgQ7TscITkmbuERCwkHWNRvJdxzyaNUk6UpEE5kTz6NXYyckY3+v7iFrHzB
	 eenpkP91csAce7Q3B1o1g0JYfw9alcKiFmgRFPuWTHxOnt81+ioGVj1m6Vf7BfhzNh
	 9c84BMsSpzwuTw4ZelyJZWmUSX8QvV1e25WZIkAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 003/113] x86/kfence: fix booting on 32bit non-PAE systems
Date: Mon,  9 Feb 2026 15:22:32 +0100
Message-ID: <20260209142310.331300876@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 16459fe7e0ca6520a6e8f603de4ccd52b90fd765 upstream.

The original patch inverted the PTE unconditionally to avoid
L1TF-vulnerable PTEs, but Linux doesn't make this adjustment in 2-level
paging.

Adjust the logic to use the flip_protnone_guard() helper, which is a nop
on 2-level paging but inverts the address bits in all other paging modes.

This doesn't matter for the Xen aspect of the original change.  Linux no
longer supports running 32bit PV under Xen, and Xen doesn't support
running any 32bit PV guests without using PAE paging.

Link: https://lkml.kernel.org/r/20260126211046.2096622-1-andrew.cooper3@citrix.com
Fixes: b505f1944535 ("x86/kfence: avoid writing L1TF-vulnerable PTEs")
Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Closes: https://lore.kernel.org/lkml/CAKFNMokwjw68ubYQM9WkzOuH51wLznHpEOMSqtMoV1Rn9JV_gw@mail.gmail.com/
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kfence.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/kfence.h
+++ b/arch/x86/include/asm/kfence.h
@@ -42,7 +42,7 @@ static inline bool kfence_protect_page(u
 {
 	unsigned int level;
 	pte_t *pte = lookup_address(addr, &level);
-	pteval_t val;
+	pteval_t val, new;
 
 	if (WARN_ON(!pte || level != PG_LEVEL_4K))
 		return false;
@@ -57,11 +57,12 @@ static inline bool kfence_protect_page(u
 		return true;
 
 	/*
-	 * Otherwise, invert the entire PTE.  This avoids writing out an
+	 * Otherwise, flip the Present bit, taking care to avoid writing an
 	 * L1TF-vulnerable PTE (not present, without the high address bits
 	 * set).
 	 */
-	set_pte(pte, __pte(~val));
+	new = val ^ _PAGE_PRESENT;
+	set_pte(pte, __pte(flip_protnone_guard(val, new, PTE_PFN_MASK)));
 
 	/*
 	 * If the page was protected (non-present) and we're making it


