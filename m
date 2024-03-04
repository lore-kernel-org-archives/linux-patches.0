Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76D57BAF0;
	Mon,  4 Mar 2024 21:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587941; cv=none; b=eWcgJfGaPMVpvT6IhVuOiMa6p/4SyzOZeI/CORi37nmTRtTRCCeOt7V3WKORCcshzTzUd75OdjA5qxtQRbn7nfuyc6O+ZvAvG3gx/cScIvy/saj2r4DdFFZ4yd3ivR3urbVcQeNRhCuX+smGx/s+xnXJI/8CeM32NuDgXSMn2x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587941; c=relaxed/simple;
	bh=OVA0+2XrB5nLxXZNxoFORCzWCLWIeZ2lCc++BmMjVCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daqxf3ZMZulMZWwE1Ie6kI3Jwd8sV1yRVN8fSCzcSwSPzDBgP/8WR0fIg/qn4nVsiyRPmX1aSCc4qgyXuIXHPumt0dBxI88sDLR6Lhfs88VsS78qW7XW35QrFmg1Q2n1Zi4hFP9VCMao73ddNRESEpkzI04vmIwj5NMv7veBrxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSbJNW1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSbJNW1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C39AC433C7;
	Mon,  4 Mar 2024 21:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587940;
	bh=OVA0+2XrB5nLxXZNxoFORCzWCLWIeZ2lCc++BmMjVCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSbJNW1TJvkN7bw/yXtlb6m8gNI7L5DoJ5Ogk1P0ml8PDnU7LRUJkAPOgn20wm4UP
	 7KgrYzbwJbkZihxJT3GHRn9Cr5XYSCu+l3GAp69esJ2pFae83EuDIfwTaM5OqwWKvd
	 TOKFO0ehUpMunKUtVPUy0Zt4zXHpKSxQjGyT4lQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 124/162] mptcp: push at DSS boundaries
Date: Mon,  4 Mar 2024 21:23:09 +0000
Message-ID: <20240304211555.717506695@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit b9cd26f640a308ea314ad23532de9a8592cd09d2 upstream.

when inserting not contiguous data in the subflow write queue,
the protocol creates a new skb and prevent the TCP stack from
merging it later with already queued skbs by setting the EOR marker.

Still no push flag is explicitly set at the end of previous GSO
packet, making the aggregation on the receiver side sub-optimal -
and packetdrill self-tests less predictable.

Explicitly mark the end of not contiguous DSS with the push flag.

Fixes: 6d0060f600ad ("mptcp: Write MPTCP DSS headers to outgoing data packets")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-4-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1274,6 +1274,7 @@ static int mptcp_sendmsg_frag(struct soc
 		mpext = mptcp_get_ext(skb);
 		if (!mptcp_skb_can_collapse_to(data_seq, skb, mpext)) {
 			TCP_SKB_CB(skb)->eor = 1;
+			tcp_mark_push(tcp_sk(ssk), skb);
 			goto alloc_skb;
 		}
 


