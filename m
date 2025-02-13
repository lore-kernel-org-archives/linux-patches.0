Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F6919D084;
	Thu, 13 Feb 2025 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458475; cv=none; b=StT1n5lbKNuKQsrXDOkZ5AAHrt8y92vzEgCABPcUWj4Tr2tCsZq+bvshvrQk56MAuK7aZxsbkXjJdcCbTAoTbJ6gbxRhkXqePBL+0pX9RnxXXjHB4SJBK9QDo4b+BlpcxJ8AnURlYOiGCrxWx4ggDfiUkNeh7fdc52yQSVIZRxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458475; c=relaxed/simple;
	bh=AOMqjk/NLBa11KzIUu1O9lKZmN51HY9nxEqw5rzTqJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddnT/FTEDQqEvtoQ176gYU1m4wIIxqwjLWjgBXcI8+8KMJNu5SkD6j8/FFkv0jEx2q0ZOMBF+lF+2DPIlLV5DsBus6v6+oZghiFA2/uOzOpigWqwa2QUCW08tmOLBP5VldySuhGH5SJvZaZZPdSKJUgmj39V0H1LLoXHisd9CX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1W8BfOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1W8BfOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C42AC4CED1;
	Thu, 13 Feb 2025 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458475;
	bh=AOMqjk/NLBa11KzIUu1O9lKZmN51HY9nxEqw5rzTqJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1W8BfOxB9WXkRtDWJypbIDiY9tE0zei/cbUV/hXINf+++r6Yk945tPlsB7/V34RA
	 pEd55BtW8qGuciIB/y8SgKiu0K+w5v82AKoqX2B0/53orb+YRPShO9xh8XYvSs5+sd
	 ZP70NwxgijpSzakSusqdFIFku+cAAKnvDc8bFMGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 411/422] mptcp: prevent excessive coalescing on receive
Date: Thu, 13 Feb 2025 15:29:20 +0100
Message-ID: <20250213142452.423535898@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 56b824eb49d6258aa0bad09a406ceac3f643cdae upstream.

Currently the skb size after coalescing is only limited by the skb
layout (the skb must not carry frag_list). A single coalesced skb
covering several MSS can potentially fill completely the receive
buffer. In such a case, the snd win will zero until the receive buffer
will be empty again, affecting tput badly.

Fixes: 8268ed4c9d19 ("mptcp: introduce and use mptcp_try_coalesce()")
Cc: stable@vger.kernel.org # please delay 2 weeks after 6.13-final release
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241230-net-mptcp-rbuf-fixes-v1-3-8608af434ceb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -136,6 +136,7 @@ static bool mptcp_try_coalesce(struct so
 	int delta;
 
 	if (MPTCP_SKB_CB(from)->offset ||
+	    ((to->len + from->len) > (sk->sk_rcvbuf >> 3)) ||
 	    !skb_try_coalesce(to, from, &fragstolen, &delta))
 		return false;
 


