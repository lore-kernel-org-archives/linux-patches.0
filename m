Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E84015CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEB1C433D6;
	Tue,  8 Nov 2022 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916782;
	bh=kRYR5pRRyNqouJfXY93OGO7T/ovl5yAJGGCNdxlPAOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYtT8htSC1fW5XN5cqUoyo2eMpjfNBbBLdzORfj4QfRKLBZ9HeYs/WboMYKIiP3Qc
	 Uowl6tnHw84I4QzkaJK+hJxIQnkf5YEsS9GsUoKfQkaeWb2rcdMFcqkjKq1bLVqew5
	 r02qsvXT0qcHt3vSTDd6P2wvn59R8gn3HyHTTLUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.0 132/197] ACPI: NUMA: Add CXL CFMWS nodes to the possible nodes set
Date: Tue,  8 Nov 2022 14:39:30 +0100
Message-Id: <20221108133400.960173497@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

commit 24f0692bfd41fd207d99c993a5785c3426762046 upstream.

The ACPI CEDT.CFMWS indicates a range of possible address where new CXL
regions can appear. Each range is associated with a QTG id (QoS
Throttling Group id). For each range + QTG pair that is not covered by a proximity
domain in the SRAT, Linux creates a new NUMA node. However, the commit
that added the new ranges missed updating the node_possible mask which
causes memory_group_register() to fail. Add the new nodes to the
nodes_possible mask.

Cc: <stable@vger.kernel.org>
Fixes: fd49f99c1809 ("ACPI: NUMA: Add a node and memblk for each CFMWS not in SRAT")
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/166631003537.1167078.9373680312035292395.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/numa/srat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -327,6 +327,7 @@ static int __init acpi_parse_cfmws(union
 		pr_warn("ACPI NUMA: Failed to add memblk for CFMWS node %d [mem %#llx-%#llx]\n",
 			node, start, end);
 	}
+	node_set(node, numa_nodes_parsed);
 
 	/* Set the next available fake_pxm value */
 	(*fake_pxm)++;


