Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF79B2DEA6F;
	Fri,  9 Jan 2026 11:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959723; cv=none; b=TjfCm45RJnFnk8ArpEUzaf4eR3ragj4k8MldBmfX+MBtPqJeW2RG6wFwW/7sHtlZqY31ZSkbKw3BgG+7T0pfDYfROUXhlsah46CCG35TiT+3gB5rF2M5Xm0I3DQZ0T8zTqVO6xPcqfFyT6IQk5CAtmJgd0CGuS2GXTblsnQEHKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959723; c=relaxed/simple;
	bh=ciYRqC6gU4NpvSZwHpurON4Ap6SXR3w/82end/3XDNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SS4+UT2BhOtsvhs8rn+B6y7gnxGTZBfYuDoX58hbJ4a6dd1zr3gU6TiWzv+DtjtGdLI57niKhics4/3ruWwdvCIVigIQae39oSJFb0WGb0mhNicEVBSoka11BJOQ4P/CDBIwV7jjYPLv6HzDuQ6c9ezsM2uJxi319p3PpMlvPoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXsEtDbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXsEtDbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5A5C4CEF1;
	Fri,  9 Jan 2026 11:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959723;
	bh=ciYRqC6gU4NpvSZwHpurON4Ap6SXR3w/82end/3XDNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXsEtDbAWIKT0Ns7DUm+87XTD34Zzn0KagLryFMv00LAenjA7ivAhpUetTA0Xo+0H
	 3o1joXuNG7vrE/29lXjW7rVW7jKUFU4pHaeH+vLLNbN0ZLNUqHZ9uHtvaqCqCzF3Gn
	 pO3FxXAZK6XO2U7QOAbbOTfDAHsvfZTl+Y9wUQPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/737] bpf: Free special fields when update [lru_,]percpu_hash maps
Date: Fri,  9 Jan 2026 12:34:52 +0100
Message-ID: <20260109112139.753137882@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 6af6e49a76c9af7d42eb923703e7648cb2bf401a ]

As [lru_,]percpu_hash maps support BPF_KPTR_{REF,PERCPU}, missing
calls to 'bpf_obj_free_fields()' in 'pcpu_copy_value()' could cause the
memory referenced by BPF_KPTR_{REF,PERCPU} fields to be held until the
map gets freed.

Fix this by calling 'bpf_obj_free_fields()' after
'copy_map_value[,_long]()' in 'pcpu_copy_value()'.

Fixes: 65334e64a493 ("bpf: Support kptrs in percpu hashmap and percpu LRU hashmap")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20251105151407.12723-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 8a3eadf17f785..8bac6ae1204dc 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -957,15 +957,21 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
 			    void *value, bool onallcpus)
 {
+	void *ptr;
+
 	if (!onallcpus) {
 		/* copy true value_size bytes */
-		copy_map_value(&htab->map, this_cpu_ptr(pptr), value);
+		ptr = this_cpu_ptr(pptr);
+		copy_map_value(&htab->map, ptr, value);
+		bpf_obj_free_fields(htab->map.record, ptr);
 	} else {
 		u32 size = round_up(htab->map.value_size, 8);
 		int off = 0, cpu;
 
 		for_each_possible_cpu(cpu) {
-			copy_map_value_long(&htab->map, per_cpu_ptr(pptr, cpu), value + off);
+			ptr = per_cpu_ptr(pptr, cpu);
+			copy_map_value_long(&htab->map, ptr, value + off);
+			bpf_obj_free_fields(htab->map.record, ptr);
 			off += size;
 		}
 	}
-- 
2.51.0



