Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AB24E77FB;
	Thu, 17 Sep 2026 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660079; cv=none; b=edHquMg+YGeLeGhfVyqp3pZxBhgEC2jH9c6CZLZOeosV+JXfJWj0nFLNSxEVlcoL+PBW/zEY/pGastG52tNc4Ok4bxhuEtAu91OpwxuSH8wNmpS1PIKXl6Gk7e2yNQlcbdVWr429fAKhOMA7ZgBTNqdW7N/b2JG1Xar7r2S6GDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660079; c=relaxed/simple;
	bh=yr5ZcUaRp2i9cfs4eh43o4ntooB5dF+VgRXbu9VRWew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+1DPwVmxFKqw2O4167saAsIy1vyL7L2xzA07NTgl9cTD/YL8tx367nlC52VtEMyk23JIkHwvIJI2zVO0xnuj5xr2NkMvMiTiBrdwHqEMo1WZn8PSZpQT76hy0Be8wgSN+GgZiJgujcjpQ70KOq0GHxpe4T6gdV21Y4W2/N3kOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM4qc+sA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM4qc+sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299701F00899;
	Thu, 17 Sep 2026 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660073;
	bh=RATRjiaVZHXcvTGP3/Bx4nZrDDsPCWJqihs4qK3lkwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bM4qc+sA4Cmg4GCuw8e5x5H41HoCmKcyR2IimYRgcAa7HLkZqP++MdrbyzqwwA6FZ
	 kixIIcimr6gw2AzUTEuBKSq7b8XmFvkHxYJcW4d8OxKfyiwz7EwHtWZ6wdaxVtxS4A
	 KVMdXixTBoQVIXpnzchj89bYXuK9xbUnJVqoLiBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>
Subject: [PATCH 7.2 453/733] x86/amd_node: Avoid divide by zero on virtualized systems
Date: Thu, 17 Sep 2026 16:12:41 +0100
Message-ID: <20260917151403.202072527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kernel/amd_node.c |    5 +++++
 1 file changed, 5 insertions(+)

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


