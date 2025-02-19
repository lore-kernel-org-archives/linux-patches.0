Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C954E176ADE;
	Wed, 19 Feb 2025 09:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957328; cv=none; b=H/vpKPFMai3DnioVuVCNFOc3dxwkSHf8lTs5BLCWNDapLcA7tzaWhYknSnwvGU6IcAT6FTXxKS9/bfxUfwn7qNEySjqxKqIEjn1+xFF9xDpy6mVEKNfJ+b/lkc3yiF7X8yP69u2g2hctiwWnQ2iSJrrqdsSdqlLnG2K67UhbCs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957328; c=relaxed/simple;
	bh=BCzHBYM04gw8dm1HJlbaVR1+MVJVaoUIoX8SvNGbhRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVG6HhjgYfvIGb8XOjjuBS3pqvjdukL6nLHa0EZDoqIh5W2uNCsZ8+1NtnPQYhVHBvMLyfFLJ3HD9mLLnMA250MxhE3JifLG1CAhIFi4iBmaXUk6DEYa0sFe4EqRbvfgXd4hz5Ze3hixFJnKR61BHd27YV+J/rkCWYOevsurwGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9W1tDb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9W1tDb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C7AC4CED1;
	Wed, 19 Feb 2025 09:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957328;
	bh=BCzHBYM04gw8dm1HJlbaVR1+MVJVaoUIoX8SvNGbhRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9W1tDb7R8GXBOtIVy4Bj5Ij0UngvMmuPfm6XwpTFygIy31qMVA8P0m0ujcagkKVX
	 2HQfZCp1OV2tgYG2JdKZyQz3u3vvWPaSBd9lVPTcqpKBoR3/3UN17DMIRWL6aVqY5s
	 gzSRD2qcuyjMeB+BfDKWMn25Pi9pvrTWZ8k9lLLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 455/578] mptcp: prevent excessive coalescing on receive
Date: Wed, 19 Feb 2025 09:27:39 +0100
Message-ID: <20250219082710.892812489@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -149,6 +149,7 @@ static bool mptcp_try_coalesce(struct so
 	int delta;
 
 	if (MPTCP_SKB_CB(from)->offset ||
+	    ((to->len + from->len) > (sk->sk_rcvbuf >> 3)) ||
 	    !skb_try_coalesce(to, from, &fragstolen, &delta))
 		return false;
 


