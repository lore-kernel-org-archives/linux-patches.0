Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB781EB5A;
	Mon,  4 Mar 2024 21:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588873; cv=none; b=VZh1ndQUGAMtJ9JH2t2JLpdT2Cs5mKntE505fl8XUX1z2dpmohNJj9UcqZRTHWCrYQWGJBl/yjTQ3CEKIQ7klNQqhnDXg6oZvhq8Hs/55If5K1xILGPvY/H11WGus0dfuh2w3Zur1zSVGc4WTKT2HlXRLILuHF5bm436HkZeT2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588873; c=relaxed/simple;
	bh=6dJbstobldXJgTw6c5EGKGrMAQEUFDS70GNG4W5AJqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mp7tFy1ft7+OM2V1RKrjcXPYNyGoIVcWov40JxW2imnE5Z1i8TXWjx1yoXffsqvv6RLQ074VHKfspD9W7F93n2ZRryiZV+OoQ+NrefYiRADV9gOhxXadsdym7cMvc44G6l0Smp68UKpGtUlGVJQpsy0EHASJxJcL2pL74KS41v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtReCKnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtReCKnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5EFC433C7;
	Mon,  4 Mar 2024 21:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588873;
	bh=6dJbstobldXJgTw6c5EGKGrMAQEUFDS70GNG4W5AJqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtReCKnTF+83+gF7el+O2nQm8g21Sjw7NbrgiSmCsJdiUd/uG7B99ZfEDg/1b5BVs
	 U210dnzuiF1SP5fJWKVlw6Fa6EvFVw0/i8m4TdS4L6JYIBuaN9K4rMNi+ThLUWBAq6
	 tPD/UHwQEq85gjbf7mcR3srCUMdsW6Yv26Qa95kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 102/215] mptcp: push at DSS boundaries
Date: Mon,  4 Mar 2024 21:22:45 +0000
Message-ID: <20240304211600.270196993@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1319,6 +1319,7 @@ static int mptcp_sendmsg_frag(struct soc
 		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
 		if (!mptcp_skb_can_collapse_to(data_seq, skb, mpext)) {
 			TCP_SKB_CB(skb)->eor = 1;
+			tcp_mark_push(tcp_sk(ssk), skb);
 			goto alloc_skb;
 		}
 


