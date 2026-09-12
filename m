Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90CF47C107;
	Sat, 12 Sep 2026 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220395; cv=none; b=HIoCdYOoQ8qP+LjwoFhYQG9GApMrfNwPCl55rhrR3VDJ2KPaElgnMaOgFnrkbxSQagt90JnfYdeQOi/ar/IoTP/H6SQo4GVQ6WBXIiwXFjIPa1NT87U/geNnduUvSaXGUJQRx0I0pb1B49kvY4fQ24GCYARBhtNYPGo4rjLC+QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220395; c=relaxed/simple;
	bh=wgD2Ht54xi2JN9375u18F/0L2Nb0qjB37JQTq3duurc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxz0lfIlWkYeUckd6sHt+fEjKoVQCIsq04LezEZZ+VjjNT0w3pr9Y/g4l/MbLwZkipxZj7jE/WQaU9FzNGPTNZ5hdbi0M+73BEjp1xfAD4DjVukJqjJf75oiVnBQ764DE+Ve2DeUwOFnm4QgcSQowDVIsJj01IW0cArVJwPdM+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saFY3SLp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saFY3SLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C5C1F000FF;
	Sat, 12 Sep 2026 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220393;
	bh=jb/ADJBU7+Y8iL4vom7I7BVGcdhN2IDv3b5ONkGaS6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saFY3SLpVo2HFxeNDO0yffPArR6Idc0Oh5LNSrIYfIFlYWwi1+uHm4IPt+OC/75An
	 UTrMqaOBVHgMpWgh424C/uWv/SAHvj0ki8ihH8fi6Ebke82poQEBIp800q1UbzpqD9
	 cMgKoUOUmAt0cQbiXRxwBiVX8hQ0KIfmola7pFWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0161/1424] svcrdma: Fix offset arithmetic in read_chunk_range
Date: Sat, 12 Sep 2026 08:43:13 +0200
Message-ID: <20260912065610.900504375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit 4a44c140cc2f3643a39e258bb0c0ab9d0f494f5e upstream.

svc_rdma_read_chunk_range() walks a Read chunk's segment list to
build a sub-range starting at byte offset and spanning length bytes
for a Position-Zero or Call chunk. Two arithmetic defects in the
per-segment loop produce wrong DMA lengths and a u32 underflow:

    pcl_for_each_segment(segment, chunk) {
            if (offset > segment->rs_length) {
                    offset -= segment->rs_length;
                    continue;
            }

            dummy.rs_handle = segment->rs_handle;
            dummy.rs_length = min_t(u32, length,
                                    segment->rs_length) - offset;
            dummy.rs_offset = segment->rs_offset + offset;

First, the skip predicate uses '>' instead of '>='. When offset
equals the segment's full rs_length, the segment is fully consumed
and should be skipped, but the loop falls through into the body.
The resulting dummy.rs_length is min_t(u32, length, rs_length) -
rs_length, which underflows to a near-UINT_MAX u32 when length is
smaller than rs_length, or is zero otherwise.

Second, the length formula subtracts offset from the min_t() result
rather than from segment->rs_length before the cap. For offset > 0
the segment's residual is rs_length - offset, not rs_length, so the
cap must be applied to the residual. With the current bracketing,
whenever length is smaller than rs_length - offset the per-segment
length becomes length - offset instead of length, silently dropping
offset bytes from the rebuilt chunk. Combined with the boundary
case above it also enables the u32 underflow path, which propagates
a huge nr_bvec into svc_rdma_build_read_segment() and a multi-MiB
kmalloc_array_node() in svc_rdma_get_rw_ctxt().

Additionally, svc_rdma_read_call_chunk() can invoke this function
with length == 0 when the last Read chunk ends exactly at the end
of the Call chunk. With the corrected >= predicate, every segment
is skipped and the function returns the initial -EINVAL, rejecting
a valid request. Return success immediately when length is zero.
Also break out of the loop once length is fully consumed to avoid
passing zero-length segments to svc_rdma_build_read_segment().

Fix by using '>=' so a fully-consumed segment is skipped, by
moving '- offset' inside min_t() so the cap is applied to the
segment's residual length, by returning success for zero-length
requests, and by stopping iteration when the requested range has
been consumed.

Fixes: d7cc73972661 ("svcrdma: support multiple Read chunks per RPC")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-rpc-kernel-bugs-v1-2-e251306ccca9@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -981,17 +981,20 @@ static int svc_rdma_read_chunk_range(str
 	const struct svc_rdma_segment *segment;
 	int ret;
 
+	if (!length)
+		return 0;
+
 	ret = -EINVAL;
 	pcl_for_each_segment(segment, chunk) {
 		struct svc_rdma_segment dummy;
 
-		if (offset > segment->rs_length) {
+		if (offset >= segment->rs_length) {
 			offset -= segment->rs_length;
 			continue;
 		}
 
 		dummy.rs_handle = segment->rs_handle;
-		dummy.rs_length = min_t(u32, length, segment->rs_length) - offset;
+		dummy.rs_length = min_t(u32, length, segment->rs_length - offset);
 		dummy.rs_offset = segment->rs_offset + offset;
 
 		ret = svc_rdma_build_read_segment(info, &dummy);
@@ -1000,6 +1003,8 @@ static int svc_rdma_read_chunk_range(str
 
 		info->ri_totalbytes += dummy.rs_length;
 		length -= dummy.rs_length;
+		if (!length)
+			break;
 		offset = 0;
 	}
 	return ret;


