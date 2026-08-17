Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FE1346A02;
	Mon, 17 Aug 2026 14:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977794; cv=none; b=kPs9TNHiDR9fvLYg3zzelWY/Dc107ZMMj+ZWZIQT5ncpsYriGGrFNf2Gy9xV+rLNc+efoPwvWRAGlzVO9uxstuS/JjH1Na3b1rxajDCau9Ra2o5Qf0XNuSJwJskx/ucL0NXvEapnVaLJUnM4wMkm0E5Jdic7oSnF/Y+zFT4K2yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977794; c=relaxed/simple;
	bh=SZx+7ahE215LTpyV+0AF5n8hCote5xU0FoJemRIHMUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVgRDThDXWHNiuunRmrcwlV+045qJMFsMKl3k884c9mmb1s+nU6qU98grcDkbeOEHWd23Vbm3aME67Gby0J1DH2BPX8ywLCV3mPNftLks5bXeGQvjKo/3g/0oo/qLrHgUn7cyIl3c1pN+5rvPX2n43kPfWgC1Akh9C9p8Ewbnc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZiX+uxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZiX+uxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F501F00A3A;
	Mon, 17 Aug 2026 14:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977793;
	bh=3n7/Vz1NP6TLYvNq01lS7rD498uz+JIT0vNSUx0wfaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZiX+uxRFjfwgZzBFuAAaw/elOmhfv/Jz1PvZhSZcJi/c8j8ds1HE8e9ZZG5fPDiX
	 oGNpvYhDMNSs4clL3bGsOJc3I68FpfOHFKNCPqIXdenz26C/XP40PHRd3AQ7yinY1p
	 HFlIXpXpGCDcvFpx5sPZRykUCx7SpPRBQMe/PIXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 453/456] sctp: keep chunk->transport in step with the list it is queued on
Date: Mon, 17 Aug 2026 15:34:03 +0200
Message-ID: <20260817132556.739554652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

commit 9f2cf069a9a72a2d6b97ca8b4c70e714aac99749 upstream.

__sctp_outq_flush_rtx() moves a gap-acked chunk onto another transport's
transmitted list without updating chunk->transport:

	if (chunk->tsn_gap_acked) {
		list_move_tail(&chunk->transmitted_list,
			       &transport->transmitted);
		continue;
	}

The chunk then sits on a live transport's list while chunk->transport still
names a different one.  If that transport is removed - sctp_assoc_rm_peer()
from an ASCONF Delete-IP - sctp_transport_free() RCU-frees it and the chunk
is left with a dangling pointer.  sctp_assoc_rm_peer() scrubs
peer->transmitted and asoc->outqueue.out_chunk_list, but the chunk is on
neither.

The pointer is not followed while tsn_gap_acked is set.  A SACK that
reneges on the TSN clears the flag, and the next SACK reaches

	tchunk->transport->flight_size -= sctp_data_size(tchunk);

inside the freed transport.  KASAN reports a slab-use-after-free read in
sctp_check_transmitted(), freed from sctp_assoc_rm_peer().  Both the
removal and the SACKs come from the association peer.

Set chunk->transport at the move.  The ordinary resend path needs nothing:
it reaches its list_move_tail() only after sctp_packet_append_chunk()
returned SCTP_XMIT_OK, and __sctp_packet_append_chunk() has rebound the
chunk by then.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260729160028.54546-1-baul.lee@xbow.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/outqueue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -647,6 +647,7 @@ static int __sctp_outq_flush_rtx(struct
 		if (chunk->tsn_gap_acked) {
 			list_move_tail(&chunk->transmitted_list,
 				       &transport->transmitted);
+			chunk->transport = transport;
 			continue;
 		}
 


