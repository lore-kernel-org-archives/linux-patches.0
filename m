Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FCBAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEE1C433C1;
	Thu, 27 Oct 2022 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890204;
	bh=MSz3EoNrxWMXoDEjg1U8CjrEvkFOhN38JE/lTI0s24k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJoWOxkpQcvl0wyWCyrkWxTPblt/aW+7SnpTLhEf4PAUAAIcaU7KxrLlLsCPMou9q
	 6P2mzZYEOZrCtcRkDZbT19HyHfiZ9iRY7bcogZnp5dtW6WSBIbFNOdXUHaCbuK0v57
	 9W8c5yOg6f4ConX8ryui8fZuzuaVyMuXN0Wr4z1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.15 31/79] x86/topology: Fix duplicated core ID within a package
Date: Thu, 27 Oct 2022 18:55:29 +0200
Message-Id: <20221027165055.987750101@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Rui <rui.zhang@intel.com>

commit 71eac7063698b7d7b8fafb1683ac24a034541141 upstream.

Today, core ID is assumed to be unique within each package.

But an AlderLake-N platform adds a Module level between core and package,
Linux excludes the unknown modules bits from the core ID, resulting in
duplicate core ID's.

To keep core ID unique within a package, Linux must include all APIC-ID
bits for known or unknown levels above the core and below the package
in the core ID.

It is important to understand that core ID's have always come directly
from the APIC-ID encoding, which comes from the BIOS. Thus there is no
guarantee that they start at 0, or that they are contiguous.
As such, naively using them for array indexes can be problematic.

[ dhansen: un-known -> unknown ]

Fixes: 7745f03eb395 ("x86/topology: Add CPUID.1F multi-die/package support")
Suggested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221014090147.1836-5-rui.zhang@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -141,7 +141,7 @@ int detect_extended_topology(struct cpui
 		sub_index++;
 	}
 
-	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+	core_select_mask = (~(-1 << pkg_mask_width)) >> ht_mask_width;
 	die_select_mask = (~(-1 << die_plus_mask_width)) >>
 				core_plus_mask_width;
 


