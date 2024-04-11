Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BE8140E3D;
	Thu, 11 Apr 2024 10:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831061; cv=none; b=hofvYXUNHj4aM7i3SzkTInw1K0B4n6e2CY7RzcszY75L9d87/4EImx2blIaLWMyrm8yEzd/qIiBsW75OTD8P6k1mUmP9XlfNjI9AP7OrSOKb9EPWiAmzTLP6A+bojHGcktBdjhJVWS6qbyPlMYoo1oEe3wD945tndtl/S0GuAVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831061; c=relaxed/simple;
	bh=eki8F65VhaZE9R0ilwaMfRZCBomq5fhfnQNFFudJano=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXoshTr/kMyUksPkJ5JASHm7OLn6HcdRi1Q+0d60yQemD1srmn0DCpLF03+w91ohmDsW2k0zcqXCHu4LNb7NE/DWbtQjOm/R8Az+q5+zSyjgFSLOkaUpgP1WqS3fwee89Hy08WJKR4k/AEVI6qI7tcqbkv1fsgxKJ89b4wTh3/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vckrM5ED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vckrM5ED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABCAC433F1;
	Thu, 11 Apr 2024 10:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831060;
	bh=eki8F65VhaZE9R0ilwaMfRZCBomq5fhfnQNFFudJano=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vckrM5EDAFpH+R9xr43jSi8ZwfRgDWozSChh7h0dF1ue4JOLYYTY2j5lrSBeBvkFo
	 H3UbSeEvg7AF+8mj9J5ArlFqyv0leLLXjrd2FtneEtmClPBCk7KL35tdjW5HpzGdW4
	 K8KDB0+Y2mGPwsfVuMwKtgnPJ6NuCX+cbiKyBkgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 210/215] x86/alternative: Dont call text_poke() in lazy TLB mode
Date: Thu, 11 Apr 2024 11:56:59 +0200
Message-ID: <20240411095431.176416321@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit abee7c494d8c41bb388839bccc47e06247f0d7de upstream.

When running in lazy TLB mode the currently active page tables might
be the ones of a previous process, e.g. when running a kernel thread.

This can be problematic in case kernel code is being modified via
text_poke() in a kernel thread, and on another processor exit_mmap()
is active for the process which was running on the first cpu before
the kernel thread.

As text_poke() is using a temporary address space and the former
address space (obtained via cpu_tlbstate.loaded_mm) is restored
afterwards, there is a race possible in case the cpu on which
exit_mmap() is running wants to make sure there are no stale
references to that address space on any cpu active (this e.g. is
required when running as a Xen PV guest, where this problem has been
observed and analyzed).

In order to avoid that, drop off TLB lazy mode before switching to the
temporary address space.

Fixes: cefa929c034eb5d ("x86/mm: Introduce temporary mm structs")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201009144225.12019-1-jgross@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/mmu_context.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -379,6 +379,15 @@ static inline temp_mm_state_t use_tempor
 	temp_mm_state_t temp_state;
 
 	lockdep_assert_irqs_disabled();
+
+	/*
+	 * Make sure not to be in TLB lazy mode, as otherwise we'll end up
+	 * with a stale address space WITHOUT being in lazy mode after
+	 * restoring the previous mm.
+	 */
+	if (this_cpu_read(cpu_tlbstate.is_lazy))
+		leave_mm(smp_processor_id());
+
 	temp_state.mm = this_cpu_read(cpu_tlbstate.loaded_mm);
 	switch_mm_irqs_off(NULL, mm, current);
 


