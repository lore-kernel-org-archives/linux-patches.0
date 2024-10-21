Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C841E47A6;
	Mon, 21 Oct 2024 10:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507885; cv=none; b=dSOeg9dsdOidjAFjVsjTbYc0+BFyGJnUPxcyWWU9rsAOxftmrasYv31ph8HFx6IHbT/pMzgBK+Da0gkfXeBqfp/a5rAiv5mEPxc91EuggnNI5JTSocKwjQpwXUc3IWV1fyij4v8CYW/97KAMVFtr1sYs9+/EPQmeseAPIHeRBBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507885; c=relaxed/simple;
	bh=cnX6qKoR0yOIvgOAXLAAp2kk35RiAEUCFt7/SoSW9ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qELZhA9a7uZXKOzqdImMKPgE3U9T2GaUSjKq3/I63fdhtmBpLnK5wX37Dt+JysIWzL1OfsXgCSuPNBZaLYrFMXumAzAH3SLMnnSIMlxyUoVYHJpC0RQ+v8vswWp+LYjRKq2z43hTyyFLUg5va4NCKi3lAUe2gBMnDZl39PlHVHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tr30PcvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tr30PcvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F73C4CEC3;
	Mon, 21 Oct 2024 10:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507885;
	bh=cnX6qKoR0yOIvgOAXLAAp2kk35RiAEUCFt7/SoSW9ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tr30PcvRiXqvSYdqYc9Povoy7Kw23Xtq26jOtF1qnslLMVNQLfNMS2AQ9EaA6YaUs
	 NGAPWhqdc9hEJtCVQZx/c4d/cFsHRtyezjp8RYm9WC5/FNTlZZznZbBTHaqks2x8xR
	 8+qb6jxA/L5yOJfXIkv0sLdl4NqNvOcuKOjHsLb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 51/52] powerpc/mm: Always update max/min_low_pfn in mem_topology_setup()
Date: Mon, 21 Oct 2024 12:26:12 +0200
Message-ID: <20241021102243.627593873@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 7b31f7dadd7074fa70bb14a53bd286ffdfc98b04 upstream.

For both CONFIG_NUMA enabled/disabled use mem_topology_setup() to
update max/min_low_pfn.

This also adds min_low_pfn update to CONFIG_NUMA which was initialized
to zero before. (mpe: Though MEMORY_START is == 0 for PPC64=y which is
all possible NUMA=y systems)

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220704063851.295482-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/numa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1177,6 +1177,9 @@ void __init mem_topology_setup(void)
 {
 	int cpu;
 
+	max_low_pfn = max_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
+	min_low_pfn = MEMORY_START >> PAGE_SHIFT;
+
 	/*
 	 * Linux/mm assumes node 0 to be online at boot. However this is not
 	 * true on PowerPC, where node 0 is similar to any other node, it
@@ -1221,9 +1224,6 @@ void __init initmem_init(void)
 {
 	int nid;
 
-	max_low_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
-	max_pfn = max_low_pfn;
-
 	memblock_dump_all();
 
 	for_each_online_node(nid) {


