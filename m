Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6755B3BF2F6;
	Thu, 15 Jan 2026 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496765; cv=none; b=AzUaFdPEr5awjjVIOqice2MYTfPOHqU8QlqHhRQPXJqxiVGRyG9mTTTdSQmJ2APK7UcMLt/SX6jkGa1TSFnZZkFA7o6namaaUQJAY0jXDfdlj+dtLBlaqD8cc8u3DsyVodEvHsvCYGiRm9JpleGQHxhX+jUjr6NuVt757HewdSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496765; c=relaxed/simple;
	bh=tUvw6uLFlWsSTnHmM9HcGgNC3cG3kP1IUuMCXxoO65U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcOQ//jA8BuGY1y4B4s3dxwsw6NRjybQ+DQyGxBYRpEFfw4CAb3FQP6Evg0LeVtghB64IVJOM5WmLB4849tqEyFlnJQQz5rFQmP5RCySrzD04X1UqRjU3WFcC9jvdLBsMoUjDac9utGftCLkoMDmoPUD5L0w5gmW5S2Z0depoiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLVDr0RV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLVDr0RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E21C19422;
	Thu, 15 Jan 2026 17:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496765;
	bh=tUvw6uLFlWsSTnHmM9HcGgNC3cG3kP1IUuMCXxoO65U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLVDr0RVStMzFwwTQWl05nZclqBJvSsYvNO1pjCNdH2f6lAfBWaTSGW4FRobbIFeZ
	 VPrWSy8wFSedh4bFL+Ebg4kM/s2H7rmEEeA9/u1K1TTWCCb/DHd4wyYR57xmMoJCkf
	 p7BEIXoyPmnVCn5c2afBbU0swaaVMBpyMSKxm+dk=
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
Subject: [PATCH 6.12 100/119] bpf, test_run: Subtract size of xdp_frame from allowed metadata size
Date: Thu, 15 Jan 2026 17:48:35 +0100
Message-ID: <20260115164155.562651773@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 318ffd55cf608..84ed67a15dee0 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1230,8 +1230,6 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			batch_size = NAPI_POLL_WEIGHT;
 		else if (batch_size > TEST_XDP_MAX_BATCH)
 			return -E2BIG;
-
-		headroom += sizeof(struct xdp_page_head);
 	} else if (batch_size) {
 		return -EINVAL;
 	}
@@ -1244,16 +1242,26 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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



