Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF58326D44;
	Tue, 21 Jul 2026 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656221; cv=none; b=FnvD1CAEUh4eiTkvlVCPGVzjFGyVE9nYS4Ddb/neZ1VHbFz0RZ7Ab6YwEeuHI5KtLA+51somBBGYlXNBgFAHWjb9T5LvePmpjvFpZg5ESSNnXdd8G7XfRzrbI0lPvN1IHnKFkvQw4r3XHmlTEAFJO8q8oYZHCxwG6kY0DqdQJjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656221; c=relaxed/simple;
	bh=T3neQMlUmh71wx0G2O8rW43HWTb6WZImvXJMYSdxLH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWkbaqDIqLo6yu5hz9laxz2P7Tccj2YOLdNaA4q8sCCFdHiA5j0raaGIWr3X6u20SLnqHoEinVYusarJMJEJo3rsBpG9G7IVb9gUFxUefowz47iQ6ZHPp6u2XSBo5GtMNjFnk1RsUR2EgsJkhP2JhfRW0bpBUCUMNM+ICe/UPJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gn18i2nV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gn18i2nV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1030C1F000E9;
	Tue, 21 Jul 2026 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656220;
	bh=4TtQ9aIA359o+r7Z+3ea46xBDs6aBypkidFeM2EqSLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gn18i2nVMiWtSPYQpYDB5gQZGloYyQ3BcfRC4A9b+ktcadwKpOjYoMFih3JcrEaxu
	 RA2+KK/7iXfTmE06fySdXuwmpSwIiYVQV9ybToDRTdcI/qILfiD3SPVT80vgQ3A5gc
	 LiMeiKC+YSGTdscJMfNidaqPZPE0GorLSdJgkMYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0305/1611] libbpf: Skip max_entries override on signed loaders
Date: Tue, 21 Jul 2026 17:07:01 +0200
Message-ID: <20260721152521.933892569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f0898244f20ac9..d41defa1936d33 100644
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



