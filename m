Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9E7C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FACC433C0;
	Mon, 26 Jun 2023 18:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804883;
	bh=VYLH5n8IPeIldbYbhbsNlQ1X+8ADqiCq0EGLs32y/6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E95AijEAL/K+H+yer8VhA8pHFly90c4/gg5vA43gnu6VkSZqMzLvz5YF9m+OW6U75
	 9fGInAqcNVxb3GNLQXN37BOjPzQWFLMNbYWgKJ0OwAAFvJz3Bka1B3lQwKwHWYhRCP
	 ydmwLBIvOXnYjGyp4jUmxr1Zf3tKT//ia6O7dI24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 36/96] x86/mm: Avoid using set_pgd() outside of real PGD pages
Date: Mon, 26 Jun 2023 20:11:51 +0200
Message-ID: <20230626180748.459708552@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee@kernel.org>

commit d082d48737c75d2b3cc1f972b8c8674c25131534 upstream.

KPTI keeps around two PGDs: one for userspace and another for the
kernel. Among other things, set_pgd() contains infrastructure to
ensure that updates to the kernel PGD are reflected in the user PGD
as well.

One side-effect of this is that set_pgd() expects to be passed whole
pages.  Unfortunately, init_trampoline_kaslr() passes in a single entry:
'trampoline_pgd_entry'.

When KPTI is on, set_pgd() will update 'trampoline_pgd_entry' (an
8-Byte globally stored [.bss] variable) and will then proceed to
replicate that value into the non-existent neighboring user page
(located +4k away), leading to the corruption of other global [.bss]
stored variables.

Fix it by directly assigning 'trampoline_pgd_entry' and avoiding
set_pgd().

[ dhansen: tweak subject and changelog ]

Fixes: 0925dda5962e ("x86/mm/KASLR: Use only one PUD entry for real mode trampoline")
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/20230614163859.924309-1-lee@kernel.org/g
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/kaslr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -172,10 +172,10 @@ void __meminit init_trampoline_kaslr(voi
 		set_p4d(p4d_tramp,
 			__p4d(_KERNPG_TABLE | __pa(pud_page_tramp)));
 
-		set_pgd(&trampoline_pgd_entry,
-			__pgd(_KERNPG_TABLE | __pa(p4d_page_tramp)));
+		trampoline_pgd_entry =
+			__pgd(_KERNPG_TABLE | __pa(p4d_page_tramp));
 	} else {
-		set_pgd(&trampoline_pgd_entry,
-			__pgd(_KERNPG_TABLE | __pa(pud_page_tramp)));
+		trampoline_pgd_entry =
+			__pgd(_KERNPG_TABLE | __pa(pud_page_tramp));
 	}
 }


