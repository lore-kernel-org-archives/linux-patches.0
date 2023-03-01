Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA250847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4037AC433D2;
	Wed,  1 Mar 2023 18:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694151;
	bh=I8SKjJhzEKoggSR1bJPoebg3ujdguqFoiAhnyF4KH6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKHeCuh6NbIHzQqbG6hHn/4Key0GDJicoiRyPZpEiKy4yf0U2BeDak0c7r9U6uyE1
	 1yGljz+531n/UDJ6hFseTNR0RGJ4K4SQIGv4lXXnqkB15gDstk6UJQIjmgwNi0/1G+
	 5dvdOWhRGifnk58gXQiiw6vUfkZCGpkYjtp3j15Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.2 03/16] bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state
Date: Wed,  1 Mar 2023 19:07:39 +0100
Message-Id: <20230301180653.396950763@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin KaFai Lau <martin.lau@kernel.org>

commit 1fe4850b34ab512ff911e2c035c75fb6438f7307 upstream.

The bpf_fib_lookup() helper does not only look up the fib (ie. route)
but it also looks up the neigh. Before returning the neigh, the helper
does not check for NUD_VALID. When a neigh state (neigh->nud_state)
is in NUD_FAILED, its dmac (neigh->ha) could be all zeros. The helper
still returns SUCCESS instead of NO_NEIGH in this case. Because of the
SUCCESS return value, the bpf prog directly uses the returned dmac
and ends up filling all zero in the eth header.

This patch checks for NUD_VALID and returns NO_NEIGH if the neigh is
not valid.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230217004150.2980689-3-martin.lau@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5816,7 +5816,7 @@ static int bpf_ipv4_fib_lookup(struct ne
 		neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
 	}
 
-	if (!neigh)
+	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
 	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
@@ -5931,7 +5931,7 @@ static int bpf_ipv6_fib_lookup(struct ne
 	 * not needed here.
 	 */
 	neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
-	if (!neigh)
+	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
 	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);


