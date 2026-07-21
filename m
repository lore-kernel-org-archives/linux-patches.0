Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC79B46A5F9;
	Tue, 21 Jul 2026 15:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649053; cv=none; b=YjtVGHcmq3dzwK+DlmpyEyBZXWaKQjdHZ72RPfwO2wgSSlhqcvNRskxgqmCYKPwbOml24v9h8ztI3hOIeKpeys2783dY4+pXFXJJUgT9I90YaCkpw9WgQ3ggHUvouG3dkSNQOg8Fpu5XYxbp8SUjB+httUbdlnoiFolsMUx7joc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649053; c=relaxed/simple;
	bh=g9t0xcF2eDoXoBy5XjqPtvX5Wg78HoBV8yyQtapGOMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDPdvUWFme2n2aUH0pqkmwCnLchP6oLrr6guDboeros75roGCg+nvj/JYCtaS7vOnAmmnSzKlX4Wp/V26Ina6s34CgGorODCWyqkRftHWYuViLk0wCBrBKYnGM6v4h+Bqgu89aef2AKkohifRvXzM642y054TQux+c3AO8jxHuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkA10AYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkA10AYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27781F000E9;
	Tue, 21 Jul 2026 15:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649052;
	bh=nlMdJXLGraPkftSAIzLs8orChiuiqfu069/TWD6UbEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkA10AYTtloTOkCjuc+1h53BjshYRwQOWGRKDsKvYeCKbDXK6HSq5S/xBjHHOxHXz
	 Xm0P8y41iMCLskxnpgkUtrE0d6j4IeoU/AV90YbJLZab42m7Fi6DC0YbTSinITjy4v
	 BjX5n5R96RB8gPk+Qz6bd0bAkvxxuAHkQC6pP9JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0432/2077] libbpf: Skip max_entries override on signed loaders
Date: Tue, 21 Jul 2026 17:01:45 +0200
Message-ID: <20260721152602.939284460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 60214435b365ecdd40b2f96d4e54564b5c927645 ]

bpf_gen__map_create() lets the host-supplied loader ctx override a
map's max_entries at runtime (map_desc[idx].max_entries, when non-zero).
This is how the light skeleton sizes maps to the target machine, but
it happens after emit_signature_match() and is covered by neither the
signed loader instructions nor the hashed blob.

For a signed loader this means an untrusted host can re-dimension the
program's maps, outside what the signature attests to. Gate the override
on gen_hash so signed loaders use the signer-provided max_entries baked
into the blob.

Fixes: ea923080c145 ("libbpf: Embed and verify the metadata hash in the loader")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260601150248.394863-6-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 0cb14e030b8be6..40004aa3af71bc 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -545,13 +545,22 @@ void bpf_gen__map_create(struct bpf_gen *gen,
 	default:
 		break;
 	}
-	/* conditionally update max_entries */
-	if (map_idx >= 0)
+
+	/*
+	 * Conditionally update max_entries from the host-supplied loader
+	 * ctx. This sizes the map at runtime, but for a signed loader
+	 * (gen_hash) it would let an untrusted host re-dimension the
+	 * program's maps after emit_signature_match(), outside what the
+	 * signature attests to. Keep the signer-provided max_entries
+	 * baked into the blob in that case.
+	 */
+	if (map_idx >= 0 && !OPTS_GET(gen->opts, gen_hash, false))
 		move_ctx2blob(gen, attr_field(map_create_attr, max_entries), 4,
 			      sizeof(struct bpf_loader_ctx) +
 			      sizeof(struct bpf_map_desc) * map_idx +
 			      offsetof(struct bpf_map_desc, max_entries),
 			      true /* check that max_entries != 0 */);
+
 	/* emit MAP_CREATE command */
 	emit_sys_bpf(gen, BPF_MAP_CREATE, map_create_attr, attr_size);
 	debug_ret(gen, "map_create %s idx %d type %d value_size %d value_btf_id %d",
-- 
2.53.0



