Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6AA1869;
	Sat, 13 Jan 2024 09:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yw6a+7aA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C198C433F1;
	Sat, 13 Jan 2024 09:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139771;
	bh=qzOnEfbWsBRdFsXfsjQNQRV/lWNvkOe3rXTCGj0/usA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yw6a+7aApXSD2Dg13/8mVa2hdA5p4QBo0nVUClQMSZ3dLkjCLoJtfvpkbC4qIQa/J
	 cmke/YUf+zTIXraqpdGmpoLc2RDZwVtExDPmFVZg+Fc+UDBhHEdnAOmVhEh5OnOjWG
	 B7AgyyF9yoziW4+J3dEsIrO1gDTPSpLeDPxcl814=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadfed@meta.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/38] net-timestamp: extend SOF_TIMESTAMPING_OPT_ID to HW timestamps
Date: Sat, 13 Jan 2024 10:49:43 +0100
Message-ID: <20240113094206.682696962@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.455533180@linuxfoundation.org>
References: <20240113094206.455533180@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit 8ca5a5790b9a1ce147484d2a2c4e66d2553f3d6c ]

When the feature was added it was enabled for SW timestamps only but
with current hardware the same out-of-order timestamps can be seen.
Let's expand the area for the feature to all types of timestamps.

Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7f6ca95d16b9 ("net: Implement missing getsockopt(SO_TIMESTAMPING_NEW)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c  | 2 +-
 net/ipv6/ip6_output.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index bf7c2333bc236..0f70c2dbbe5bb 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -993,7 +993,7 @@ static int __ip_append_data(struct sock *sk,
 	mtu = cork->gso_size ? IP_MAX_MTU : cork->fragsize;
 	paged = !!cork->gso_size;
 
-	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
+	if (cork->tx_flags & SKBTX_ANY_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
 		tskey = sk->sk_tskey++;
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index d3455585e6a8c..c67d634dccd47 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1425,7 +1425,7 @@ static int __ip6_append_data(struct sock *sk,
 	mtu = cork->gso_size ? IP6_MAX_MTU : cork->fragsize;
 	orig_mtu = mtu;
 
-	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
+	if (cork->tx_flags & SKBTX_ANY_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
 		tskey = sk->sk_tskey++;
 
-- 
2.43.0



