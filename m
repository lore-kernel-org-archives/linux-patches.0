Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620039;
	b=Z36oHMvzrOgEvUHQB+Mf7eP6L4NVN62YzEFYDDBXFZNIxX7wpPgvmrqCqg2F5S+m9b8s
	 pBW2D/CuMGwiMlHeOQJ+jDcm3ybwTUBNFqNBIWKcsJc/VHe6t12DCnUCIHQR+lKoqETT9
	 U49q/yHHQpBhZ80PGsrtr580i6ikatNnu3NV6ZtxeBztg9fEDnrvSxqsHSEuY1VYuORMa
	 bPcbqj29J18SXabAH4GunzFyN2sPCOZVnCrVkATRIVothNsh4f9uax9DG7xS34XkGZKaU
	 syJ06YyKm94etkew2nqp2vJr0gfyZtNK8H1Z8mryxExivsLv8852ZivfSqkX+s+Zvvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bkifOJmWzmfDa0w2tNyQGm0puaphFFKHnGwKR/ytD1U=;
	b=WBuJFQVR4nZSoTOWj6idVvXUSpikUldlNwR5Vi2izvy10ENP7msefLfGMlIrROm6S26n
	 42k+/HiN45MY1VgNfDb7klEZS+CKLdpmU71kcsuO/JS5et4H5KPptvTEDZT1Y+EdjsA33
	 cjuRY1CtMwbWLfYixzuN7mFZdnWCQYQvnRQ8f4r+GzUHgpzRNtXvY6YNyRWB3Vkq0HvJ2
	 TbY6X3n5/WH+xaAdpfaUMgvaeryBTL1h5earlpzEc9sM5W2C0G9jVAsFTCusNiJzmPmHj
	 yQ6TbjCNEytoUQovqaKhrZbrYw1TbGVPdweR+xvMcCHs9lsfI2Okph0EPS1lOwxpj7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5hLU8Sm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4FE606A321;
	Wed, 25 Nov 2026 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5hLU8Sm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC77A1F000C4;
	Wed, 25 Nov 2026 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620039;
	bh=bkifOJmWzmfDa0w2tNyQGm0puaphFFKHnGwKR/ytD1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5hLU8SmxgCEkCNMAQZr7ySDpKRS4dCkpN6bVRes3KjEkzg+aBm6CIjmH7323iZAg
	 I9VDDcZdSH2G1Yk1Wc1lqAgdJ9j6XOjeeb0KuAjNwlGwLNFpmEzzjYUnQhKJxSKiDM
	 D6eBODgnXILg8mczRYiGsx1U1JoWxLXNZUXGqcF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0787/1005] tracing/probes: Fix BTF bitfield parsing and out-of-bounds buffer write
Date: Wed, 25 Nov 2026 15:35:25 +0100
Message-ID: <20261125143840.176473557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 9b6e9d6a11090ac34516c45f48663b37ac94a9b1 upstream.

BTF bitfield parsing in trace_probe.c assumes a 64-bit (8-byte) container
when computing FETCH_OP_MOD_BF shift amounts and basesize, whereas the
preceding store instruction only allocates and writes the field's fetch
type size (which may be 1, 2, or 4 bytes when kflag=1). At runtime,
fetch_apply_bitfield() performs an 8-byte read-modify-write on the
smaller ring buffer slot, corrupting adjacent ring buffer data or writing
past the end of the event record.

In addition, signed bitfields with bit widths other than 8/16/32/64 fail
to resolve a fetch type, bitfields whose width is a multiple of 8 inside
a larger integer or spanning a byte boundary fail to emit FETCH_OP_MOD_BF
or select a container wide enough for bitoffs + bitsize, kflag=0 bitfield
offsets >= 8 bits are not folded into the byte offset, and big-endian
architectures use the little-endian left-shift formula in
parse_btf_bitfield().

Compute the bitfield byte and bit offsets consistently during field
lookup, select the smallest unsigned fetch type that covers the bit
offset and bit width, and calculate the FETCH_OP_MOD_BF parameters from
the selected fetch type size for both big- and little-endian bitfields.

Link: https://lore.kernel.org/all/179455850711.403392.10512730891220678403.stgit@devnote2/

