Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAAC350A2A;
	Tue, 16 Dec 2025 11:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885743; cv=none; b=YlIb4QdssRbuLUdx9e5tgtvUFKUiS0BKB1CwNPENi4IORK78LUkxQhrIEXDjVp3gRpW4KOOylMikuP/mJy681mZfRvU1s/AZCDWD/jGgx4iijVibHG1a9IPnC7KO7F6Pkc9CnPppTR/GnGjgrTOZ/aOqzxu4drX65dhclkIzT/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885743; c=relaxed/simple;
	bh=hZDTBEvnhKmnXVvzQlgTED9u9QDDZ45LpDCvDOEMioU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P00oxQo7mbM99xftszzVyjZ1FgI7QolhNelssHSxg4Ucx8ZGjtfvaKjslzPshMVYp+q3CG05VV1BX8d+s9Wq72uFRmwtE3FDfoaH0Df2Onw3ij5Ex0wf/L9mGA5D519/HwCBxqhjDc8ZR3VZOwcpx9oaWWsnOQIKzI0m0jCZwlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIbI5mXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIbI5mXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A68C4CEF1;
	Tue, 16 Dec 2025 11:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885743;
	bh=hZDTBEvnhKmnXVvzQlgTED9u9QDDZ45LpDCvDOEMioU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIbI5mXLeYPuvKQn3mk7mcZSs3snpRfuPxtbytDhnUd/ctXPPvLyQT2NpzYXq4r25
	 60S5l15Im/hvkt8TQ6k6wRp7yqf8ptpxtxCHdU6zajr3lkKROKIncSvudEjeojeozA
	 yKc/A6dkjX8OX+fq76NT1kHfvIcCs4or2B5RrWiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 231/507] bpf: Free special fields when update [lru_,]percpu_hash maps
Date: Tue, 16 Dec 2025 12:11:12 +0100
Message-ID: <20251216111353.871774335@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 71f9931ac64cd..f3bc22ea503fd 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -939,15 +939,21 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
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



