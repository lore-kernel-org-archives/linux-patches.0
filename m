Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2459C8465
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CE7C433CA;
	Wed, 20 Sep 2023 11:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210698;
	bh=bDdCtmzOORHZKR8hG99NLcIrqTL+fXsUfuKzzv9qIcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ew+K04IcRc9fjG6dgNr2ctrPitOgJEBVZO+u/dOllGqJlXGtSMdNKTI1yTnAADIjE
	 eUsxuy2eiIYOUox948BprYXdGX8jE0XPK5BZppaU0OGMHVMHujW6L20VFh492v7eow
	 cZuyCFs4gw/3ngR2ZMsyEtWbC3+bu8gQAwOS5+QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wahl <steve.wahl@hpe.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.5 172/211] x86/platform/uv: Use alternate source for socket to node data
Date: Wed, 20 Sep 2023 13:30:16 +0200
Message-ID: <20230920112851.218828397@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wahl <steve.wahl@hpe.com>

commit 5290e88ba2c742ca77c5f5b690e5af549cfd8591 upstream.

The UV code attempts to build a set of tables to allow it to do
bidirectional socket<=>node lookups.

But when nr_cpus is set to a smaller number than actually present, the
cpu_to_node() mapping information for unused CPUs is not available to
build_socket_tables(). This results in skipping some nodes or sockets
when creating the tables and leaving some -1's for later code to trip.
over, causing oopses.

The problem is that the socket<=>node lookups are created by doing a
loop over all CPUs, then looking up the CPU's APICID and socket. But
if a CPU is not present, there is no way to start this lookup.

Instead of looping over all CPUs, take CPUs out of the equation
entirely. Loop over all APICIDs which are mapped to a valid NUMA node.
Then just extract the socket-id from the APICID.

This avoid tripping over disabled CPUs.

Fixes: 8a50c5851927 ("x86/platform/uv: UV support for sub-NUMA clustering")
Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20230807141730.1117278-1-steve.wahl%40hpe.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -1571,7 +1571,7 @@ static void __init build_socket_tables(v
 {
 	struct uv_gam_range_entry *gre = uv_gre_table;
 	int nums, numn, nump;
-	int cpu, i, lnid;
+	int i, lnid, apicid;
 	int minsock = _min_socket;
 	int maxsock = _max_socket;
 	int minpnode = _min_pnode;
@@ -1622,15 +1622,14 @@ static void __init build_socket_tables(v
 
 	/* Set socket -> node values: */
 	lnid = NUMA_NO_NODE;
-	for_each_possible_cpu(cpu) {
-		int nid = cpu_to_node(cpu);
-		int apicid, sockid;
+	for (apicid = 0; apicid < ARRAY_SIZE(__apicid_to_node); apicid++) {
+		int nid = __apicid_to_node[apicid];
+		int sockid;
 
-		if (lnid == nid)
+		if ((nid == NUMA_NO_NODE) || (lnid == nid))
 			continue;
 		lnid = nid;
 
-		apicid = per_cpu(x86_cpu_to_apicid, cpu);
 		sockid = apicid >> uv_cpuid.socketid_shift;
 
 		if (_socket_to_node[sockid - minsock] == SOCK_EMPTY)