Fixes: c440adfbe302 ("tracing/probes: Support BTF based data structure field access")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |   59 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 14 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -486,6 +486,18 @@ static const char *fetch_type_from_btf_t
 {
 	u32 intdata;
 
+	if (ctx->last_bitsize) {
+		u32 bits = ctx->last_bitsize + ctx->last_bitoffs;
+
+		if (bits <= 8)
+			return "u8";
+		if (bits <= 16)
+			return "u16";
+		if (bits <= 32)
+			return "u32";
+		return "u64";
+	}
+
 	/* TODO: const char * could be converted as a string */
 	switch (BTF_INFO_KIND(type->info)) {
 	case BTF_KIND_ENUM:
@@ -520,10 +532,6 @@ static const char *fetch_type_from_btf_t
 			case 64:
 				return "u64";
 			}
-			/* bitfield, size is encoded in the type */
-			ctx->last_bitsize = BTF_INT_BITS(intdata);
-			ctx->last_bitoffs += BTF_INT_OFFSET(intdata);
-			return "u64";
 		}
 	}
 	/* TODO: support other types */
@@ -653,6 +661,12 @@ static int get_bitoffset_of_field(char *
 		/* Add anonymous structure/union offset */
 		bitoffs += anon_offs;
 
+		type = btf_type_skip_modifiers(btf, field->type, NULL);
+		if (!type) {
+			trace_probe_log_err(ctx->offset, BAD_BTF_TID);
+			return -EINVAL;
+		}
+
 		/* Accumulate the bit-offsets of the dot-connected fields */
 		if (btf_type_kflag(mtype)) {
 			bitoffs += BTF_MEMBER_BIT_OFFSET(field->offset);
@@ -660,12 +674,15 @@ static int get_bitoffset_of_field(char *
 		} else {
 			bitoffs += field->offset;
 			ctx->last_bitsize = 0;
-		}
+			if (BTF_INFO_KIND(type->info) == BTF_KIND_INT) {
+				u32 intdata = btf_type_int(type);
 
-		type = btf_type_skip_modifiers(btf, field->type, NULL);
-		if (!type) {
-			trace_probe_log_err(ctx->offset, BAD_BTF_TID);
-			return -EINVAL;
+				bitoffs += BTF_INT_OFFSET(intdata);
+				if ((bitoffs % 8) ||
+				    BTF_INT_BITS(intdata) != BYTES_TO_BITS(type->size) ||
+				    !is_power_of_2(type->size))
+					ctx->last_bitsize = BTF_INT_BITS(intdata);
+			}
 		}
 
 		if (next)
@@ -858,13 +875,22 @@ static const struct fetch_type *find_fet
 }
 
 static int parse_btf_bitfield(struct fetch_insn **pcode,
+			      const struct fetch_type *t,
 			      struct traceprobe_parse_context *ctx)
 {
 	struct fetch_insn *code = *pcode;
 
-	if ((ctx->last_bitsize % 8 == 0) && ctx->last_bitoffs == 0)
+	if ((ctx->last_bitsize == 0 ||
+	     ctx->last_bitsize == BYTES_TO_BITS(t->size)) &&
+	    ctx->last_bitoffs == 0)
 		return 0;
 
+	if (ctx->last_bitsize == 0 ||
+	    BYTES_TO_BITS(t->size) < (ctx->last_bitsize + ctx->last_bitoffs)) {
+		trace_probe_log_err(ctx->offset, BAD_BITFIELD);
+		return -EINVAL;
+	}
+
 	code++;
 	if (code->op != FETCH_OP_NOP) {
 		trace_probe_log_err(ctx->offset, TOO_MANY_OPS);
@@ -873,9 +899,13 @@ static int parse_btf_bitfield(struct fet
 	*pcode = code;
 
 	code->op = FETCH_OP_MOD_BF;
-	code->lshift = 64 - (ctx->last_bitsize + ctx->last_bitoffs);
-	code->rshift = 64 - ctx->last_bitsize;
-	code->basesize = 64 / 8;
+#ifdef __BIG_ENDIAN_BITFIELD
+	code->lshift = ctx->last_bitoffs;
+#else
+	code->lshift = BYTES_TO_BITS(t->size) - (ctx->last_bitsize + ctx->last_bitoffs);
+#endif
+	code->rshift = BYTES_TO_BITS(t->size) - ctx->last_bitsize;
+	code->basesize = t->size;
 	return 0;
 }
 
@@ -1085,6 +1115,7 @@ static int parse_btf_arg(char *varname,
 }
 
 static int parse_btf_bitfield(struct fetch_insn **pcode,
+			      const struct fetch_type *t,
 			      struct traceprobe_parse_context *ctx)
 {
 	trace_probe_log_err(ctx->offset, NOSUP_BTFARG);
@@ -1995,7 +2026,7 @@ static int finalize_fetch_insn(struct fe
 	} else if (IS_ENABLED(CONFIG_PROBE_EVENTS_BTF_ARGS) &&
 		   ctx->last_type) {
 		/* If user not specified the type, try parsing BTF bitfield. */
-		ret = parse_btf_bitfield(&code, ctx);
+		ret = parse_btf_bitfield(&code, parg->type, ctx);
 		if (ret)
 			return ret;
 	}


