Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC63A11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5F8C433C8;
	Mon, 28 Aug 2023 10:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218565;
	bh=ddk0cAu4CDskoA0JDs1iFwbOL/KBQD0flRr1Nyf6rNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0Ut8FxYgzJEwHQdse0rEazlXkuCDCnaJzUCQnD9/8wu+KgKSA/VdlGFo2yANWcck
	 VSY40Ii4IjnriTnJzJqj3CuOqPtdL62bmYYACQJxIT9ZJcQ3/bBhQkXF8c9qwEeKTI
	 +nDY1AfWS0dxlQml412DAvv3xjx/SgLZoQjd0wgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vimal Agrawal <vimal.agrawal@sophos.com>,
	Florian Westphal <fw@strlen.de>,
	Vamsi Krishna Brahmajosyula <vbrahmajosyula@vmware.com>
Subject: [PATCH 4.19 123/129] netfilter: nf_queue: fix socket leak
Date: Mon, 28 Aug 2023 12:13:37 +0200
Message-ID: <20230828101157.708846120@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vamsi Krishna Brahmajosyula <vbrahmajosyula@vmware.com>

Removal of the sock_hold got lost when backporting commit c3873070247d
("netfilter: nf_queue: fix possible use-after-free") to 4.19

Fixes: 34dc4a6a7f26 ("netfilter: nf_queue: fix possible use-after-free") in 4.19

Fixed in 4.14 with
https://lore.kernel.org/all/20221024112958.115275475@linuxfoundation.org/

Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
[vbrahmajosyula: The fix to the backport was missed in 4.19]
Signed-off-by: Vamsi Krishna Brahmajosyula <vbrahmajosyula@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_queue.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -93,8 +93,6 @@ bool nf_queue_entry_get_refs(struct nf_q
 		dev_hold(state->in);
 	if (state->out)
 		dev_hold(state->out);
-	if (state->sk)
-		sock_hold(state->sk);
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (entry->skb->nf_bridge) {
 		struct net_device *physdev;


