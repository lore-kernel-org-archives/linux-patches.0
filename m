Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6116230C373;
	Mon, 13 Oct 2025 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368896; cv=none; b=lGd2w9djX+XB7A2ZOotJzgPLFajUXCoigACC2hRetvMxbEjSk/Os+22OKfqM+DKIl7kWlvsP1fANCs4d8N2A/mKpN0xsbeH+ijALlsKcZ8UXpPojlBXJKn3M6I8baItu6Yo8j6yfjP1eGG3uDl1Xfq9GuOXJgoTnxT7vLAvA0/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368896; c=relaxed/simple;
	bh=4NHJvHE9M+0sfb0F97GKmgtr0Sb/5+L4rZVufpP/KEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNnMQ0Kg+YvmgAERCF1mPETag1iWUwrIsbkBaJiNZ+BlHToEu66fwbN7UmU/GlwfXBg2a+zCOM9ATGd0FtyksphUcQWWmsH+fVp20w1KM1B8QzEujumhcssC1WTxGkci83ycu2s8UXcaDJCteD8PyzGHgx4CQaFIuK0jJHSsmSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnRkp5tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnRkp5tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE9DC4CEE7;
	Mon, 13 Oct 2025 15:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368896;
	bh=4NHJvHE9M+0sfb0F97GKmgtr0Sb/5+L4rZVufpP/KEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnRkp5tfqPMjb7lTsaDX8UerI1DPkFWrFYhW1S9UCw5dc/x6+PUIM9th6FNuhX1ox
	 +NFlxOIk4RqkYODonUXDIOIjVrZer0Vm+Mrizhw95gglkJzBA0YoO74D8pBZb/JGv4
	 sfRxptQUxQrmbb7vrsugQ7zN53KJtUM/8iEgHPK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Lawrence <joe.lawrence@redhat.com>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 023/563] powerpc64/modules: correctly iterate over stubs in setup_ftrace_ool_stubs
Date: Mon, 13 Oct 2025 16:38:04 +0200
Message-ID: <20251013144412.128973909@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit f6b4df37ebfeb47e50e27780500d2d06b4d211bd ]

CONFIG_PPC_FTRACE_OUT_OF_LINE introduced setup_ftrace_ool_stubs() to
extend the ppc64le module .stubs section with an array of
ftrace_ool_stub structures for each patchable function.

Fix its ppc64_stub_entry stub reservation loop to properly write across
all of the num_stubs used and not just the first entry.

Fixes: eec37961a56a ("powerpc64/ftrace: Move ftrace sequence out of line")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250912142740.3581368-3-joe.lawrence@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/module_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 126bf3b06ab7e..0e45cac4de76b 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -1139,7 +1139,7 @@ static int setup_ftrace_ool_stubs(const Elf64_Shdr *sechdrs, unsigned long addr,
 
 	/* reserve stubs */
 	for (i = 0; i < num_stubs; i++)
-		if (patch_u32((void *)&stub->funcdata, PPC_RAW_NOP()))
+		if (patch_u32((void *)&stub[i].funcdata, PPC_RAW_NOP()))
 			return -1;
 #endif
 
-- 
2.51.0



