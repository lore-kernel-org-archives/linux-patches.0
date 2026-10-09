Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746DC3431F8;
	Fri,  9 Oct 2026 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556585; cv=none; b=klcHUstu73wQAdoYm4f/471vvpo6wBTVY8OXfIM/O1RC4wVS9KeQacfj4L7RLqFXMQvLf43+Re6lm3EOKQDaxJJhD/TfwLCWRhahqL2LLmLor4F1vcFlynwD3P8F+3X0BdLnB5BiYbnR/32AM8vrghdFOsNBHQo6+Eopz/8De60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556585; c=relaxed/simple;
	bh=BJ16Y2dLUQOFe7D6EFWWr6fPaRT1ADG6aWUZdin+gbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoTupxzFH/yIwqy5JuCiLqvJ0e8cvjnkyWLrEOUiL/K2O5wE5QhvGMwSQNxYmxrHzWvvccX6HVtwmMgawHIZ/R2lQFP/dIJvHWyNz7vHy7LWHq0EfJdJRzKYFqRHaLY78rOUDZz4RenaSxs3ZvhZOjJzRmfAeeEMfqQE3plFt1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OH2121Sh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OH2121Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95D11F000FF;
	Fri,  9 Oct 2026 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556584;
	bh=MLIdG+MQWrcuD/k1KDnS1t5OO/ErWzu59E1cV+y3Sjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OH2121ShG/bzml/4o4DytPiQjBKlDtKsmuDU0u79T5it/Hs/373i2MCX7RQS9weMn
	 gM3NrDN8eu6ZR2HMGRq+FqmOCZxF77bhmx1DbchYUTogwjHk+gAJi9RtLRBS+5YG5b
	 eYVFjx71O/MVKwqTXnukiDDMmzvbzS0xjte/NDKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Bot <sashiko-bot@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 259/403] KVM: SEV: Do cache maintenance on the source VM *before* clearing SEV state
Date: Fri,  9 Oct 2026 16:10:20 +0200
Message-ID: <20261009140958.231368382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 973ea70393e885e540f714904e51bc6cac80e3d7 upstream.

Explicitly flush caches after intra-host migration before clearing "SEV
active" on the source VM, as doing cache maintenance afterwards creates a
tiny window where memory reclaim could return memory to the host without
performing a cache flush, e.g. as pointed out by Sashiko:

  CPU1 in sev_migrate_from():
    src->active = false;

  CPU2 running concurrent unmap:
    Since active is false, the automatic cache flush in
    sev_guest_memory_reclaimed is skipped.
    The host frees and reallocates the page.

  CPU1 in sev_migrate_from():
    sev_writeback_caches(src_kvm);
    Executes a hardware cache flush (wbnoinvd), which writes the guest's old
    dirty ciphertext over the new page owner's data.

Fixes: 93de2a6a4b91 ("KVM: SEV: Do cache maintenance on the source VM during intra-host migration")
Cc: stable@vger.kernel.org
Reported-by: Sashiko Bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260923165304.1662E1F000FF@smtp.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260928154644.2559454-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1986,6 +1986,13 @@ static void sev_migrate_from(struct kvm
 	struct kvm_sev_info *mirror;
 	unsigned long i;
 
+	/*
+	 * Do cache maintenance on the source VM *before* clearing "SEV active",
+	 * as memory reclaim flows won't trigger cache maintenance on the VM
+	 * once it's no longer an SEV VM.
+	 */
+	sev_writeback_caches(src_kvm);
+
 	dst->active = true;
 	dst->asid = src->asid;
 	dst->handle = src->handle;
@@ -1999,12 +2006,6 @@ static void sev_migrate_from(struct kvm
 	src->pages_locked = 0;
 	src->es_active = false;
 
-	/*
-	 * Do cache maintenance on the source VM as it is no longer an SEV VM,
-	 * i.e. memory reclaim flows won't trigger cache maintenance on the VM.
-	 */
-	sev_writeback_caches(src_kvm);
-
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 
 	mutex_lock(&sev_mirror_lock);


