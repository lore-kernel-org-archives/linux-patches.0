Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2034ABBAF;
	Thu, 17 Sep 2026 17:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666192; cv=none; b=nzBH82TLKNtMc34GaZ9I0Ormr3f4k9CcJlUx3pmKOyYMLbxiIr8C2X3WxXcgUIwUGNiwe+5CIi6ZSS8nutHuMR/+YfEbMsKzqtd0CtsHRDlvOupJtcnYupNYKB2hard296c9w2mrsQNoA2Us6a1Tivc7dM25ep2lfnNgiPJBSic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666192; c=relaxed/simple;
	bh=vVIdEEcLpQd2l1Q7gLLp/MS/oaDoIEhHTztQuxrHOmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQClfAwLRKvRKMtQmYGyHgJoAieaKHOEiIbnMjwLPy3oTpxgDIUdo8Adh5ceWN0P2eusX5rc2yL0ad2BiFyg8gXBfnU1EpnVJXGvq72NY8Hmij7b/H/VXRLKKIVbAFl4Ngftz7fK0FvTcXkV8q6xpkKDAYeoRb9AnCh8oq3jTMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkaV/1Rg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkaV/1Rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC041F000FF;
	Thu, 17 Sep 2026 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666191;
	bh=7s28uwLl3xe1LNvWFgzqjANihGVyrrcUudcHWX4Eol8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkaV/1RgqfFNOqGZ+YtA1MZePbvjd7pJ9pOU3vzw/jJOV18PJR2KW/kqvBBIa7y5C
	 WxII+vfzFkU0INVv2Y+pDwiNcwzpR/vaEFCQ0rgW6xK2y2353LDmMebFNspy2Gyrr6
	 mj/zqrSEbaankPp8ov3x6fo2AAy1b5LNWnVLTNO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>
Subject: [PATCH 6.18 0956/1250] x86/amd_node: Avoid divide by zero on virtualized systems
Date: Thu, 17 Sep 2026 16:12:31 +0100
Message-ID: <20260917151617.930519068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

commit 72bd92bd8190d7869ecb462649ca40f297822a33 upstream.

On a virtualized system, the number of nodes does not have a relationship to
the number of roots.  A Xen PVH dom0 can calculate roots_per_node as 0, which
crashes with a divide by zero in:

  if (count++ % roots_per_node)

because the underlying topology code on Xen ends up making num_nodes
2 and num_roots 1 and the integer division result is 0.

The issue is seen with Xen, but it could affect other systems.

Set roots_per_node to 1 in this case. Print a firmware bug when this is
performed for non-virtualized systems.

  [ bp: Massage commit message. ]

Fixes: 0a4b61d9c2e4 ("x86/amd_node: Fix AMD root device caching")
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260825214805.39148-2-jason.andryuk@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/amd_node.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/amd_node.c b/arch/x86/kernel/amd_node.c
index 0be01725a2a4..408b9fd48349 100644
--- a/arch/x86/kernel/amd_node.c
+++ b/arch/x86/kernel/amd_node.c
@@ -287,6 +287,11 @@ static int __init amd_smn_init(void)
 		return -ENOMEM;
 
 	roots_per_node = num_roots / num_nodes;
+	if (!roots_per_node) {
+		if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+			pr_warn(FW_BUG "Error detecting roots per node.\n");
+		roots_per_node = 1;
+	}
 
 	count = 0;
 	node = 0;
-- 
2.55.0



