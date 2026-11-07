Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063220;
	b=X1WY0/jrPq/bekQBLebPli1k7H9YpasPkIU8gEzY9al3vm2ZtlCo8fJpNoAYwxYb8d+3
	 JzFXb9cHdT3vc+TFIDm84Oze3QWrb+lyT/r7Pa+kg23oFVCn7hBZxa693JFwLuKG1qyOw
	 zfsmfE0h65fiNgUJWn/4PHWIVFBsOy8tweZz/668C8w+T8lAfx2Em8uR4kAe/rXV63p1k
	 ViEgD6qBn9R8HuK/eKOnGRxCEBbM1Z4dxGJN53bDASW0zTdPkqsk0Wibx/Boe/geMEWml
	 d5rR8RSk9dcSC9D7GMBDB/xs4ymGwxniawmjf54c+9Kk/g4oLqGSUcyGHaHBv6YIyEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T+zq/4ApYdhThUsxFv7sIeN0agn28ZB5ZxwksaeVzVE=;
	b=bn63GAqsdixTuX7Uq7nUCYl6IUFOcnoVufnkO5Ou/BSXFlQfHllmeu5veug+c3KYqpej
	 VHfXzOBZXWHMB8pRVWmYbNLrUPc2hc6nLcuttjFPKIsbhXxsbE6XBk+WzEh7voERepMDs
	 PLXhjIHTbgd00x18cbZowFFuSNxQ4U37ddDFfPNw7Z1iaHDIeQwpJJnytWZDGIAE3Tw/y
	 DzkFYIw44/QmBGLnn5HGCrx8muDr8vcbe1/dncQ/VqwUJUI4Pxdy1b0zG62qEOpPdlDvC
	 vmUM1UoG3MeSoUwpZDVI6ucdtT7Xwr6OvKFlazgF/xbEYtyW3pfZzrA0Z1+14mfrOsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlExhekv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A13E606A337;
	Sat,  7 Nov 2026 14:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlExhekv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494881F008A1;
	Sat,  7 Nov 2026 14:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063219;
	bh=T+zq/4ApYdhThUsxFv7sIeN0agn28ZB5ZxwksaeVzVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlExhekvN2uU5WJpOnLjqkLiqt1DcPJUyaMVCLXOUZCCU5kxOjSkf5/UFiGsXPGYg
	 McldfT75ayRaCOr5LyPvpkfug8KvkL+RXkrYIJT3O0kmmELZbFq7z2qqFQ8QgSohFl
	 ISu9WWi+30cqZv8SfqokV1NquC3fV/Frf7eXUy64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasios Papagiannis <tasos.papagiannnis@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Hajime Tazaki <thehajime@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 428/869] mm/nommu: reject wrapping ranges in access_remote_vm()
Date: Sat,  7 Nov 2026 08:51:50 -0500
Message-ID: <20261107134908.358991482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>

[ Upstream commit 51a8de81fd2edbf87d8046e352060329bb216fad ]

The NOMMU implementation of access_process_vm() rejects address ranges
whose end wraps around, but access_remote_vm() bypasses this check even
though both functions delegate to __access_remote_vm().

Move the wraparound check into __access_remote_vm() so it applies to both
entry points.

This is originally reported in [1].

Link: https://lore.kernel.org/20260909064231.18693-1-tasos.papagiannnis@gmail.com
Fixes: f55f199b7d76 ("NOMMU: implement access_remote_vm")
Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/ [1]
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Hajime Tazaki <thehajime@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/nommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index c3a23b082adb9..d609ecdcf022b 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1644,6 +1644,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
+	if (addr + len < addr)
+		return 0;
+
 	if (mmap_read_lock_killable(mm))
 		return 0;
 
@@ -1697,9 +1700,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 {
 	struct mm_struct *mm;
 
-	if (addr + len < addr)
-		return 0;
-
 	mm = get_task_mm(tsk);
 	if (!mm)
 		return 0;
-- 
2.53.0



