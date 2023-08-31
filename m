Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A95E8F61
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04DAC433C7;
	Thu, 31 Aug 2023 11:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480356;
	bh=GbriYdLZtPRnRrYsk7Q7IxdU5asHwxeHDgI86GswgsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDpwOoC2J+Pb/KMHD9JkUJ3I7OewLPoswnav6/wB+b+dszMVp8DbXx2iUrhpoFsY0
	 6Z5JA6hNVpI+qlBaGS8qFBhlZtHZlZSOVDuykVddgXR71i6PfqeGRjFQozTtNeDWur
	 sVCs8rddECyj/NR1Cso9QoBpA3kI7pvIzZMDTp2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.4 6/9] ARM: module: Use module_init_layout_section() to spot init sections
Date: Thu, 31 Aug 2023 13:11:33 +0200
Message-ID: <20230831111127.969785171@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831111127.667900990@linuxfoundation.org>
References: <20230831111127.667900990@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit a6846234f45801441f0e31a8b37f901ef0abd2df upstream.

Today module_frob_arch_sections() spots init sections from their
'init' prefix, and uses this to keep the init PLTs separate from the rest.

get_module_plt() uses within_module_init() to determine if a
location is in the init text or not, but this depends on whether
core code thought this was an init section.

Naturally the logic is different.

module_init_layout_section() groups the init and exit text together if
module unloading is disabled, as the exit code will never run. The result
is kernels with this configuration can't load all their modules because
there are not enough PLTs for the combined init+exit section.

A previous patch exposed module_init_layout_section(), use that so the
logic is the same.

Fixes: 055f23b74b20 ("module: check for exit sections in layout_sections() instead of module_init_section()")
Cc: stable@vger.kernel.org
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/module-plts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -251,7 +251,7 @@ int module_frob_arch_sections(Elf_Ehdr *
 		/* sort by type and symbol index */
 		sort(rels, numrels, sizeof(Elf32_Rel), cmp_rel, NULL);
 
-		if (strncmp(secstrings + dstsec->sh_name, ".init", 5) != 0)
+		if (!module_init_layout_section(secstrings + dstsec->sh_name))
 			core_plts += count_plts(syms, dstsec->sh_addr, rels,
 						numrels, s->sh_info);
 		else


