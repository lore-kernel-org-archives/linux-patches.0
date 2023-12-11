Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F1D51C37;
	Mon, 11 Dec 2023 18:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tsqe7nWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B1DC433C7;
	Mon, 11 Dec 2023 18:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320781;
	bh=eWM4zmJ5iC1OPM7z5J0mSS0j5vy3KuR1GJM2S1Xgtl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tsqe7nWBo/wx8RYKoN/TtMoyF0Fo8LgUHU3/F9mhykDuDJAjbcyaAEubkRPGgHSvt
	 NC6WCsF8Udfy6P0lrD0dcjR4+meyna+jr5vx2PfDAKYUayDYejs4fzuISrdqw2NlNA
	 o6WtnsUQCCLpHgzPN0d5a6yIu4cjylgi5AVS+L/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 189/194] netfilter: nft_set_pipapo: skip inactive elements during set walk
Date: Mon, 11 Dec 2023 19:22:59 +0100
Message-ID: <20231211182045.133347541@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 317eb9685095678f2c9f5a8189de698c5354316a upstream.

Otherwise set elements can be deactivated twice which will cause a crash.

Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2042,6 +2042,9 @@ static void nft_pipapo_walk(const struct
 
 		e = f->mt[r].e;
 
+		if (!nft_set_elem_active(&e->ext, iter->genmask))
+			goto cont;
+
 		elem.priv = e;
 
 		iter->err = iter->fn(ctx, set, iter, &elem);


