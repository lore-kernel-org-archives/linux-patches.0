Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AE4168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86B2C433EF;
	Mon,  8 May 2023 10:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543153;
	bh=zBdp+zsekEOSqHB0BbV85+KLf0Bky9LWx3/+WQuJjGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWRxCRK6n3BdqRVwCDOgxjVipiU759BgX/ZVDC/Lmzgcs/zEqtN50vcoC30fLbW+J
	 COousMm57Aim3BrsYZLC4w4oyepg10WQs6MhG2ZIEJGdifVhHGJAQNi9a44e+rB0U8
	 810G2NLqCo+Tt2oJlsv7sZBUHMNb+AojpH9FonMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huanhuan Wang <huanhuan.wang@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 633/663] nfp: fix incorrect pointer deference when offloading IPsec with bonding
Date: Mon,  8 May 2023 11:47:39 +0200
Message-Id: <20230508094450.435602755@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huanhuan Wang <huanhuan.wang@corigine.com>

commit 63cfd210034c772fad047afa13dd5a4664b0a72e upstream.

There are two pointers in struct xfrm_dev_offload, *dev, *real_dev.
The *dev points whether bonding interface or real interface, if
bonding IPsec offload is used, it points bonding interface; if not,
it points real interface. And *real_dev always points real interface.
So nfp should always use real_dev instead of dev.

Prior to this change the system becomes unresponsive when offloading
IPsec for a device which is a lower device to a bonding device.

Fixes: 859a497fe80c ("nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer")
CC: stable@vger.kernel.org
Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Link: https://lore.kernel.org/r/20230420140125.38521-1-louis.peens@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -267,7 +267,7 @@ static void set_sha2_512hmac(struct nfp_
 
 static int nfp_net_xfrm_add_state(struct xfrm_state *x)
 {
-	struct net_device *netdev = x->xso.dev;
+	struct net_device *netdev = x->xso.real_dev;
 	struct nfp_ipsec_cfg_mssg msg = {};
 	int i, key_len, trunc_len, err = 0;
 	struct nfp_ipsec_cfg_add_sa *cfg;
@@ -503,7 +503,7 @@ static void nfp_net_xfrm_del_state(struc
 		.cmd = NFP_IPSEC_CFG_MSSG_INV_SA,
 		.sa_idx = x->xso.offload_handle - 1,
 	};
-	struct net_device *netdev = x->xso.dev;
+	struct net_device *netdev = x->xso.real_dev;
 	struct nfp_net *nn;
 	int err;
 


