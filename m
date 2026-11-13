Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590840;
	b=pHJ05LvW2LgTgMcZYFLhRDMHlOxGgt7whEJjaVcU9XVobzPcNatg8wMFo/+3Dl5yCLRf
	 pDcu9imSpSxohhUoyafsGgzstKCBHyHxaCLfLWOMxZCAg8iswM57rWDygcS7qtgpW0cK8
	 vd5nt1G27L7f5N4yHS4LlqdR8IFPfIrQwcQbaNElRHabBzlh1iK2saf0+1afS0tw8C5LR
	 rtm+FZP1yviqMWWp7fV9QKffUDpE85Ekqe++ZqxCFHafz3NoF3CH4bRJxwxortSWNXCj+
	 q1gZajQVH9BC+hqUKFAauq4GG+IDo1bShs4DLt9KkWkdrKovJiPokIlfL73g98hDEeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RiHQnc+4HdckSlooHJwIc5eIKebvXU6eZevewlxEE4U=;
	b=rSjdms4Yys1zCaXygHK7KfjUC9tmyKlNTwA6AhKk20/CLcHJqpQ0rr63O3TepkKijPeO
	 Q+L4Vf+HDtcX4qoStJR7N7K5lkSVpoHcAyOQfkl40wmQssFLyvccwEvK7OefFoq1VdVGU
	 ZLIVa16vM7lcoOIda/P1IEsymLhxGJbhBuHCfkm7Y9JFHi+NHIQkg/VkQpWHMw9NBc8oA
	 Hm5qrdAwOV7oZ9TRa26HM+ubGCOdjMtIEDsm37YmGSOh8fCnk6Z+Im2GtMfuBaauAHGF+
	 VWrfa74oXZLNJndijz7wjvNzNiO1E6kNUi05kXmGy2R7JE4w5YCZVMFvf/Yb9Rmv7mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAJj7BxC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0880607E07B;
	Fri, 13 Nov 2026 17:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAJj7BxC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEAB1F000C4;
	Fri, 13 Nov 2026 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590840;
	bh=RiHQnc+4HdckSlooHJwIc5eIKebvXU6eZevewlxEE4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAJj7BxCWOHkfQjbdHnAO1ARbHHypZY1EA2j6o4JVvEWE8dyPdgr9i42JnIOvMSfR
	 qV05fHFrieKjxwQBBJCd8YhhbP0LNE9cCQfetPWEzekOSjCz8wC/0z0w70XdZHKy7v
	 DCSzYgy+ple7UNU8TdY+tfqDXHA2i5gzgskbiaIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/670] KVM: Only bind memslot to guest_memfd instance for CREATE operations
Date: Fri, 13 Nov 2026 10:43:26 -0500
Message-ID: <20261113153812.591248679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 513333a5546017da2a4a6173bfb70372f83733b3 ]

For additional defense-in-depth, and to avoid having to handle impossible
unwind scenarios when binding to a memslot fails, bind a memslot to a gmem
instance only for CREATE operations, i.e. don't attempt to establish a
binding for MOVE and FLAGS_ONLY operations.  And when FLAGS_ONLY operations
are eventually supported (this is currently all dead code), creating a new
binding would be incorrect; KVM instead needs to do a 1:1 replacement of
the existing binding, i.e. FLAGS_ONLY will need its own dedicated handling.

Update the relevant TODO to make a better guess as to what needs to be done
to support toggling dirty logging for guest_memfd memslots.

Because it's dead code, no functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://patch.msgid.link/20260922001332.1121266-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0d017f75c5a11..c574cd2f4f722 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1740,10 +1740,10 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 			kvm_destroy_dirty_bitmap(old);
 
 		/*
-		 * Unbind the guest_memfd instance as needed; the @new slot has
-		 * already created its own binding.  TODO: Drop the WARN when
-		 * dirty logging guest_memfd memslots is supported.  Until then,
-		 * flags-only changes on guest_memfd slots should be impossible.
+		 * TODO: Drop the WARN and do the unbind() call only for MOVE
+		 * when dirty logging guest_memfd memslots is supported.  Until
+		 * then, flags-only changes on guest_memfd slots should also be
+		 * impossible; unbind the old memslot for defense-in-depth.
 		 */
 		if (WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD))
 			kvm_gmem_unbind(old);
@@ -2102,7 +2102,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
-	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD)) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
 			goto out;
@@ -2115,7 +2115,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	return 0;
 
 out_unbind:
-	if (mem->flags & KVM_MEM_GUEST_MEMFD)
+	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD))
 		kvm_gmem_unbind(new);
 out:
 	kfree(new);
-- 
2.53.0



