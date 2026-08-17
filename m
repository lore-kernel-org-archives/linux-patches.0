Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DBD29B795;
	Mon, 17 Aug 2026 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980525; cv=none; b=jXmftOe/mqfBZvmhRkMd9feuJkcigck1N8OGaLqllZ1D9rPAnBfXtBZIMUI9SEFSyzy3LlAv8B4FDJDa3weV+XM2IvEoBcktKfpG/8KfqcdL+l/JeyQqgPESeVBqb3bKnZm1MI3CGHAA4EPmsCAoEanXEOafXUCJFG479Tlvfk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980525; c=relaxed/simple;
	bh=5GXegAEHJ4iYB1ViMzAHDuZ0oTiIF+bqIRlO1aBlQOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUmOdnSuSnNbgjdIKcEIw52yN3Mnl5WLPzxeXQqCM1TLssbTxCfcW0s7L92OW/XnDIejgYcDn8hcWrl4Ej0QrD6JlBMiZ0szckAE1ysws8zo14E+BEalMmcDLbZOoEIXfkLuPZ0K7QrYxd4QEz46S2U08cuucjm/pGSvATZRJ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h893YUiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h893YUiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACF81F000E9;
	Mon, 17 Aug 2026 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980524;
	bh=gILAL0PNTvxakkfMSvNRmZ9z5/i8qBDMl4jYZHqlNC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h893YUiUcw6sorQNZZ/dkVHp1d7FcJAPtvrqpJ74c7tNMGc3Ps+J1wjZwpGWBidk2
	 rBc2y7iOq0dBBMciDYzKTQIKF0PJBIaWqrzyPUv0SJi4Hn/sQq1zSp/X9OtoqFlAUe
	 KbFkYGfDjc8cI9p8mrlemTTi0wFsdym7j9hudUe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 602/609] sctp: keep chunk->transport in step with the list it is queued on
Date: Mon, 17 Aug 2026 15:34:58 +0200
Message-ID: <20260817132603.770971408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -650,6 +650,7 @@ static int __sctp_outq_flush_rtx(struct
 		if (chunk->tsn_gap_acked) {
 			list_move_tail(&chunk->transmitted_list,
 				       &transport->transmitted);
+			chunk->transport = transport;
 			continue;
 		}
 


