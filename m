Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617846;
	b=tl1d1/JMwFEglNtaiVh8AYBEHS6z61S/+349NQS/usPji3CbykSrZiywgI+DrL8bn00q
	 RA3oe8dM5Sqh8c9jgL4OClJdi4WsOTpYSqszCW/Qa/L9SQe7mwBhRNkw5w8FHC9/9zFeI
	 3cZK4/MPyeoadIMTvI+4DKYmEbrLMaTfAxI62aFyWd1a8tFJ86hDDnYzRxqb1vFefqcDL
	 5uVThCe8RqOHu9KztgPIyt9UCIytKQKvsd2u1GAiLsVTcwut3JMJhNMBNHYBwGDkBeRtD
	 ZCk3vHWldxRepKwK36S8v5RlzzoWb/X+3tonQC+muCNnUTGf2VQ/ZfqoHE61bK/Oy6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OAOrqQOjg9UiHOY5E8J0XbC1AlTe5lBiuW/Y3Fll8ow=;
	b=CTxTAeP3LqhiYxw7BGU4IVwjWX+/ygrVvumsVpyqQGVbNS8TsK/i3WzXqie1m5w1E1TT
	 e1GJzYjL6pQ73H0hjYXVmpDeAK4VZf8pkJIrIn6Ta4i7uTzIHHVwvz0cdgDmZgnuMkInQ
	 /44q3euMqrftR91W4OT9aSpf/9iPotcP21dPq0GQaMcH10CqXka2UQJN82bgXr1/Y1HaF
	 SO1NmjF/5tE082qP0EO/GawXLeLubfvZEN1bPwX7Jy6KjZy/aotEASzA//cGZ47+DvPV2
	 /Faq+5v7fZ2tI4JakQ3slQFLiwYiISKkHaHj16PrMwB9DoiRnd8L0QTYYO9n2U+L3Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keBqDZkn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21523606A323;
	Wed, 25 Nov 2026 14:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keBqDZkn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6741F000C0;
	Wed, 25 Nov 2026 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617845;
	bh=OAOrqQOjg9UiHOY5E8J0XbC1AlTe5lBiuW/Y3Fll8ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keBqDZknXGJSrgvilNVRQ5KjJ+46+g0UoE7FjojAS9NUbbY/vAGfzvzgZYgU2lPwL
	 66R3QypSRFOqJkk+q0HBu4tjkL94LCZn2mtHFVlmXUfUC01Hm2sFIdDRdVBSLq5TnA
	 o61TY6LaTIGbNRD5V3mqTXduHnNDQzSYxgajAprY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Ayushman Rout <ayushmanrout27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0093/1005] bpf: Fix bpf_dynptr_copy() for overlapping ranges in one packet
Date: Wed, 25 Nov 2026 15:23:51 +0100
Message-ID: <20261125143823.922750787@linuxfoundation.org>
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

From: Ayushman Rout <ayushmanrout27@gmail.com>

[ Upstream commit 696f0954e3b6280aa87ea4a6196153e506b0ab9c ]

When both dynptrs point into the same packet and the ranges overlap,
bpf_dynptr_copy() can copy wrong data in two ways.

If one range fits into a segment and the other one does not, the slice
of the first range is used as the buffer for __bpf_dynptr_read() or
__bpf_dynptr_write(). The range that crosses into a frag is copied piece
by piece, and an earlier piece can overwrite bytes that a later piece
has yet to read.

If neither range fits into a segment, the chunks are copied from the
start to the end through a 256 byte stack buffer. When the destination
is above the source, a chunk written to the destination overwrites
source bytes that later chunks have yet to read. For a copy of 1200
bytes with the destination 100 bytes above the source, the first chunk
writes source bytes 100..355 and the second chunk then reads bytes
256..355 after they were overwritten.

Do not use a slice as the buffer when both dynptrs share the same data,
and copy the chunks from the end to the start when the destination is
above the source, like memmove() does.

The selftests added later in this series pass with this change.

Fixes: daec295a7094 ("bpf/helpers: Introduce bpf_dynptr_copy kfunc")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ayushman Rout <ayushmanrout27@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261026162810.12862-2-ayushmanrout27@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 7c2e6f0e74091..9100283e2935e 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3255,8 +3255,10 @@ __bpf_kfunc int bpf_dynptr_copy(const struct bpf_dynptr *dst_ptr, u64 dst_off,
 {
 	const struct bpf_dynptr_kern *dst = (struct bpf_dynptr_kern *)dst_ptr;
 	const struct bpf_dynptr_kern *src = (struct bpf_dynptr_kern *)src_ptr;
+	bool same = src->data == dst->data;
 	void *src_slice, *dst_slice;
 	char buf[256];
+	bool rev;
 	u64 off;
 
 	src_slice = bpf_dynptr_slice(src_ptr, src_off, NULL, size);
@@ -3267,25 +3269,31 @@ __bpf_kfunc int bpf_dynptr_copy(const struct bpf_dynptr *dst_ptr, u64 dst_off,
 		return 0;
 	}
 
-	if (src_slice)
+	/* The other range is copied piece by piece. A slice of the same packet
+	 * may overlap with it, so it cannot be the buffer for that.
+	 */
+	if (src_slice && !same)
 		return __bpf_dynptr_write(dst, dst_off, src_slice, size, 0);
 
-	if (dst_slice)
+	if (dst_slice && !same)
 		return __bpf_dynptr_read(dst_slice, size, src, src_off, 0);
 
 	if (bpf_dynptr_check_off_len(dst, dst_off, size) ||
 	    bpf_dynptr_check_off_len(src, src_off, size))
 		return -E2BIG;
 
+	/* like memmove(): from the end if the destination is above the source */
+	rev = same && dst->offset + dst_off > src->offset + src_off;
 	off = 0;
 	while (off < size) {
 		u64 chunk_sz = min_t(u64, sizeof(buf), size - off);
+		u64 pos = rev ? size - off - chunk_sz : off;
 		int err;
 
-		err = __bpf_dynptr_read(buf, chunk_sz, src, src_off + off, 0);
+		err = __bpf_dynptr_read(buf, chunk_sz, src, src_off + pos, 0);
 		if (err)
 			return err;
-		err = __bpf_dynptr_write(dst, dst_off + off, buf, chunk_sz, 0);
+		err = __bpf_dynptr_write(dst, dst_off + pos, buf, chunk_sz, 0);
 		if (err)
 			return err;
 
-- 
2.53.0



