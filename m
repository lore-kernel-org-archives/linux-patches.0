Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D03579822;
	Wed,  9 Sep 2026 14:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963697; cv=none; b=HP0nJ/FPP9bF6bRlkooAVrG5WWYvjwcTIhQzxK+v/w076hu/fmzxQ5sT/lnME7W+3spMSdu+oMl5y5ObBG5bpq6InYDJg0g03tO/mFPgJYdcs5VOMPyq5JkNcD98aOnIzzUiFH27kA45EH28QszL6Nlnlpv+8CjOivKp2CV/N8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963697; c=relaxed/simple;
	bh=Ap5P+yzTg21PYix5lnNmHRj/1ieyB/uWKT2s8gpaPqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmNlZX3L6gIKY3tHtuaGky4AQoUGU3z+rSnEwYIZxi7nW5ehO9HoI67etT2F+SCOGYuU1poDXRuPQSuRHpPsUb/vBO8t68eB18mNA9wseqqAtaWinsQgidPnsJXMRv2lxl8qXjMsEqcEDdHoaeRpCBCQuHnqL+hoNuz8dlRGm/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVE8XsRV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVE8XsRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA4A1F00A3A;
	Wed,  9 Sep 2026 14:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963696;
	bh=3AzU+l3+9w4xL8NS/R7oOxzK1Z12P7+woeZaOGR+evk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVE8XsRVjtF5PpcVKe/a3o5EF0tXN5FW/7fLuz5z+aItWhReDwTVv8ypUVUH7sPKw
	 /HNbVFtS4WQ312eRY54bF4+uC7GX8Lc9UjWE49e7nbpYwOqmw8MfAJcUTML+byigfY
	 GLEIMjZb81Inojo5/dGTpqxIJPcMdXa6gQNvxGWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 121/583] powerpc/kexec_file: Fix null-ptr-def in extra size calculation
Date: Wed,  9 Sep 2026 15:36:46 +0200
Message-ID: <20260909134242.327279696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


