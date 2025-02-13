Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF0319E975;
	Thu, 13 Feb 2025 15:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460988; cv=none; b=Ug87VsDIi5t+SSCR+lJWoz+U6gP9g/1pE3R/iMRsqgpW+APDoKIOVKwsqQcVQ6xNOvx289As9TJHv3yJ4n/oIu/K5+UE16hLzffCN80RzXyuv6r/4RpEQYq46cQxnkzRR00kC+PySnwj+90uB9YN6lNa2sBjBAFNv+j8/6zb5vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460988; c=relaxed/simple;
	bh=yQrtSpUdu0fvxWwC0gfB3k1trgoD5heaKngsquBXOWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0Ah5J45EbodHch4GocDe5VxvvrBf7UWnebDmFojd83s/GgCDHZcnlbFUfgipEX28nsNrGZzvhFyHmLLcNfvqme2OBE7DnMKoxsenrH8Vq9PlTvrWf4EFt4hH1bB6X+9zs64J7bMGe/Afw48cT8VZX3YQTwMASClubITTwESq/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCX0VMA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCX0VMA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B67BC4CED1;
	Thu, 13 Feb 2025 15:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460988;
	bh=yQrtSpUdu0fvxWwC0gfB3k1trgoD5heaKngsquBXOWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCX0VMA8kAfNwA7eQw63DMyAdjoatbgZfqmYC70nUTEpJaQFjzRP7N+qDHinejq8v
	 uG04w8PXSk+Gfe94ux7yzuyhIzpCgU8vFNJJZFVq+IAty4Q8q5ll9pvkXDnvgyyBwp
	 toCn14Qu/90Ao/WpAryhTxOVlWzmQDEOxyTBglA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 268/273] mptcp: prevent excessive coalescing on receive
Date: Thu, 13 Feb 2025 15:30:40 +0100
Message-ID: <20250213142418.013919840@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -138,6 +138,7 @@ static bool mptcp_try_coalesce(struct so
 	int delta;
 
 	if (MPTCP_SKB_CB(from)->offset ||
+	    ((to->len + from->len) > (sk->sk_rcvbuf >> 3)) ||
 	    !skb_try_coalesce(to, from, &fragstolen, &delta))
 		return false;
 


