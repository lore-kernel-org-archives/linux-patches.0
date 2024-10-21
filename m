Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5BA1E571B;
	Mon, 21 Oct 2024 10:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506461; cv=none; b=FBnfYSQC83hAhPzUnLcssmYhkpI/ho9ABVd9DKpEEXH8He7Ug4jrO4UUSfLTWDNLaqjxdY1XqLVVBSESIXCa1UHanjW2hpBoStn2GjMHOMkJfPn8Yi4W+OkSkBxXc1/0yewpKx4POvbEEA+T8pOjzgwIgx1i3MXVxm96VNDuXms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506461; c=relaxed/simple;
	bh=i/k+DmwDktxyxI3bqqfKn+tuTvLfdbg60V8OYTFGivs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWeLLZivDT17V3lycCGd7wve6RGBENqFFaX4SSMTij1gnE/EqXyU14QLdx3dtha3V2zTdhmgbGi+xhnwTubSPkZiJ6r6XfAT7AMI4VnYbyxjiXslWard2tefHllYtwStLsRf6YRXmCMb3tNZmLvaUclqgaQRfqfd6yHwYnkB7lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1W9TJ/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1W9TJ/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16FBC4CEC3;
	Mon, 21 Oct 2024 10:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506461;
	bh=i/k+DmwDktxyxI3bqqfKn+tuTvLfdbg60V8OYTFGivs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1W9TJ/LkRps1uHY4OOzpoyjGwzptjECNH6fawhBeLLv5UF9iJ+PlyajPYf++U+Ro
	 nAqgTd9r/bgL0tweIgWD60FcVL2bAe3FBnD5M9bfxzcQ3faBliexaV5AELzJERTNKW
	 QS1GVhO6kcj+AR+0yfPBjyJiEspXZe1NmySsA0Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Babrou <ivan@cloudflare.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 013/135] udp: Compute L4 checksum as usual when not segmenting the skb
Date: Mon, 21 Oct 2024 12:22:49 +0200
Message-ID: <20241021102259.856952303@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

commit d96016a764f6aa5c7528c3d3f9cb472ef7266951 upstream.

If:

  1) the user requested USO, but
  2) there is not enough payload for GSO to kick in, and
  3) the egress device doesn't offer checksum offload, then

we want to compute the L4 checksum in software early on.

In the case when we are not taking the GSO path, but it has been requested,
the software checksum fallback in skb_segment doesn't get a chance to
compute the full checksum, if the egress device can't do it. As a result we
end up sending UDP datagrams with only a partial checksum filled in, which
the peer will discard.

Fixes: 10154dbded6d ("udp: Allow GSO transmit from devices with no checksum offload")
Reported-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20241011-uso-swcsum-fixup-v2-1-6e1ddc199af9@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    4 +++-
 net/ipv6/udp.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -950,8 +950,10 @@ static int udp_send_skb(struct sk_buff *
 			skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
 			skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen,
 								 cork->gso_size);
+
+			/* Don't checksum the payload, skb will get segmented */
+			goto csum_partial;
 		}
-		goto csum_partial;
 	}
 
 	if (is_udplite)  				 /*     UDP-Lite      */
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1266,8 +1266,10 @@ static int udp_v6_send_skb(struct sk_buf
 			skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
 			skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen,
 								 cork->gso_size);
+
+			/* Don't checksum the payload, skb will get segmented */
+			goto csum_partial;
 		}
-		goto csum_partial;
 	}
 
 	if (is_udplite)


