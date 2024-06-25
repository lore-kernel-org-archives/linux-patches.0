Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E857D13D62A;
	Tue, 25 Jun 2024 09:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308401; cv=none; b=XLi67ieOTq8z2nchLbk1WixvL/VfLSnXjsTE+Xf7z+AQl3/Q3ugseTs1eEhRRZTcML4KlevQfw2KbBupJogzyWp3nHQWBQzK4j713iz4FKMbCgrHgujeF2cduED4xtSiTPWBXQsbMDgFW2EqbEz5a0UklHRE1WuK6fnY1xdYyp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308401; c=relaxed/simple;
	bh=/fC7ocfv9WJnF8kj6Wm6G08RFw5I3ksPHABq5AiFXBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvlBfox4ql8Kqdk6ygF3dlqEeLUNfxH2Ae81bHcUCQ1UseVzCxeOELHC5D818eTjq6dAYRzMo57OKxHH7yzFdbPKSDPrAL0V8gO9LA8SJMukgPDXRnzYh2xoIZuN2zLiWS9dU507fpYEzlshSmMQptn5uaEKhtaVNLJfhwwdY1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndCgy+IQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndCgy+IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D56C32781;
	Tue, 25 Jun 2024 09:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308400;
	bh=/fC7ocfv9WJnF8kj6Wm6G08RFw5I3ksPHABq5AiFXBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndCgy+IQph6kKRp5uTd0mOOfJbYZ/HzLhME2+CSePRlFwjzet2QXqIBGED7lBKVvv
	 /wJv67QAlDcOZ5GgndmeMRiAOnQorAf2Grk+kdGQZ1hNfYd2/3k1DfegcelkttZwt1
	 RBd9yAx2Y/wOOQ81AJCDo9FIdO2tMM3ZnsaUJPi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>,
	Kees Cook <kees@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 109/250] net: mvpp2: use slab_build_skb for oversized frames
Date: Tue, 25 Jun 2024 11:31:07 +0200
Message-ID: <20240625085552.257371744@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>

[ Upstream commit 4467c09bc7a66a17ffd84d6262d48279b26106ea ]

Setting frag_size to 0 to indicate kmalloc has been deprecated,
use slab_build_skb directly.

Fixes: ce098da1497c ("skbuff: Introduce slab_build_skb()")
Signed-off-by: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
Reviewed-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20240613024900.3842238-1-aryan.srivastava@alliedtelesis.co.nz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 23adf53c2aa1c..cebc79a710ec2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4013,7 +4013,10 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			}
 		}
 
-		skb = build_skb(data, frag_size);
+		if (frag_size)
+			skb = build_skb(data, frag_size);
+		else
+			skb = slab_build_skb(data);
 		if (!skb) {
 			netdev_warn(port->dev, "skb build failed\n");
 			goto err_drop_frame;
-- 
2.43.0



