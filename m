Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7190D53FD2B;
	Wed,  9 Sep 2026 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962108; cv=none; b=ss1L1YFwUDX1KJhd7OKSjdWT+GvN8vBoYNaaHdS+iQa33agMBbGqr42biMwmDb4TZhkZ2bs/78ltBGG0bBC9vZyNl875KJVMqy37bVOdjxTYNimautqbt8JSXzaTFR4sZoZznf3nKl/EwrWC1vkyVSrAcIV6ZzbgPhFYGCVjRaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962108; c=relaxed/simple;
	bh=6O7VdBx6DCZ125Dwqn0CCcZm9oBUmWbMjtFhGPpw1Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dexznZ91MQP6t6aL2RqRZFRSqpGpilZyvQ3XflGfgLiQU1EoeFcGCrcWA7MLyEMBobSQ9m7IKl/mPVSJhfcy1yvJKwgNGP6bNqeBzGpAx/+Z7HDvoAdJ1SLaZFJfFl44FOa3FtBTzlaca6k+j4OUa6suRpzyWuQ3roUIt6ozY8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8Lk7WkI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8Lk7WkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC5C1F00A3A;
	Wed,  9 Sep 2026 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962107;
	bh=p2BLmYe2dpktSCQrmxqpdmcO9t4nfjIjJzg3l0V1mvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8Lk7WkIDBY6iEz1EAjfONPHOWztzB1c7R4UYonUI8FI13Ky9ApljoARrj4BEW4O2
	 DTV2xKxwOIRfAkUPPvxKoGd3AYd9GjE2PIuCOJ9hIiy/sasXwNCETLCvq+ktBnaqJl
	 rzzkfaXshciNBxQ9tMCNe4VudxQJO7k6B6m+9jic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.2 177/556] powerpc/kexec_file: Fix null-ptr-def in extra size calculation
Date: Wed,  9 Sep 2026 15:37:37 +0200
Message-ID: <20260909134236.643795124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 761eda315a6e1fda3e8e2185b28430771fb1ac29 upstream.

A static Sashiko AI review identified a potential NULL pointer
dereference in kexec_extra_fdt_size_ppc64().

On platforms without any reserved memory regions,
get_reserved_memory_ranges() can return 0 while leaving 'rmem'
unallocated as NULL. Passing it directly leads to a kernel panic when
evaluating 'rmem->nr_ranges'.

Add a NULL check for 'rmem' to prevent this crash.

Cc: stable@vger.kernel.org
Fixes: 0d3ff067331e ("powerpc/kexec_file: fix extra size calculation for kexec FDT")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260729012948.2797865-3-ruanjinjie@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kexec/file_load_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -664,7 +664,7 @@ unsigned int kexec_extra_fdt_size_ppc64(
 		extra_size += (cpu_nodes - boot_cpu_node_count) * cpu_node_size();
 
 	/* Consider extra space for reserved memory ranges if any */
-	if (rmem->nr_ranges > 0)
+	if (rmem && rmem->nr_ranges > 0)
 		extra_size += sizeof(struct fdt_reserve_entry) * rmem->nr_ranges;
 
 	return extra_size + kdump_extra_fdt_size_ppc64(image, cpu_nodes);


