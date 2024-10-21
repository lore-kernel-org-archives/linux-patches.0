Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F741EB9EE;
	Mon, 21 Oct 2024 10:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507748; cv=none; b=HoDIORZBEszURgsQTlnUB/dN/N2QmLbyRCznXN5Pf5ra7v239IYlq2MiMgM2VPdv1+5Ffq7252EvNPHe2hle3jlslLs8xPCjKYdLKIMQAuLSmL2MtVfA/XHYA2b3K3fdXX9j6crOeNWzanAPAGL2ejW5pNJpfUc+RvzG0z7p0qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507748; c=relaxed/simple;
	bh=S4nOAvWFMHeRjqbt+2e7Srngm8oVXPqsJucENyTfXIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/8S4ufV9E+cnVlrdO/YI14cIMfZ+50wlsz3U6/mbR0WrCdhIlcQoUmAS/lX8gCCKl4Ech4AJpGIc+WGdET7WGSXejXMqqYIOnN4yJP+5bic+s3vQYq220G4bR/6Gdt0InhNSOyQmYMn+BzG1zfVWXUVGqs1g5BQjyUzgDQS6TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZaEtwji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZaEtwji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8E3C4CEC7;
	Mon, 21 Oct 2024 10:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507748;
	bh=S4nOAvWFMHeRjqbt+2e7Srngm8oVXPqsJucENyTfXIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZaEtwjiHiIJqoPxvDYhGaap30ZNpp7RhEu3FZ6EP4I0HkXTZAirhSd3WkE6Gnel8
	 0GZN3/cMePOngwBPpVs9f8gREm//4rNep/YmaR07TiGOtgmAlys3pRt/t7K2LfTdhJ
	 vBXOGSka33/XGCT0RI3ydqUyf2Gqd22Y0tgHBDZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 81/82] powerpc/mm: Always update max/min_low_pfn in mem_topology_setup()
Date: Mon, 21 Oct 2024 12:26:02 +0200
Message-ID: <20241021102250.420519516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1162,6 +1162,9 @@ void __init mem_topology_setup(void)
 {
 	int cpu;
 
+	max_low_pfn = max_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
+	min_low_pfn = MEMORY_START >> PAGE_SHIFT;
+
 	/*
 	 * Linux/mm assumes node 0 to be online at boot. However this is not
 	 * true on PowerPC, where node 0 is similar to any other node, it
@@ -1206,9 +1209,6 @@ void __init initmem_init(void)
 {
 	int nid;
 
-	max_low_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
-	max_pfn = max_low_pfn;
-
 	memblock_dump_all();
 
 	for_each_online_node(nid) {


