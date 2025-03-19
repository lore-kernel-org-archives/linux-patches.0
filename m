Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EB81DED44;
	Wed, 19 Mar 2025 14:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394983; cv=none; b=UA5fuG3HuSpGEfeE9dmQOp7O3B6y6ae9RlesRMyT72r/eWrSTPuazW5SJU4udADkQwVYahLlCt/ljNVX4PZ4X9rmGZ+8tMiFaoQJzqMduolqP/uePL6+oOJzgTsWHwuW6kv7e8p9cXtxoNcMm6M/7VAYOkb5/H+l1WLRGeLos1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394983; c=relaxed/simple;
	bh=0m9GeUBnmtlBItobqB1YP/u9fDC/8J9Zfqwse8G4sPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugxUy0h1NU6TtciWR5e/DlZTuz2njMl0vxJRFFOgjne0CImuFPbn1ttaVMpOlCNMpt43o7Rni7n3NbkBoSPz0WOTxyaWaeNt8lhXArVXKuzk6Ppz2126r0tCUYXdrjcp0oferGzG/8f4YOKCwHaNE5CcVFUV+e9uCQaS3rC2crI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wv5/l6V0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wv5/l6V0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B896C4CEE4;
	Wed, 19 Mar 2025 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394983;
	bh=0m9GeUBnmtlBItobqB1YP/u9fDC/8J9Zfqwse8G4sPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wv5/l6V0RpU7nRhY3hINBErRwsAk6RsAqHMEr3j2++RL0b2CvEX0cWslC5hZuTRUh
	 k2/az4FNY85njdliQqu2wv5c0QpPFk/AvBEkrTiY/ffcwDRvCchkuFC2+Z3wZhSJJA
	 pMG3/I1KkJvfJ5eulkmcuffSFbnDUHJNlxJEOVMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH 6.13 196/241] netmem: prevent TX of unreadable skbs
Date: Wed, 19 Mar 2025 07:31:06 -0700
Message-ID: <20250319143032.568317796@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

commit f3600c867c99a2cc8038680ecf211089c50e7971 upstream.

Currently on stable trees we have support for netmem/devmem RX but not
TX. It is not safe to forward/redirect an RX unreadable netmem packet
into the device's TX path, as the device may call dma-mapping APIs on
dma addrs that should not be passed to it.

Fix this by preventing the xmit of unreadable skbs.

Tested by configuring tc redirect:

sudo tc qdisc add dev eth1 ingress
sudo tc filter add dev eth1 ingress protocol ip prio 1 flower ip_proto \
	tcp src_ip 192.168.1.12 action mirred egress redirect dev eth1

Before, I see unreadable skbs in the driver's TX path passed to dma
mapping APIs.

After, I don't see unreadable skbs in the driver's TX path passed to dma
mapping APIs.

Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250306215520.1415465-1-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3725,6 +3725,9 @@ static struct sk_buff *validate_xmit_skb
 {
 	netdev_features_t features;
 
+	if (!skb_frags_readable(skb))
+		goto out_kfree_skb;
+
 	features = netif_skb_features(skb);
 	skb = validate_xmit_vlan(skb, features);
 	if (unlikely(!skb))


