Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C370AC129;
	Mon,  1 Apr 2024 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988668; cv=none; b=LJj2GUMJd8fCDD21ZqNiDIzqfV+e4qphBGRWny0cdA3+o73SnFF5ovbLTvBQhvsEz2hOD+mOkkhX4/F3HHmTYal1Nl68aCAy5TPxuJh6cf9L9vdgrHYtZnJNpTS9+BNzBryEjCLzV/0Gzz+D/weVF8YACHy/EgnHGTsSLlNJ6Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988668; c=relaxed/simple;
	bh=NALkcoPQB0ZMTMKCbfetJ6Veaji9aUnqZyFF8NC/jRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrmCNcjnD81IRptpYvQs78gkEFDTw4lgq7Di4DyEh7B/eC9eCD0NqjS4IkZNFmQTTeKCgyddoJf6hn0A7F9R3VGZfD2zrmIoFmI+/5MSSioGfoiiZm4YUxk5ker7BhorIJQml4CmdjV1igP89eY+gv34qyeh8AiMTXZHVYZ1wbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2Vw+RW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2Vw+RW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FC7C433C7;
	Mon,  1 Apr 2024 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988668;
	bh=NALkcoPQB0ZMTMKCbfetJ6Veaji9aUnqZyFF8NC/jRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2Vw+RW1UDFIq7fmSj2OQX/memfvbzldr9BJvA2OiIkMuBU/dxkv9RdpqmJDwCpkW
	 lPHoyKATrg/voeQKNm2d7XqGPsKE0CjzfGAXR9A7sLDsMlQJfXyMwdcK5cU2GxYDj0
	 g6Hf+zs2PirwDIpav5G0rvHZty6b0HWkvPWHpfyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	Michael Krebs <mkrebs@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.7 253/432] KVM: x86: Mark target gfn of emulated atomic instruction as dirty
Date: Mon,  1 Apr 2024 17:44:00 +0200
Message-ID: <20240401152600.684574271@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 910c57dfa4d113aae6571c2a8b9ae8c430975902 upstream.

When emulating an atomic access on behalf of the guest, mark the target
gfn dirty if the CMPXCHG by KVM is attempted and doesn't fault.  This
fixes a bug where KVM effectively corrupts guest memory during live
migration by writing to guest memory without informing userspace that the
page is dirty.

Marking the page dirty got unintentionally dropped when KVM's emulated
CMPXCHG was converted to do a user access.  Before that, KVM explicitly
mapped the guest page into kernel memory, and marked the page dirty during
the unmap phase.

Mark the page dirty even if the CMPXCHG fails, as the old data is written
back on failure, i.e. the page is still written.  The value written is
guaranteed to be the same because the operation is atomic, but KVM's ABI
is that all writes are dirty logged regardless of the value written.  And
more importantly, that's what KVM did before the buggy commit.

Huge kudos to the folks on the Cc list (and many others), who did all the
actual work of triaging and debugging.

Fixes: 1c2361f667f3 ("KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <tatashin@google.com>
Cc: Michael Krebs <mkrebs@google.com>
base-commit: 6769ea8da8a93ed4630f1ce64df6aafcaabfce64
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20240215010004.1456078-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7951,6 +7951,16 @@ static int emulator_cmpxchg_emulated(str
 
 	if (r < 0)
 		return X86EMUL_UNHANDLEABLE;
+
+	/*
+	 * Mark the page dirty _before_ checking whether or not the CMPXCHG was
+	 * successful, as the old value is written back on failure.  Note, for
+	 * live migration, this is unnecessarily conservative as CMPXCHG writes
+	 * back the original value and the access is atomic, but KVM's ABI is
+	 * that all writes are dirty logged, regardless of the value written.
+	 */
+	kvm_vcpu_mark_page_dirty(vcpu, gpa_to_gfn(gpa));
+
 	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
 


