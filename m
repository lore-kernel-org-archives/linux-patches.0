Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B1C134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FB7C4339B;
	Mon, 12 Jun 2023 10:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566734;
	bh=0vnKo8/Us13qeB/i1FmFgZDX+T0GRXfgNVsjlW/3LDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCGERo1mkXUiY88qgf4edM0dKFTSbwqt+ZDpzAC0HHbJDAMoc2SpWNo343iHl1icO
	 BKZbtz+bnOKoAvMMZQR09EL35xFmjVGpD+SClrQvNUEr1pYFUPRY+e1Edg2DD90JR5
	 CRycizADUMid0uDFjqtoNaVDVBGfE940amJR22t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rhys Rustad-Elliott <me@rhysre.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 012/160] bpf: Fix elem_size not being set for inner maps
Date: Mon, 12 Jun 2023 12:25:44 +0200
Message-ID: <20230612101715.666281263@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rhys Rustad-Elliott <me@rhysre.net>

[ Upstream commit cba41bb78d70aad98d8e61e019fd48c561f7f396 ]

Commit d937bc3449fa ("bpf: make uniform use of array->elem_size
everywhere in arraymap.c") changed array_map_gen_lookup to use
array->elem_size instead of round_up(map->value_size, 8) as the element
size when generating code to access a value in an array map.

array->elem_size, however, is not set by bpf_map_meta_alloc when
initializing an BPF_MAP_TYPE_ARRAY_OF_MAPS or BPF_MAP_TYPE_HASH_OF_MAPS.
This results in array_map_gen_lookup incorrectly outputting code that
always accesses index 0 in the array (as the index will be calculated
via a multiplication with the element size, which is incorrectly set to
0).

Set elem_size on the bpf_array object when allocating an array or hash
of maps to fix this.

Fixes: d937bc3449fa ("bpf: make uniform use of array->elem_size everywhere in arraymap.c")
Signed-off-by: Rhys Rustad-Elliott <me@rhysre.net>
Link: https://lore.kernel.org/r/20230602190110.47068-2-me@rhysre.net
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/map_in_map.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 38136ec4e095a..fbc3e944dc747 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -81,9 +81,13 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	/* Misc members not needed in bpf_map_meta_equal() check. */
 	inner_map_meta->ops = inner_map->ops;
 	if (inner_map->ops == &array_map_ops) {
+		struct bpf_array *inner_array_meta =
+			container_of(inner_map_meta, struct bpf_array, map);
+		struct bpf_array *inner_array = container_of(inner_map, struct bpf_array, map);
+
+		inner_array_meta->index_mask = inner_array->index_mask;
+		inner_array_meta->elem_size = inner_array->elem_size;
 		inner_map_meta->bypass_spec_v1 = inner_map->bypass_spec_v1;
-		container_of(inner_map_meta, struct bpf_array, map)->index_mask =
-		     container_of(inner_map, struct bpf_array, map)->index_mask;
 	}
 
 	fdput(f);
-- 
2.39.2



