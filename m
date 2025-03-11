Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45FE25E807;
	Tue, 11 Mar 2025 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706950; cv=none; b=G0Q4GooMrTcKubuBv0CHD8PZPPjHyU8Nfi4oD/lqVlx3cY3/GaA8rZPYp3eKJthyeWX6Z3YVMljHW1CS6bUXf6vmVg2HD8hPIiKuYijyFvXbNDcOIQJM7FNuCeTPEgUDMzlG0mOUULoHVibDF5TeQfNc3lWrhj293MAHO4qi+jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706950; c=relaxed/simple;
	bh=BhEc1tKkjK+aqCNdI4k5ZCJRrhE4npCWfE20gZd7wgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKJ5r0h/mciV+OX06zpGt0mwsrmjUjT9fyMdg1NE0S51vafei7NrbDbu1cCqHv//48t/Wq4EfPBE8x7pkQRvL9XJItZMGAPQjM30zBZqmRDx0R/RxxA+99Txchu6L5zeKmO1EsXYrmFh9B2JTksq7Cn3zaedPTLiRv9Xmge/KI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jQYlN9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jQYlN9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C80C4CEEA;
	Tue, 11 Mar 2025 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706950;
	bh=BhEc1tKkjK+aqCNdI4k5ZCJRrhE4npCWfE20gZd7wgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jQYlN9puUjLfR3zVoRYOsh8/mF0iFjhILttS2anbfjmjS2Ctz0TzK3x5glJ5H5mJ
	 SL+zlMBQG/Jc/QvbdoKEf78zU+qjixrm8HUCLn1MISU72U+SVi+OlmSnZll9f9i4BT
	 IsfuE33dBZssXC2q3qo7/V11zDH49kNTXtK92n9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 224/462] mptcp: prevent excessive coalescing on receive
Date: Tue, 11 Mar 2025 15:58:10 +0100
Message-ID: <20250311145807.211480144@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -125,6 +125,7 @@ static bool mptcp_try_coalesce(struct so
 	int delta;
 
 	if (MPTCP_SKB_CB(from)->offset ||
+	    ((to->len + from->len) > (sk->sk_rcvbuf >> 3)) ||
 	    !skb_try_coalesce(to, from, &fragstolen, &delta))
 		return false;
 


