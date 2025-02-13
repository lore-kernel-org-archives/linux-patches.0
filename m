Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DEC2661BB;
	Thu, 13 Feb 2025 14:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458243; cv=none; b=V61pPT6Rae6BBhjMKRWEa5czv3JV1Xa4tvzmqBys00KMhHIAAkDaBTbrwj2GVDSwI6elW8ztCnwjeJ+TFzIaKE/WAuIEEv+iMs6du4ahBnV/jZtsJzR+FKeHystLj9+0g+o03bkJxOQCXqmu5wvXEIpOVlso1NwI9LkT5yb97GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458243; c=relaxed/simple;
	bh=+HOwHktwKwhTvArsRax6TFD86aXAETHWT1p1Ap5D8dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csJSnQRAsCkJ/vevV331SuIVtDx8DA8FkUsYWEeXFs2v+jEzPkc3cMuPVGzodLMe3HbctAd4zvzZh35qHZA/ruqhgWPchtXhaP77o8XL71YUrEGDJ5QJ80eBohJ+OUfUHA6vdYycdHDajHGaS+mGvXQW9OhfcWgicMbQ1PJK31M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBt/tEZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBt/tEZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A989C4CED1;
	Thu, 13 Feb 2025 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458243;
	bh=+HOwHktwKwhTvArsRax6TFD86aXAETHWT1p1Ap5D8dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBt/tEZi7byAp/inYzDX1US7GgVvdEmdRjPqB34nTZBZBzmj14PilncNU0coyhjRC
	 /XlLV896QCMQRVDFn9tcUqRgUxOcU2JcCbR/aHUSkf5bCHQj8D8qgXl49EJ/5aoAb5
	 TxoH9PapqYKsQ5fjjBfltEaP+5NTbRzcR9VdmY+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Pavithra Prakash <pavrampu@linux.ibm.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Luiz Capitulino <luizcap@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Gang Li <gang.li@linux.dev>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 343/422] mm/hugetlb: fix hugepage allocation for interleaved memory nodes
Date: Thu, 13 Feb 2025 15:28:12 +0100
Message-ID: <20250213142449.790731599@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

commit 76e961157e078bc5d3cd2df08317e00b00a829eb upstream.

gather_bootmem_prealloc() assumes the start nid as 0 and size as
num_node_state(N_MEMORY).  That means in case if memory attached numa
nodes are interleaved, then gather_bootmem_prealloc_parallel() will fail
to scan few of these nodes.

Since memory attached numa nodes can be interleaved in any fashion, hence
ensure that the current code checks for all numa node ids
(.size = nr_node_ids). Let's still keep max_threads as N_MEMORY, so that
it can distributes all nr_node_ids among the these many no. threads.

e.g. qemu cmdline
========================
numa_cmd="-numa node,nodeid=1,memdev=mem1,cpus=2-3 -numa node,nodeid=0,cpus=0-1 -numa dist,src=0,dst=1,val=20"
mem_cmd="-object memory-backend-ram,id=mem1,size=16G"

w/o this patch for cmdline (default_hugepagesz=1GB hugepagesz=1GB hugepages=2):
==========================
~ # cat /proc/meminfo  |grep -i huge
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:    1048576 kB
Hugetlb:               0 kB

with this patch for cmdline (default_hugepagesz=1GB hugepagesz=1GB hugepages=2):
===========================
~ # cat /proc/meminfo |grep -i huge
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:       2
HugePages_Free:        2
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:    1048576 kB
Hugetlb:         2097152 kB

Link: https://lkml.kernel.org/r/f8d8dad3a5471d284f54185f65d575a6aaab692b.1736592534.git.ritesh.list@gmail.com
Fixes: b78b27d02930 ("hugetlb: parallelize 1G hugetlb initialization")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reported-by: Pavithra Prakash <pavrampu@linux.ibm.com>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Gang Li <gang.li@linux.dev>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3271,7 +3271,7 @@ static void __init gather_bootmem_preall
 		.thread_fn	= gather_bootmem_prealloc_parallel,
 		.fn_arg		= NULL,
 		.start		= 0,
-		.size		= num_node_state(N_MEMORY),
+		.size		= nr_node_ids,
 		.align		= 1,
 		.min_chunk	= 1,
 		.max_threads	= num_node_state(N_MEMORY),


