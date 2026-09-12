Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158882AEEB;
	Sat, 12 Sep 2026 15:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227222; cv=none; b=Z6t0gf3phh+iroCQyL70Y0oN8s+f8bDu32JPJvDl1mAK3+JttnnpCo5RwX7RKBnU+n2S6QunxvYPwidhu2sA0gyq0PP4QSJKLsKprNr1pFYdBa6XffxpPygLattozmsXUTWWYCn1WBvQLS5F7yNtcc1MSfjWiwl/Ijsbkk7OV+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227222; c=relaxed/simple;
	bh=wMjw1Nnz6+yTsPYoC03V2n1OuT5f05vRHgwQTked4Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6T/wCm52rI3EO56gdD5VgIXZABWK/WQjTSG4VbHEtJ3QHZlXDXzHJJumApFjqOOrWYbQSphpvFnrCX7AxcrvMxtgFfKAXgXlVZCVakSCxoWWWiVpOHwA4XqZEroWN2GZ1BwrSCV6AjHb1pawRQdcrRiorslkDLYmHW0xWog9Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/H6S1Vh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/H6S1Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7981F000FF;
	Sat, 12 Sep 2026 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227221;
	bh=UMEDndHsiBK5qDw+rnzmJuK6LKg4qWAHLVv/FCiLFH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/H6S1Vh038CeY5uyTOSsfYb1yfrnWOjyflHVxSUm8XSil4OE4vsp+1Cchu3lb5xK
	 MV12bTA75Cjbp0QBSf+W9Kl35RfOM+39m+7HrmnRpkaouIAOmyH224XYlLvtx/OzNT
	 9kJmP3H8P7pkRk4JMFQ8Guvy4q7gI1FyoZbOUJg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 0135/1191] svcrdma: Fix pcl_for_each_segment for empty chunks
Date: Sat, 12 Sep 2026 08:47:43 +0200
Message-ID: <20260912065551.229353428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit b7713a784c59515d0aba558c8f5df6a0164dd3a9 upstream.

When a parsed chunk list contains a chunk whose ch_segcount is zero,
pcl_for_each_segment computes its inclusive upper bound as
&chunk->ch_segments[ch_segcount - 1]. ch_segcount is u32, so the
subtraction wraps to 0xFFFFFFFF and the bound lands far past the
ch_segments flex array. The loop body then walks unrelated memory at
sizeof(struct svc_rdma_segment) stride until it faults.

A zero-segcount chunk is reachable from the wire:
xdr_check_write_chunk() only rejects segcount values greater than
rc_maxpages, and pcl_alloc_write() links a freshly allocated chunk
onto rc_write_pcl/rc_reply_pcl before its segment-fill loop runs,
so a Write or Reply chunk advertising zero segments leaves
ch_segcount == 0 on the list. When the transport has negotiated
Send-With-Invalidate, svc_rdma_get_inv_rkey() iterates all four
PCLs with pcl_for_each_segment and dereferences segment->rs_handle
on each iteration, turning the underflow into an out-of-bounds read
and a general protection fault.

    xdr_check_write_list / xdr_check_reply_chunk
      pcl_alloc_write()
        chunk = pcl_alloc_chunk(...)  /* ch_segcount = 0 */
        list_add_tail(&chunk->ch_list, &pcl->cl_chunks)
        /* fill loop iterates zero times for wire segcount 0 */

    svc_rdma_get_inv_rkey()
      pcl_for_each_chunk(rc_write_pcl)
        pcl_for_each_segment(segment, chunk)
          pos <= &ch_segments[0u - 1u]  /* 0xFFFFFFFF */
          segment->rs_handle            /* OOB read -> GPF */

Fix by switching the macro to a half-open upper bound that uses
ch_segcount directly. For ch_segcount == 0 the loop start equals the
loop end and the body is skipped; for ch_segcount > 0 the iteration
range is unchanged. All six existing call sites in
net/sunrpc/xprtrdma/svc_rdma_recvfrom.c and
net/sunrpc/xprtrdma/svc_rdma_rw.c remain correct under the new bound,
so no caller changes are needed.

Fixes: 78147ca8b4a9 ("svcrdma: Add a "parsed chunk list" data structure")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-rpc-kernel-bugs-v1-4-e251306ccca9@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/svc_rdma_pcl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/sunrpc/svc_rdma_pcl.h
+++ b/include/linux/sunrpc/svc_rdma_pcl.h
@@ -97,7 +97,7 @@ pcl_next_chunk(const struct svc_rdma_pcl
  */
 #define pcl_for_each_segment(pos, chunk) \
 	for (pos = &(chunk)->ch_segments[0]; \
-	     pos <= &(chunk)->ch_segments[(chunk)->ch_segcount - 1]; \
+	     pos < &(chunk)->ch_segments[(chunk)->ch_segcount]; \
 	     pos++)
 
 /**


