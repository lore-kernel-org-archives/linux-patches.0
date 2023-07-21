Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826E21F94D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D93C433C7;
	Fri, 21 Jul 2023 16:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956649;
	bh=DtnIluKV9lEKWp06u9tJP/B05JmMk+0HLeohL+d63/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hid/tZFKuQHNE3YyqZT38iQsNwfZBVEvkE0MnfghcXziNJYkTNurkiYGNT+1S1sKJ
	 xOJ8lMldAdA9jygP050Csburz8xF3SToANOiInU6rPDs1BcpKEtmFEfthCxNaYZIbl
	 JWGTcVS79tKemrt7wv3dTys/rqDUjYLObCsrZ000=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinjun Zhang <yinjun.zhang@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 224/292] nfp: clean mc addresses in application firmware when closing port
Date: Fri, 21 Jul 2023 18:05:33 +0200
Message-ID: <20230721160538.492485791@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yinjun Zhang <yinjun.zhang@corigine.com>

commit cc7eab25b1cf3f9594fe61142d3523ce4d14a788 upstream.

When moving devices from one namespace to another, mc addresses are
cleaned in software while not removed from application firmware. Thus
the mc addresses are remained and will cause resource leak.

Now use `__dev_mc_unsync` to clean mc addresses when closing port.

Fixes: e20aa071cd95 ("nfp: fix schedule in atomic context when sync mc address")
Cc: stable@vger.kernel.org
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Message-ID: <20230705052818.7122-1-louis.peens@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 49f2f081ebb5..6b1fb5708434 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -53,6 +53,8 @@
 #include "crypto/crypto.h"
 #include "crypto/fw.h"
 
+static int nfp_net_mc_unsync(struct net_device *netdev, const unsigned char *addr);
+
 /**
  * nfp_net_get_fw_version() - Read and parse the FW version
  * @fw_ver:	Output fw_version structure to read to
@@ -1084,6 +1086,9 @@ static int nfp_net_netdev_close(struct net_device *netdev)
 
 	/* Step 2: Tell NFP
 	 */
+	if (nn->cap_w1 & NFP_NET_CFG_CTRL_MCAST_FILTER)
+		__dev_mc_unsync(netdev, nfp_net_mc_unsync);
+
 	nfp_net_clear_config_and_disable(nn);
 	nfp_port_configure(netdev, false);
 
-- 
2.41.0



