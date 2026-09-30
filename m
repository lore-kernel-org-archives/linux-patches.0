Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF42D4E06CC;
	Wed, 30 Sep 2026 16:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786822; cv=none; b=OVC9ZuLUwz7WYIm7Mf41nQGUpadAoaXqkgyIp86qSdW9uCl6Eq+xMMlRqKOZr7+anHMEvZ2F/ahzmvpXsl7eTQGwb6pf8UTr7u2QqMJt0Q9YyKPKzh7W86wy2AARooaMm+s1bIgOXVxIy+HvGLlQKSpMHblSh1JBNBu9AxuB7Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786822; c=relaxed/simple;
	bh=bdePZfOHx3awv8UjiE7UmbO/OdsxpLhoGiLJQpd21hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9Z0z+l6LFC/3/z9YDwrwMSu84AboqYaGTe5ILG0ZDiMogSRho3K8h+IUiiRd46177t0WxE8lyAFqQ3Li1DIOR9y7yR4aQlCeUTxRfdO/fac5BKMXjgjWY6+qg76yeb/wjlYo8lKUGyUPXbADxIm9J8TpGQMRhILLN4tQenqSxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcSdvn2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcSdvn2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EF21F00893;
	Wed, 30 Sep 2026 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786821;
	bh=PhhvkqyNTPGjpaI2LRgiPPtfoq6aiKSalTqc4LnPbAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcSdvn2fNJZo/PTi29ehqfIOguTM84+GwxY2ZbgfgNb7QksGl1w8r69Ps/mBOpEBu
	 CDcdsvcn7jJfjbrKydcW9k9jXMd6LFLCTTvODyVg0itAXEgeREK2aFXWWY5YUHpjiS
	 4gFRliJNQcdqZk5n1m0G9gqwylxiWZ5bPVmR7nmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 007/457] KVM: s390: Fix _gaccess_shadow_fault()
Date: Wed, 30 Sep 2026 17:21:52 +0200
Message-ID: <20260930152346.190441186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit faff4c8ff3dbec6d71b89dd281a0d17c4478fa44 ]

In some circumstances, it is possible that the page of nested guest
memory that is being shadowed is not present at all in the parent guest
gmap. dat_entry_walk() will not find any leaf entry and return with
-ENOENT, which will erroneously be propagated all the way to userspace.

Fix by manually calling gmap_link() on the memory of the nested guest
that is being shadowed if the mapping was not already present.

Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260828115439.145885-4-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/gaccess.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 36102b2727fbf..7c1f614ec3146 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1593,12 +1593,25 @@ static inline int ___gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg
 	parent = READ_ONCE(sg->parent);
 	if (!parent)
 		return -EAGAIN;
+retry:
 	scoped_guard(spinlock, &parent->children_lock) {
 		if (READ_ONCE(sg->parent) != parent)
 			return -EAGAIN;
 		sg->invalidated = false;
 		rc = _gaccess_do_shadow(vcpu->arch.mc, sg, saddr, walk);
 	}
+	if (rc == -ENOENT) {
+		struct kvm_memory_slot *slot;
+		struct guest_fault *entries;
+
+		entries = get_entries(walk);
+		slot = kvm_vcpu_gfn_to_memslot(vcpu, entries[LEVEL_MEM].gfn);
+		if (!slot)
+			return PGM_ADDRESSING;
+		rc = gmap_link(vcpu->arch.mc, parent, entries + LEVEL_MEM, slot);
+		if (!rc)
+			goto retry;
+	}
 	if (!rc)
 		kvm_s390_release_faultin_array(vcpu->kvm, walk->raw_entries, false);
 	return rc;
-- 
2.53.0



