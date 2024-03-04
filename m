Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63861F93F;
	Mon,  4 Mar 2024 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588502; cv=none; b=ScM9S2aL+ZpT+s/tu+DDjyCcMmFc/ZAvSFE8usqp1/YUaMgVkU94P+ubgC4ucgMxvo+jg3HFqOBYOk0QLTiE8lOLKtiUOzc9Z0YG/BwXcRpWfRL4HpyURsWyv4YWDONZH3Ph6hEY1m0hJRL0g1YVO8fHhS0pi+4Q/hxYbgPIAng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588502; c=relaxed/simple;
	bh=rKxR+t+M3d6OufMdHwnddqIErzjlHARiZZFTYTvQZOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKwdcXgl9ph+I5HoF9nBfZ049I9fbtfkDbKaBBcbQ+ORrLvw77KdhR7mC9y9wYyKOqNlw5FWzdQMEW5D1OHxnY6asnpsH85bJDX1jYEPNQVoB1+wgjAPrTkFKiDsOy0lx8BGnUrPZyeXR072/B2RqvLOQSZV95vKQBnPF+dhl48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9RmX1PE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9RmX1PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D6BC433F1;
	Mon,  4 Mar 2024 21:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588502;
	bh=rKxR+t+M3d6OufMdHwnddqIErzjlHARiZZFTYTvQZOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9RmX1PEDphEVhk1zXvPeyW68At9xmA1/yRah04ZYDL0BvuiIVKcpGzVgA9CxskjZ
	 55Eh3jvZXgFtVxTBV1QCXvqNMhUH3aXeDkyT/moro+xv6zvxu0/tjCR/9MXabrz1iP
	 p9lNDOBXhlBND0LfVaj3rLSEwj8IzaHXVuHEGicU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 108/143] mptcp: push at DSS boundaries
Date: Mon,  4 Mar 2024 21:23:48 +0000
Message-ID: <20240304211553.374224293@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1277,6 +1277,7 @@ static int mptcp_sendmsg_frag(struct soc
 		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
 		if (!mptcp_skb_can_collapse_to(data_seq, skb, mpext)) {
 			TCP_SKB_CB(skb)->eor = 1;
+			tcp_mark_push(tcp_sk(ssk), skb);
 			goto alloc_skb;
 		}
 


