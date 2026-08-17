Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACB941D111;
	Mon, 17 Aug 2026 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978767; cv=none; b=crbaVMoKo7n5GtKsAZa+ozlgzFZhZiYwoBr9lt1of38glFQHeKzI+KMNBKI0pg5fk0oNWwAytYHLZ8aMWuHpAr9qeOMHfdDrL7P/L/FCjPjOp8a0n4+rBPE7IwoPK/rvufFCAwJJ6LWbFn0tt1CvuMSN1FnTc+cvujMNUHhl2MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978767; c=relaxed/simple;
	bh=6tXZkjNcQkjKO8bOCZwXgMUHGN/q5iAAT9SDtAgTQO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etERpeAksm9jux7P9Xhyu0P9+24uLeB0pYFMj+Tdf+4TvBDQJW2GIyArtE1QUfnJVWiQht/U+dhDQktkXM760Qqr/FX3XEUpmI2/4LPk9m7ftg6Sd4aWCjOhj2O6gZv4O2AR3CCJs3M/r9t2ZandXz0iPswPtJkM6EX6Vu7wjiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyBGwPR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyBGwPR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8229B1F000E9;
	Mon, 17 Aug 2026 14:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978766;
	bh=LHUR5iYC7FNA0nKLXNF6F98/QumktGPaEwn4cRuO1H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyBGwPR5UBjqTzdwrOXMbILiCZcxIMLHbje3uEB/5cjq31dkQDz7fefGU5I87iFAN
	 i2v8F72RmxGdlHJz09NvgsOCj3CujR1MQXJTCVqUZT5L1Pxq7syEWyNkr+Gy8kYOgG
	 JXB6qa1QBzf6G33WFns4MCFBpmAcbEe/E4Y1WyzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 149/156] sctp: keep chunk->transport in step with the list it is queued on
Date: Mon, 17 Aug 2026 15:34:43 +0200
Message-ID: <20260817132540.574833384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
 


