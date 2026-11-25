Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624133;
	b=2BSgO9UJ4ZgigBAevwM5kVQsAHur8WHDadGUds/dmaL8j3nLkQYoS7fFwXF7PevH82VH
	 EsgYQFpaDq/OaGwkrZ6i+XboVfJRAjof4OuaCSjzrxOd3xsTR2rkj8rcMoC0bjjM/hC1z
	 9i2fzxbR5wkaNyW/BgUBNXEEvrq3RktAm9wP1nj6hRKCaVJFsxU6q0QcxwGBPrzRkb5pO
	 fPrw3lJDJf6RtVuhVHPHnkfpXPrvx2ODk3kAGzrQIsDAXrCFUkspBSJWZFrC3usalTgJa
	 RB7FSrKiz+M1FqufJmVIxDKsNoBZmgkLRDhmMoLGWOx7BarPksMPOjRvt4IF+u2Cxow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uK89TDzv8zXJsf67QB15NJcZ/5rzgSAsK5ui9J1eCCw=;
	b=qlGLrtCQJNYYZxVGS+NpndwYdmYGiCyOCxR1mSv9N/oSV32Wx2xZisv4tG9kkeu2Q11G
	 zRDAW7UnRPXXBLWqkHqBK90DGHsZ2ySJaNdoHLgL5JFLesJFdFjm+EEwUT0LIWLEqrsC3
	 5SWU1mrbwCn0yk7rV+NHJfPNfmKXShiU9LwlrAZVuKBRLqvIbvX70Jn9p3pXBlt9gqpDW
	 9SJxa2mMLlYui4g1jYbMwUOf/HR3fzqg+UyRwgnpplxYY9vl/Np9Og9g8EQOJ1ZQZ5GWi
	 NzvMEYEYmJeyLU8t5vCwMiYr+luey5QlvammfN9YGVfYIg/czxLMZTVVufk235QeSfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ih2tD4BI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B227606A337;
	Wed, 25 Nov 2026 16:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ih2tD4BI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D63F1F000C4;
	Wed, 25 Nov 2026 16:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624133;
	bh=uK89TDzv8zXJsf67QB15NJcZ/5rzgSAsK5ui9J1eCCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ih2tD4BIx+14JrOCeDod8cZSkF3TPsS7UAnsLMbzbD5soFIQgOUyaMQsjxjyWDXaQ
	 s89Ts3iTkV2Tvybn0esIKw1WMLsTLRB7YEktbw0ssf6Er6FC6evhtq9xBZ9XWddeg7
	 HqexZzF7PUNEBB5aecGzsjKEFPXcmb/tWuOvtnPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/816] bpf: Refuse an arena mmap() longer than max_entries pages
Date: Wed, 25 Nov 2026 15:27:25 +0100
Message-ID: <20261125143851.464612858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 1e01345b87f13c354687360cb81ed2a521ff2b13 ]

arena_map_alloc() puts max_entries free pages in the range tree of an
arena. But the arena kfuncs check their arguments against user_vm_start and
user_vm_end. Without map_extra, arena_map_mmap() takes both from the first
vma. This vma can be up to 4 GiB long. Then arena_free_pages() also marks
pages as free that were never in the range tree. Thus max_entries does not
limit the memory of the arena, but these pages are inside kern_vm.

Refuse an mmap() longer than max_entries pages with -E2BIG. With map_extra
this limit exists already. libbpf always maps max_entries pages. Replace
both SZ_4G checks with this limit, because it is at most 4 GiB.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-6-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 598920ac256dc..345c77f7cd2b5 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -325,7 +325,7 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 
 	if (pgoff)
 		return -EINVAL;
-	if (len > SZ_4G)
+	if (len > (u64)map->max_entries * PAGE_SIZE)
 		return -E2BIG;
 
 	/* if user_vm_start was specified at arena creation time */
@@ -373,7 +373,7 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 		return -EBUSY;
 
 	/* Earlier checks should prevent this */
-	if (WARN_ON_ONCE(vma->vm_end - vma->vm_start > SZ_4G || vma->vm_pgoff))
+	if (WARN_ON_ONCE(vma_pages(vma) > map->max_entries || vma->vm_pgoff))
 		return -EFAULT;
 
 	if (remember_vma(arena, vma))
-- 
2.53.0



