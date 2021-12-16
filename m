Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD0E173
	for <patches@lists.linux.dev>; Thu, 16 Dec 2021 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639675482; x=1671211482;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2nNZew6Z9ZNfBloxy8d/28ymfM5DvMdcScX6xoLtWB8=;
  b=g3DhkNn/htV5NKZ/SlTMkYOHnx5Xb16Dk15YvPfvqqg24Qj18rCVnpkS
   92WpYmfAVwRVA3RdJmsnX5x7TxbHol+ZyG/K8hEPvAbI8fs8xc+NeuZYO
   DLId+0IJSCPRO+elo+0fJtfqT7qvclLjB96rIyZmxadpy5OX1NJ9awwKf
   /LlxHL/pWisSJmTC7M0a0G/QRQuVso3ZwhgFUvjpn+dC0Zo3b9L56iXWU
   ZdtzEKphEyHQyDdhuW+x6z0VTcBjlDZVlS7bfPNbOWiLTnzMfV3j3ZSww
   vBuUbF5WBvZiIkENGLMKcNrr4hdxGm2k6HCGra1JkhI3zCFrsHOM9hSEq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239361195"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="239361195"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 09:24:38 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="519336265"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 09:24:37 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpufeatures: Add fast-short-rep-movs check to copy_user_enhanced_fast_string()
Date: Thu, 16 Dec 2021 09:24:31 -0800
Message-Id: <20211216172431.1396371-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit f444a5ff95dc ("x86/cpufeatures: Add support for fast short REP; MOVSB")
fixed memmove() with an ALTERNATIVE that will use REP MOVSB for all
string lengths.

copy_user_enhanced_fast_string() has a similar run time check to avoid
using REP MOVSB for copies less that 64 bytes.

Add an ALTERNATIVE to patch out the short length check and always use
REP MOVSB on X86_FEATURE_FSRM CPUs.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/lib/copy_user_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 2797e630b9b1..1c429f0489dd 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -200,8 +200,8 @@ EXPORT_SYMBOL(copy_user_generic_string)
  */
 SYM_FUNC_START(copy_user_enhanced_fast_string)
 	ASM_STAC
-	cmpl $64,%edx
-	jb .L_copy_short_string	/* less then 64 bytes, avoid the costly 'rep' */
+	/* CPUs without FSRM should avoid rep movsb for short copies */
+	ALTERNATIVE "cmpl $64, %edx; jb .L_copy_short_string", "", X86_FEATURE_FSRM
 	movl %edx,%ecx
 1:	rep
 	movsb
-- 
2.31.1

