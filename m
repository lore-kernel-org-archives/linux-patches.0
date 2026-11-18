Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021223;
	b=baH2jzDmEIHiVDGi7lGtz2wlUmxyJ997iR32m3ngWrKIDF5rotAIjZmNdn/yiH3MYeGM
	 TZi6i4VAsT86ynn+mHQJIrX8aqXVCHMsOT/DQ2cvYvVKt1DymqliyHqEegVE6mAy5qDlX
	 Xqf+8XvqD2ozW4tuRvjpiBP1vlZTmWMip95Zy/kf5G8F8tyxbM/++Ch+/xKymswFAm9as
	 x1U3qtWJjeJ8CpV+tvMzKMQmJvHL+qNnkE5nPKc2/eec7WNqUgxYl4yPWxSzmJrcWsuKP
	 cUV7aygmSwqcm/xjvdBOidtw8/mYtg2eLxtJwSGbAGIJD09XZkcQhNBfEmukkbJxn0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VL3qYv6uRGdX+vGZPzueiq1My9fs1VDzJGDxe5WsJEc=;
	b=zsURxDfL7hkjuDuNWnHjPuHbCAsG+ivt5FRLd9xUcrwpco8+3i7F8gAp5XNUu9U73Sv6
	 /UjHdqSuUXj6s8AP4jgKUDyCSyro3b+NoHV6LBBiMD5LqcPk0rAaMokOOVU1YZLFMjGuB
	 +7MNIorL9xoIU5/ra9HA8gqb6eDaFZAlBoh2Y7i1Qxt1srDTQ3XvoGoiooudUN103kq8Z
	 Kl0SPUvi3w4B8I38Tg7ZW6OIwjwblw0OW+9PLXi5FXnAih40jsZvrgS//RVHDAxthgjOa
	 GPHUqzMYe44JegvsWiPNNUNdi2y8X+LAaebFdHaX/cD0lOlepSknmrfYpGZdOuq6MVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HswEC13d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EFF606A31C;
	Wed, 18 Nov 2026 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HswEC13d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4521F000C4;
	Wed, 18 Nov 2026 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021222;
	bh=VL3qYv6uRGdX+vGZPzueiq1My9fs1VDzJGDxe5WsJEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HswEC13dgtpaEQQ7vylaMYFCLwx5OQC1u+0uyMRlt/Aq8IzG2I0n5KpUEd0oojeIn
	 /pvJbGZCPMYGUykLcQMLZyivkTGneQjoCZbTiETRTBWLrkfX5rz8ngI81GkEd4L1xV
	 9vjIeCf6/pU+BSej16d62cI7yNM5WcEkagA4Gv/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2189/2651] bpf: Revalidate faulted arena pages before installing user mappings
Date: Wed, 18 Nov 2026 15:57:09 +0100
Message-ID: <20261118150404.573934040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tsalapatis <emil@etsalapatis.com>

[ Upstream commit 05bee0638bacf4e9298bbf0bfef749b6a8ff4478 ]

A user fault on an arena pins the page that the kernel arena maps,
drops the arena spinlock and returns the page to the core fault code,
which then locks the folio and installs the user PTE. A concurrent
free can clear the kernel mapping in that window. The page reference
prevents a use-after-free, but the fault can still install a user PTE
for a page the arena has already released. User space and BPF programs
then see different memory at the same arena offset.

Close the window from the fault side. Lock the page, recheck that the
kernel mapping still points to it, and return it with VM_FAULT_LOCKED so
that it stays locked until the core fault code has installed the user
PTE. If a free removed the page, drop it and return VM_FAULT_NOPAGE so
that the fault starts over. Return VM_FAULT_HWPOISON for a poisoned
page.

This change alone does not close the race, because the free path does
not yet wait for the page lock. The following change makes frees wait
for in-flight faults before zapping user mappings.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261019201108.4552-2-emil@etsalapatis.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 0ff707707da04..5e0e0837980b4 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -584,8 +584,22 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
 	if (new_page)
 		free_pages_nolock(new_page, 0);
-	vmf->page = page;
-	return 0;
+
+	/*
+	 * A free clears the kernel pte and then takes the page lock before it
+	 * zaps user vma-s. Either it waits for this fault and zaps its pte, or
+	 * the page is gone from here.
+	 */
+	lock_page(page);
+	if (vmalloc_to_page((void *)kaddr) == page && !PageHWPoison(page)) {
+		vmf->page = page;
+		return VM_FAULT_LOCKED;
+	}
+	/* The page was freed meanwhile. Let the fault start over. */
+	fault_ret = PageHWPoison(page) ? VM_FAULT_HWPOISON : VM_FAULT_NOPAGE;
+	unlock_page(page);
+	put_page(page);
+	return fault_ret;
 
 out_err_locked_memcg:
 	bpf_map_memcg_exit(old_memcg, new_memcg);
-- 
2.53.0



