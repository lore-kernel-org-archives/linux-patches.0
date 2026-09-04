Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85863B7B7B;
	Fri,  4 Sep 2026 05:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499368; cv=none; b=IToplSV8KoJjoEVoBf4K7qFU6uVX9lgnbgpCqKSREw87YpbTgXWTldXWCsDYQXv0NaiygbhGcAsvC3D7I+jGKymGA4BEooVvyOMUi4IBqI6B+Nd/qevBQy2b06KcHiwjzLB4Ioy+RliZGaII7ScV+mH7spFSFoDpQ/KSEQol9T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499368; c=relaxed/simple;
	bh=fxiHmn7rL6OqdvXb59djoEaafyqwLoYsXWhEIRPM9a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDVPTsd6zWcNdHb5Wuq/7dTs96d0lVzVSUfan2mbuF/6Y9SxwslbH6UoaJu0RAVPaStnuZvYgI5iEwee8EPvMLjgH8Hrotnwv7UHUKr7xbRVQzJzu53yUGd/H6kIW4m6Ojg8O52Cuif8YZ55VhaUTO0z1he2V7r2iXCzWfdyEU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SR3DLs8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SR3DLs8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074CA1F00A3D;
	Fri,  4 Sep 2026 05:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499366;
	bh=GgscbSBvDlMF97oaKwIRZ2/RN8x10qH0rOH0Er1O5H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SR3DLs8rQgB/kKSdx68354lZzTRJ8dUoQfGSS4evdM9m6MLBBKs0tab14+w9dOOWs
	 /jprUUMypjiIv/Ayg2KU5inNQxZ05WJb/XiZqFVvqilmbhuQaRek0euGO6qAWnjTNA
	 rtZ9pJ/V2pmEyFWnHGnLkStjBxhSBkA3EoGfXt3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 391/713] svcrdma: Fix offset arithmetic in read_chunk_range
Date: Fri,  4 Sep 2026 06:55:59 +0200
Message-ID: <20260904045812.589182576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -996,17 +996,20 @@ static int svc_rdma_read_chunk_range(str
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
 
 		ret = svc_rdma_build_read_segment(rqstp, head, &dummy);
@@ -1015,6 +1018,8 @@ static int svc_rdma_read_chunk_range(str
 
 		head->rc_readbytes += dummy.rs_length;
 		length -= dummy.rs_length;
+		if (!length)
+			break;
 		offset = 0;
 	}
 	return ret;


