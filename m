Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEC1AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71AEC433D2;
	Wed,  4 Jan 2023 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849583;
	bh=Ie+kFT30Johcs70dbWFu+DNJjw+GlYWzTYMBIcNXcfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzMM/UpmRRFKbvtcS0Fy3Vb/+Thmuw39Yei0gW9O/C9Ms6yvLvsxbO9cCDGpj27we
	 R1fktoqxBW+/H8enQQgSTRK82ARVt/MSVtkJW/xr7IGc5gbNS8c0gkme0ceVDnfSy4
	 j08drs31707AX7NCUZivuSrSKUhTfAkBtH8rh0FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH 6.0 123/177] parisc: Drop PMD_SHIFT from calculation in pgtable.h
Date: Wed,  4 Jan 2023 17:06:54 +0100
Message-Id: <20230104160511.369379900@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit fe94cb1a614d2df2764d49ac959d8b7e4cb98e15 upstream.

PMD_SHIFT isn't defined if CONFIG_PGTABLE_LEVELS == 3, and as
such the kernel test robot found this warning:

 In file included from include/linux/pgtable.h:6,
                  from arch/parisc/kernel/head.S:23:
 arch/parisc/include/asm/pgtable.h:169:32: warning: "PMD_SHIFT" is not defined, evaluates to 0 [-Wundef]
     169 | #if (KERNEL_INITIAL_ORDER) >= (PMD_SHIFT)

Avoid the warning by using PLD_SHIFT and BITS_PER_PTE.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org> # 6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/pgtable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index ecd028854469..68ae77069d23 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -166,8 +166,8 @@ extern void __update_cache(pte_t pte);
 
 /* This calculates the number of initial pages we need for the initial
  * page tables */
-#if (KERNEL_INITIAL_ORDER) >= (PMD_SHIFT)
-# define PT_INITIAL	(1 << (KERNEL_INITIAL_ORDER - PMD_SHIFT))
+#if (KERNEL_INITIAL_ORDER) >= (PLD_SHIFT + BITS_PER_PTE)
+# define PT_INITIAL	(1 << (KERNEL_INITIAL_ORDER - PLD_SHIFT - BITS_PER_PTE))
 #else
 # define PT_INITIAL	(1)  /* all initial PTEs fit into one page */
 #endif
-- 
2.39.0



