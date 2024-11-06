Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39CB1E103C;
	Wed,  6 Nov 2024 12:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897839; cv=none; b=CtzWFsJItd+Vt+0GcH+W13T89jjMmDDPLj7IMdRIkWW93jLV/0LDCpv9/jn5FcRuMjOcs9siRdLrW6iyof9RuK4X7dMkJZqAqAVhcv6Esi1l0tJ4vdPz4h+NPQck6ladgi8ptCi1U03dGM3D4BHVcJqaKuQVacmdwhbGeuNWPOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897839; c=relaxed/simple;
	bh=wJpumwltiGFMVHUFEV6+RoZ0giuiLgcpeFLg0CTNiXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DsNyBhPEpTEM8Wwee/mhoShsOik3SCWguiOeKDn4q6LK14TjJj1lYYR1z/XA3j+0sF+OzYuUBWF+z35zbLuggaTrPU3qd3s+sGc4QFWafri8/Y1u24H5WQaldxlIENmwJRZiCBun4XNPbl5EoiQ4a/FNe0NroICZRoo+15zgt90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rq2yZiq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rq2yZiq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DAAC4CECD;
	Wed,  6 Nov 2024 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897838;
	bh=wJpumwltiGFMVHUFEV6+RoZ0giuiLgcpeFLg0CTNiXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rq2yZiq5MBY65Pqf7dUYm37dW54gxlcdQ2IeGdBSNoSk8majAe3+5T8pU4tZ0lvQA
	 7hhggKUkTQlO4IgU7ndYDxqKfgNGFRbvbU1/ZOna1BAHsiixjh1ULGm4IR+IV/erbh
	 cUIRatVhTCBMZ43x/kRQbotxbTS0GDjmnDyGr98o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	syzbot+8cd36f6b65f3cafd400a@syzkaller.appspotmail.com
Subject: [PATCH 5.4 029/462] bpf: Fix DEVMAP_HASH overflow check on 32-bit arches
Date: Wed,  6 Nov 2024 12:58:42 +0100
Message-ID: <20241106120332.237906814@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit 281d464a34f540de166cee74b723e97ac2515ec3 upstream.

The devmap code allocates a number hash buckets equal to the next power
of two of the max_entries value provided when creating the map. When
rounding up to the next power of two, the 32-bit variable storing the
number of buckets can overflow, and the code checks for overflow by
checking if the truncated 32-bit value is equal to 0. However, on 32-bit
arches the rounding up itself can overflow mid-way through, because it
ends up doing a left-shift of 32 bits on an unsigned long value. If the
size of an unsigned long is four bytes, this is undefined behaviour, so
there is no guarantee that we'll end up with a nice and tidy 0-value at
the end.

Syzbot managed to turn this into a crash on arm32 by creating a
DEVMAP_HASH with max_entries > 0x80000000 and then trying to update it.
Fix this by moving the overflow check to before the rounding up
operation.

Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devices by hashed index")
Link: https://lore.kernel.org/r/000000000000ed666a0611af6818@google.com
Reported-and-tested-by: syzbot+8cd36f6b65f3cafd400a@syzkaller.appspotmail.com
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Message-ID: <20240307120340.99577-2-toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/devmap.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -130,10 +130,13 @@ static int dev_map_init_map(struct bpf_d
 	cost = (u64) sizeof(struct list_head) * num_possible_cpus();
 
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
-		dtab->n_buckets = roundup_pow_of_two(dtab->map.max_entries);
-
-		if (!dtab->n_buckets) /* Overflow check */
+		/* hash table size must be power of 2; roundup_pow_of_two() can
+		 * overflow into UB on 32-bit arches, so check that first
+		 */
+		if (dtab->map.max_entries > 1UL << 31)
 			return -EINVAL;
+
+		dtab->n_buckets = roundup_pow_of_two(dtab->map.max_entries);
 		cost += (u64) sizeof(struct hlist_head) * dtab->n_buckets;
 	} else {
 		cost += (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);


