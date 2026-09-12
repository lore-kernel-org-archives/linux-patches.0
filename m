Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684584772B5;
	Sat, 12 Sep 2026 11:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213520; cv=none; b=ZPuh3sI8WYajQMmn6GODPiW/tRYFJhno9qfnI23+dQDn6RpyxhWITNmkPCYianNRO2+PZnjbRaj9Vaq2IiyWkYk5+jqdED8FKCTKL3oKYG/V89wgionJRfRe0rap5KH6jOM+3HM1xXimhiyW+4KfgZBqWP9jR7OHNjoqA8sBbdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213520; c=relaxed/simple;
	bh=AwmQbYHEhQg34wbTZP/EsGMxrkY8j5N4b+bGN5YunH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCEf4CCKGNPqUnf9Mq8TgzVcUxNcy1+/fFNGhT/D12yXzYSVN9WUNPpzdiBnOrYf5fN+kes65v4Y9U11gmjF0ezXqaFHpBBDUI4oLh2gMJoc8alirbDynKKoLbuuaxNxa9tgFO1VkTEZihQDKN5opm78wRJCKlZJRYYIrpJiOvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eh6KSl6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eh6KSl6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F011F00893;
	Sat, 12 Sep 2026 11:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213516;
	bh=LAhmsO3iIidJxL2+ZWyl5+x90asQSrbgIe9bIxPI99E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eh6KSl6jdt2boU7SSrG37xRl4TkUFcLHz0Nn/i+x2gIkPNImpvzwx0ZjCPA+omXIv
	 rx4SMhBAWXs6eV4sP6COispR732dfsnKJhtAMUSssF04g2VT7e2kJNZOLKPnFiHvde
	 OD9tR1ODBfdEcDo1/L2CYkkYGwOQUvD4rbSHTYKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 0095/1376] powerpc/kexec_file: Fix null-ptr-def in extra size calculation
Date: Sat, 12 Sep 2026 08:42:01 +0200
Message-ID: <20260912065609.679058240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -847,7 +847,7 @@ unsigned int kexec_extra_fdt_size_ppc64(
 		extra_size += (cpu_nodes - boot_cpu_node_count) * cpu_node_size();
 
 	/* Consider extra space for reserved memory ranges if any */
-	if (rmem->nr_ranges > 0)
+	if (rmem && rmem->nr_ranges > 0)
 		extra_size += sizeof(struct fdt_reserve_entry) * rmem->nr_ranges;
 
 	return extra_size + kdump_extra_fdt_size_ppc64(image, cpu_nodes);


