Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66BE50E5B2;
	Thu, 17 Sep 2026 17:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666208; cv=none; b=ToXMZ2+/QTi5VP32MVl/aX2xDPbv2fcuOug0tRk8W8TeouUvjSEBva8jbFUYCzbXrpzpoXBiTyJtDsLk0QKQg/UITESWmjWoasIZqqVF5qt76RVOKfk/0hFqAZBnhR6ROqkXPOF/b2JNOPbXPHbJRAcYbJD8ppg57gNgFFg/RLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666208; c=relaxed/simple;
	bh=aZ1Dmf0tXU+9s/Mcq9D+NzK/H0GCYM5u6aP18zmdPJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIvcp733Y4FNri8VtXMMiPMN4ZYw5S24b4JP7m8L1YfWs/wra77kiRMQI98KH8vOkhRo8hUvPojjm9/h4mls+p7v5k4bXq7QF2ubZjfHHedsHfdkBnrkiPqtSJQHt45GDrx5cBvK5hkkJyf3w8qPZwKl1zKZ12E9uz1fhBf0T5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPXudm8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPXudm8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5DD1F000FF;
	Thu, 17 Sep 2026 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666206;
	bh=HNjFpBvXdnGd1NcAVA11B3cWkxaMd3dZqMtznZf291E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPXudm8G7Syk6Gxfb0FwkYsGsFQjqm+LNwYj9TofZVsv2J8ir6oJksb+ms+0p33Px
	 wG9ExQDIA/ehDkb5jk2di1CTwNOxKO1vVx4eXqwF3ToBhuJFu1MsQLEUG0XCGpfj78
	 RhXm4vMnUcx9u/6R5uEmF834lPN+XsOPiC8vpOkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 0960/1250] x86/amd_node: Fix PCI device reference counting in amd_smn_init()
Date: Thu, 17 Sep 2026 16:12:35 +0100
Message-ID: <20260917151618.036363467@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 27600805e62f800bacf990354632eae4e487d34c upstream.

The local "root" pointer is a temporary variable used during the device
search. Therefore, refcount related to the search iterators should be cleaned
up after the search is complete.

Use the __free() cleanup macro to ensure the refcount is decremented when the
temporary pointer goes out of scope.

Additionally, increment the refcount when caching a root pointer. This ensures
the in-use refcount is separate from the temporary search refcounting.

Finally, drop the redundant "root = NULL" before the second search loop. The
pci_get_class() iterator always decrements the refcount of its "from"
argument, so the first loop can only fall through with "root" already NULL.

Fixes: 0a4b61d9c2e4 ("x86/amd_node: Fix AMD root device caching")
Closes: https://sashiko.dev/#/patchset/20260806160159.230453-1-jason.andryuk%40amd.com
Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260903154325.74343-1-yazen.ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/amd_node.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_node.c b/arch/x86/kernel/amd_node.c
index 762585775b5a..b7926ba3610a 100644
--- a/arch/x86/kernel/amd_node.c
+++ b/arch/x86/kernel/amd_node.c
@@ -251,7 +251,7 @@ __setup("amd_smn_debugfs_enable", amd_smn_enable_dfs);
 static int __init amd_smn_init(void)
 {
 	u16 count, num_roots, roots_per_node, node, num_nodes;
-	struct pci_dev *root;
+	struct pci_dev *root __free(pci_dev_put) = NULL;
 
 	if (!cpu_feature_enabled(X86_FEATURE_ZEN))
 		return 0;
@@ -262,7 +262,6 @@ static int __init amd_smn_init(void)
 		return 0;
 
 	num_roots = 0;
-	root = NULL;
 	while ((root = get_next_root(root))) {
 		pci_dbg(root, "Reserving PCI config space\n");
 
@@ -299,14 +298,13 @@ static int __init amd_smn_init(void)
 
 	count = 0;
 	node = 0;
-	root = NULL;
 	while (node < num_nodes && (root = get_next_root(root))) {
 		/* Use one root for each node and skip the rest. */
 		if (count++ % roots_per_node)
 			continue;
 
 		pci_dbg(root, "is root for AMD node %u\n", node);
-		amd_roots[node++] = root;
+		amd_roots[node++] = pci_dev_get(root);
 	}
 
 	if (enable_dfs) {
-- 
2.55.0



