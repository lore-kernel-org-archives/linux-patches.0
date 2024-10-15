Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A78A1C07DB;
	Tue, 15 Oct 2024 13:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997543; cv=none; b=jx3PY3GdZ3YMB1WVHuJcEVHuWEUD5D6VfafgKKHsys8ZWsdy0+zbit8fQpODf8wOs4b2BQ2TKEQBNrgVWcBGVYETLhXm9VGtVoJLHTn9yPHH/cRcSCAD4c6GksmAM4qTwqxaD9gdpqfyi2/db06sxciXZkBFWRKUiTYw4+O/36I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997543; c=relaxed/simple;
	bh=JwOHyxWXWzb9x7+pgDeNedJF0wRcI2K711JGd9LzlcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z8KO57NnLC4qX1JR0hxSVGKmoWjJMYDij/SDzldgXLqvx7smmaepikK/sOD1afMb1Se12xQrGPt4WdRQSkJZmjU5V1/eOAoA+hsGHq7mW9amUiECe4n9XmJlG6fiQCICMyrrfXR1sfA9SSJxZwUDf0U5O/XeQHABCSyVVZ9VVto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgomaNgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgomaNgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E212C4CECE;
	Tue, 15 Oct 2024 13:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997543;
	bh=JwOHyxWXWzb9x7+pgDeNedJF0wRcI2K711JGd9LzlcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgomaNgV/6OIElB9wlsYeUANDEjQRxfK2U1JlWezxhNz1AanThZ9PY209O6a9bL/V
	 w8gZd+nbVgRiJ33d5zpTS8YwKQqo99ZtuUHvGlGJt96clBT0ZFVDqCqhF0r9XgSOkH
	 Z5r9DDcNtL3o9jxu8Wzj1hfYmDRmT/8JoAnamSaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=F8iland-J=F8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	syzbot+8cd36f6b65f3cafd400a@syzkaller.appspotmail.com
Subject: [PATCH 5.10 214/518] bpf: Fix DEVMAP_HASH overflow check on 32-bit arches
Date: Tue, 15 Oct 2024 14:41:58 +0200
Message-ID: <20241015123925.253120323@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 281d464a34f540de166cee74b723e97ac2515ec3 ]

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
@@ -131,10 +131,13 @@ static int dev_map_init_map(struct bpf_d
 	bpf_map_init_from_attr(&dtab->map, attr);
 
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


