Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5E345EA7;
	Sat, 12 Sep 2026 17:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232950; cv=none; b=psJ/01yXFb+cIg4uTkgFRrTajDFDS5oGtKXRJkTLl7STvtYOq9N7xVFjLhEmAcljsc8rWWHTDBXmAYtwa/K888M8Nr2SIrclMr8f6OzYV+VzjREiLfIbcOLEW47p7i8KIF/EXXmzS0LWWjMpdmHHl+UVMxFo2TvHCvTSegoENeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232950; c=relaxed/simple;
	bh=kxatu2OiAyt57L0NkEVW4kBsz6rTqF0h5Eu1wLb+SFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beacTmls2foNfxhgGu1Q5c9byaJnGsOSQZtO6CsSkkddz+fqzPEQa8mK6Xw2qlVJv8WoPXN+hMESNGZ7Y/RoyIkELp0yozlaDP73W+sKWzD1htfH2p2NI/cFmzUVPMfCzsf/PQc4vJlWL2psp0M66NVn05+owFqLUXQqm/gMDLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLvUD3Lg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLvUD3Lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E1D1F000FF;
	Sat, 12 Sep 2026 17:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232949;
	bh=3fmfNSzo8Lk1gqFaYde/Hf9NqvDKP5yo3VIxaHJwupw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLvUD3Lg1sQAQYFKOy5WN6hjD+QQAL9lkhO1N5HBXTQPiAkvEeEFXsB/OZRfOQana
	 juNOFEwI/7+m9eXbUExV1ZYYZyqysap90578INcafOwpyNwk6ZdYSsbBqxcmLUoDp0
	 Ow1+k3unSl4xKQ9qKrqKGZ080E75KwR9zL2xN8n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 114/935] svcrdma: Fix offset arithmetic in read_chunk_range
Date: Sat, 12 Sep 2026 08:52:24 +0200
Message-ID: <20260912065529.433547982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -955,17 +955,20 @@ static int svc_rdma_read_chunk_range(str
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
@@ -974,6 +977,8 @@ static int svc_rdma_read_chunk_range(str
 
 		info->ri_totalbytes += dummy.rs_length;
 		length -= dummy.rs_length;
+		if (!length)
+			break;
 		offset = 0;
 	}
 	return ret;


