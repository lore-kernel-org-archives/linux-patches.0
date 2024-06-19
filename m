Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25A682495;
	Wed, 19 Jun 2024 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803264; cv=none; b=Wl+lK3mFtJJiZBx71M8j202IhoZ9E/U98rK2Bdwp7w7dMpp3FyKVAUV41tw5MTInQ6AmbbfdFb0FKtbMBbnWE6Pq5y4eUbrPohSIK52TAqi+mlH5pUly/BFseJeS/Wm8CgsQ2X2ejNh9XYf3HtpgUYdGK1lHCI8qZp4Jy4FWDeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803264; c=relaxed/simple;
	bh=1MCVKkEyGBEJ+bf3QpIZmW++jRmqaucevRwFHbxhjTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arcIPM3cGdMpJglEjVcXF6bTVNK4/J60kY0HmiUWZp3ZKNWeFIaRcVn3rMVpm0ztj0FMBruFJTuKCB6pkH2vzuo8AbpPO+/7Ce/I1YSW43ue3jvRAat9PLcwvfaDroabXp9cCBr1+rslqq+nToWqzbEbL/H2id1Cf8YgwzU0EgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jK3hCtEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jK3hCtEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B1DC2BBFC;
	Wed, 19 Jun 2024 13:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803263;
	bh=1MCVKkEyGBEJ+bf3QpIZmW++jRmqaucevRwFHbxhjTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jK3hCtEJt3AFMHYrAYwR2M8tx3gEcG79wWDMuRTWmDHKOtd7nfK5feO2JKw4a5RZj
	 ZGiOCLhC6RnDeWByD4B1XDAYq1jADDhw9eMGvZ1OJc2iKsDSuRvu8P1eC1XLo4ZnUP
	 Bu4Hc2HTeb3Ba1MDz35eOcDMQSyiBZnOEgk9F+1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: [PATCH 6.9 207/281] memblock: make memblock_set_node() also warn about use of MAX_NUMNODES
Date: Wed, 19 Jun 2024 14:56:06 +0200
Message-ID: <20240619125617.916241853@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

commit e0eec24e2e199873f43df99ec39773ad3af2bff7 upstream.

On an (old) x86 system with SRAT just covering space above 4Gb:

    ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0xfffffffff] hotplug

the commit referenced below leads to this NUMA configuration no longer
being refused by a CONFIG_NUMA=y kernel (previously

    NUMA: nodes only cover 6144MB of your 8185MB e820 RAM. Not used.
    No NUMA configuration found
    Faking a node at [mem 0x0000000000000000-0x000000027fffffff]

was seen in the log directly after the message quoted above), because of
memblock_validate_numa_coverage() checking for NUMA_NO_NODE (only). This
in turn led to memblock_alloc_range_nid()'s warning about MAX_NUMNODES
triggering, followed by a NULL deref in memmap_init() when trying to
access node 64's (NODE_SHIFT=6) node data.

To compensate said change, make memblock_set_node() warn on and adjust
a passed in value of MAX_NUMNODES, just like various other functions
already do.

Fixes: ff6c3d81f2e8 ("NUMA: optimize detection of memory with no node id assigned by firmware")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1c8a058c-5365-4f27-a9f1-3aeb7fb3e7b2@suse.com
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memblock.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1339,6 +1339,10 @@ int __init_memblock memblock_set_node(ph
 	int start_rgn, end_rgn;
 	int i, ret;
 
+	if (WARN_ONCE(nid == MAX_NUMNODES,
+		      "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
+		nid = NUMA_NO_NODE;
+
 	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
 	if (ret)
 		return ret;


