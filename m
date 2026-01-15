Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585EA3BFE5F;
	Thu, 15 Jan 2026 17:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497178; cv=none; b=to141n4bA9lF+YjeSMZFzQIRXq3nIjaAqdJY7TlJmWb8aZAggkNV722Q+YsqY5Cs1B8/8c6vvK5SJazBm33PRnpzNCwS5okTl/vi3HELaFJVgikQEhbvgfLoGdqUnv5jHLmrqy4o76fSi1eMOwi9yX+v766R4n7McfX7bUT8SGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497178; c=relaxed/simple;
	bh=3Hj+0cvG/B6DfnJMAQsAnJ3Vy4lY+MIGNcRJ06qKOlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y/Dmb9NP4QbIkPgSLUQ/zOPrnO6hzfVlL0EvxZRFhLbFVmveigdr5dEOIhukTf2ClEM3u2o/DXRzms9UC+LCS1pF3NB4GWr8cyPHNTiwKDWAZcyOy3QqNSuKHk6R6CdNyBCemrEG+6M1o6UZv8Ib9xN/FdKxIAD9MTlng2JBe0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZISGNMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZISGNMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABCBC19422;
	Thu, 15 Jan 2026 17:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497178;
	bh=3Hj+0cvG/B6DfnJMAQsAnJ3Vy4lY+MIGNcRJ06qKOlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZISGNMjqZO9f1/Ejaqyy79LMkCrHN0A+dBE9SrAFXA92fS69Khhj1F5hhyr3VrRJ
	 0PGnGQBAIVmMA2bp6e9mx5p7wSwFPvBlr6rxFIub3qNKcgWusBnHXZQJYv3Zfi5COo
	 VH9wotgPmoBI6fI7b7Je7KaJrnORuMzVKuSy2r1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Amery Hung <ameryhung@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 64/72] bpf, test_run: Subtract size of xdp_frame from allowed metadata size
Date: Thu, 15 Jan 2026 17:49:14 +0100
Message-ID: <20260115164145.824600065@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit e558cca217790286e799a8baacd1610bda31b261 ]

The xdp_frame structure takes up part of the XDP frame headroom,
limiting the size of the metadata. However, in bpf_test_run, we don't
take this into account, which makes it possible for userspace to supply
a metadata size that is too large (taking up the entire headroom).

If userspace supplies such a large metadata size in live packet mode,
the xdp_update_frame_from_buff() call in xdp_test_run_init_page() call
will fail, after which packet transmission proceeds with an
uninitialised frame structure, leading to the usual Bad Stuff.

The commit in the Fixes tag fixed a related bug where the second check
in xdp_update_frame_from_buff() could fail, but did not add any
additional constraints on the metadata size. Complete the fix by adding
an additional check on the metadata size. Reorder the checks slightly to
make the logic clearer and add a comment.

Link: https://lore.kernel.org/r/fa2be179-bad7-4ee3-8668-4903d1853461@hust.edu.cn
Fixes: b6f1f780b393 ("bpf, test_run: Fix packet size check for live packet mode")
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Link: https://lore.kernel.org/r/20260105114747.1358750-1-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2bc83525986f3..88fdcfb2fdd30 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1304,8 +1304,6 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			batch_size = NAPI_POLL_WEIGHT;
 		else if (batch_size > TEST_XDP_MAX_BATCH)
 			return -E2BIG;
-
-		headroom += sizeof(struct xdp_page_head);
 	} else if (batch_size) {
 		return -EINVAL;
 	}
@@ -1318,16 +1316,26 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		/* There can't be user provided data before the meta data */
 		if (ctx->data_meta || ctx->data_end > kattr->test.data_size_in ||
 		    ctx->data > ctx->data_end ||
-		    unlikely(xdp_metalen_invalid(ctx->data)) ||
 		    (do_live && (kattr->test.data_out || kattr->test.ctx_out)))
 			goto free_ctx;
-		/* Meta data is allocated from the headroom */
-		headroom -= ctx->data;
 
 		meta_sz = ctx->data;
+		if (xdp_metalen_invalid(meta_sz) || meta_sz > headroom - sizeof(struct xdp_frame))
+			goto free_ctx;
+
+		/* Meta data is allocated from the headroom */
+		headroom -= meta_sz;
 		linear_sz = ctx->data_end;
 	}
 
+	/* The xdp_page_head structure takes up space in each page, limiting the
+         * size of the packet data; add the extra size to headroom here to make
+         * sure it's accounted in the length checks below, but not in the
+         * metadata size check above.
+         */
+        if (do_live)
+		headroom += sizeof(struct xdp_page_head);
+
 	max_linear_sz = PAGE_SIZE - headroom - tailroom;
 	linear_sz = min_t(u32, linear_sz, max_linear_sz);
 
-- 
2.51.0



