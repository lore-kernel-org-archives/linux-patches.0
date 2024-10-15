Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9640F1D9A5F;
	Tue, 15 Oct 2024 11:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992545; cv=none; b=jqk0tJ3YCMZp1pIUEFtAhYT7bSD7Fsh1FTcmdI+L7xpX5UlIJjdo+5MqkpRE9oD8aIyezacsn6giY+tWBKdQupkSHZNnnNcvE3qMnSaHZ0Y2iOy6U5iLJDAC6ZCkO5jq2qyUQ5XftYrxko9ekX3qbNDioZxvH77iFsnvQ5fQQIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992545; c=relaxed/simple;
	bh=0T6UpPSRWuDeUTWyNdJVNAfVskjP0t7hiGvEpafZQ1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdYevxfw7uyxdEoTN0z+Jr2cHvvX5OvGJ2Ip99Sd365izx5Qbno/6uop5d+ABKD/tY8jcsgncSg6L6pOmil/zDFGwryEQ7axmrVEqSmBfRZ2Noo3rR2IDH11XNQztttWruvVMKHID9CF0e6wFIl6b7pokD/Qe6TeHCHWIb8rXn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGVoExKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGVoExKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088C5C4CEC6;
	Tue, 15 Oct 2024 11:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992545;
	bh=0T6UpPSRWuDeUTWyNdJVNAfVskjP0t7hiGvEpafZQ1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGVoExKi9WMBt2lIsh3h3tWdoMuwxdQgzmbPLXYr+/qVxhT5r3NGBWS8htfK3Hxdu
	 304+41kdvIz2rkTwh5k+ivFvO2bdC3Sv7hcr+WFT9I1PxLBlSPYlWUBrrJk3eX7u7H
	 bwY67uyBPyVPkU6YIAjxq9YeP/JOTjVv1F2YWaKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>,
	Aaron Lu <aaron.lu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Zhimin Luo <zhimin.luo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/691] x86/sgx: Fix deadlock in SGX NUMA node search
Date: Tue, 15 Oct 2024 13:21:04 +0200
Message-ID: <20241015112444.963437386@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Aaron Lu <aaron.lu@intel.com>

[ Upstream commit 9c936844010466535bd46ea4ce4656ef17653644 ]

When the current node doesn't have an EPC section configured by firmware
and all other EPC sections are used up, CPU can get stuck inside the
while loop that looks for an available EPC page from remote nodes
indefinitely, leading to a soft lockup. Note how nid_of_current will
never be equal to nid in that while loop because nid_of_current is not
set in sgx_numa_mask.

Also worth mentioning is that it's perfectly fine for the firmware not
to setup an EPC section on a node. While setting up an EPC section on
each node can enhance performance, it is not a requirement for
functionality.

Rework the loop to start and end on *a* node that has SGX memory. This
avoids the deadlock looking for the current SGX-lacking node to show up
in the loop when it never will.

Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
Reported-by: "Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Zhimin Luo <zhimin.luo@intel.com>
Link: https://lore.kernel.org/all/20240905080855.1699814-2-aaron.lu%40intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4ea48acf55faa..ad453b4387a44 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -505,24 +505,25 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
 	struct sgx_epc_page *page;
 	int nid_of_current = numa_node_id();
-	int nid = nid_of_current;
+	int nid_start, nid;
 
-	if (node_isset(nid_of_current, sgx_numa_mask)) {
-		page = __sgx_alloc_epc_page_from_node(nid_of_current);
-		if (page)
-			return page;
-	}
-
-	/* Fall back to the non-local NUMA nodes: */
-	while (true) {
-		nid = next_node_in(nid, sgx_numa_mask);
-		if (nid == nid_of_current)
-			break;
+	/*
+	 * Try local node first. If it doesn't have an EPC section,
+	 * fall back to the non-local NUMA nodes.
+	 */
+	if (node_isset(nid_of_current, sgx_numa_mask))
+		nid_start = nid_of_current;
+	else
+		nid_start = next_node_in(nid_of_current, sgx_numa_mask);
 
+	nid = nid_start;
+	do {
 		page = __sgx_alloc_epc_page_from_node(nid);
 		if (page)
 			return page;
-	}
+
+		nid = next_node_in(nid, sgx_numa_mask);
+	} while (nid != nid_start);
 
 	return ERR_PTR(-ENOMEM);
 }
-- 
2.43.0



