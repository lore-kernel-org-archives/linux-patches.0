Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BF6519DE8;
	Wed, 30 Sep 2026 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793603; cv=none; b=IVsVGv33r6RNFeLBxOi6KjVIhDt0unCDHaK5D1/ddfoEqnLZtU059n3+UlINdFyrzSCpMli0ULvhT5n/a5QS40polNZ66oQJ6/jncWcxDsAGscF7wrl3Ty42ZuLS54YHjHGgbIDXCIuZwn0PwLAoC+jr+ktOc76mucdE15bd99g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793603; c=relaxed/simple;
	bh=Dj5cqa+jknpLYj54ec/CFglMJaXXUhSHWl/kyrlNPjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgryQYg6c82oF+6IJQaGPSA1q2M1h5Q8z7he+hfulgLrLFvgDNlDgYsA+TA1h0FVKnzPYFNFIezREMyUt88VBsO/dTmtQ3d3+//PFGxJSS4dHUxliCKy6XFI7qFsuzzX9WGtXaCewvRL/2zbkhibkBkg9wfWp7q2Y87GdZ/Rsl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+bKkDNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+bKkDNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3150C1F000FF;
	Wed, 30 Sep 2026 18:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793602;
	bh=I2wbXagdqN/4zrXGtK+PWHenKG99gyYBa00Jqqme9sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+bKkDNIwXkLZOYQRKA7HOqBKLctfCF+HhBDldj8zV7SnkY8+vOAua04slp7TXrDR
	 C9jhq5F53Zk1Qs3zN3Lrc908hS0eCjXujV5kcjvPnPUoTtlgrPbzVmyNIZjDqrlV6F
	 lDOP8YlAN3/v4tkiEu41lAKiPkEUmU2PK7dFlDH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	David Ballesteros <davimaba.v@proton.me>,
	Zeng Chi <zengchi@kylinos.cn>
Subject: [PATCH 6.18 311/395] KVM: Dont treat reserved xarray entries as having memory attributes
Date: Wed, 30 Sep 2026 17:29:33 +0200
Message-ID: <20260930152347.401519593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Zeng Chi <zengchi@kylinos.cn>

commit 277d3623d99a4fc2623bfb7d191b649ca380605d upstream.

kvm_vm_set_mem_attributes() reserves an xarray entry for every gfn in
the range before storing the new attributes, so that the store loop
can't fail partway through.  If one of the reservations fails, e.g. with
-ENOMEM, the entries that were already reserved are left in the array.
That is harmless as far as xa_reserve() is concerned, as the reserved
entries read back as NULL via xa_load(), but it confuses the "does this
range have no attributes at all" check:

	if (!attrs)
		return !xas_find(&xas, end - 1);

A reserved entry is XA_ZERO_ENTRY, not NULL, and xas_find() returns it
as present.  So a leftover reservation makes KVM report that a fully
shared range has attributes even though kvm_get_memory_attributes()
returns none for every gfn in the range.  On x86, the next time
mixed-attribute tracking is recomputed for the range (memslot creation,
or a later attribute change that straddles the 2MiB page),
hugepage_has_attrs() treats a fully shared 2MiB range as mixed and
refuses to map it with a hugepage, until userspace happens to set
attributes on the range again.

Drop the shortcut and handle the !attrs case in the per-index loop,
using xas_next_entry() to find the next non-NULL entry.  xas_next_entry()
is essentially an optimized xas_find(), so the effective change is that
the !attrs lookup now goes through xas_retry() like the attrs != 0 case,
i.e. reserved entries are skipped and retry entries restart the walk.
Don't check the index when no entry is found, as the xarray leaves the
xas index in a bogus state in that case; no entry simply means the rest
of the range has no attributes.

KVM never stores a non-NULL entry with a value of zero (clearing stores
NULL), but such an entry would be returned by xas_next_entry() and trip
the index check, so WARN if one is ever seen.

Fixes: 5a475554db1e ("KVM: Introduce per-page memory attributes")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: David Ballesteros <davimaba.v@proton.me>
Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
Link: https://patch.msgid.link/20260921102442.1232375-1-zeng_chi911@163.com
[sean: expand comment to elaborate on xarray APIs, split optimization out]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2453,14 +2453,36 @@ bool kvm_range_has_memory_attributes(str
 		return (kvm_get_memory_attributes(kvm, start) & mask) == attrs;
 
 	guard(rcu)();
-	if (!attrs)
-		return !xas_find(&xas, end - 1);
 
+	/*
+	 * Lookup the entry for each index instead of iterating over the xarray
+	 * as KVM deletes/nullifies entries to represent "no attributes", and
+	 * the xas index is effectively invalid when no entry is found.  I.e.
+	 * matching non-zero attributes for *every* entry effectively requires
+	 * a manually lookup for each index.
+	 *
+	 * Skip pre-allocated, reserved entries, or restart the lookup if the
+	 * xarray was concurrently modified, via xas_retry() ("retry" means the
+	 * entry holds an internal xarray value, i.e. is either invalid or NULL
+	 * from the caller's perspective).
+	 *
+	 * Use xas_next() when looking for non-zero attributes to optimize for
+	 * the case where the start of the range (or the entire range) doesn't
+	 * have any attributes, as xas_next() returns literally the next entry,
+	 * whereas xas_next_entry() returns the next non-NULL entry (bounded by
+	 * a maximum index).
+	 */
 	for (index = start; index < end; index++) {
 		do {
-			entry = xas_next(&xas);
+			entry = attrs ? xas_next(&xas) :
+					xas_next_entry(&xas, end - 1);
 		} while (xas_retry(&xas, entry));
 
+		if (!entry)
+			return !attrs;
+
+		WARN_ON_ONCE(!xa_to_value(entry));
+
 		if (xas.xa_index != index ||
 		    (xa_to_value(entry) & mask) != attrs)
 			return false;


