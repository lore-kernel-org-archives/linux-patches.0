Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4273519B3EF;
	Thu,  6 Jun 2024 14:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683063; cv=none; b=EQGMC6dJi0B7gRS8kOb/zh+2fwba7T66r/Ca4xGjuMBvRMyGcfUX6WmpKqw0UTksfjbIluosgmyFTHaDwIWE5EwSSAyA0EgWGM1JOQijNsTB0AbCj5OiNYpe0S4+RsVj2kaAWEHT1tyOsS4PbVWJc7IH4ErLarm6hPKkEGO61T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683063; c=relaxed/simple;
	bh=7zud4JNfLUuM3WQIll6vT/5XtlTb7h7RpT2HcrW7r0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc/JUroxymXXgFxv8tvfHqsdgnVwMMpFNzv/mpIuDUDjQM2fDR9fFd7NGLbeyGM19M9dNH/isy7ZJuBV/jdPBR34fK7zBikYFQSnbb/WJjeosFJBdiW1/G9h4/WiT7sF0Mg8VTTVUGx2lizm9Kkr4U/JuceeDINv6DMsrUj14LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2S7v7/HR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2S7v7/HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFD2C4AF11;
	Thu,  6 Jun 2024 14:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683063;
	bh=7zud4JNfLUuM3WQIll6vT/5XtlTb7h7RpT2HcrW7r0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2S7v7/HRX7IabIeHtH20mpmed9vY7nTu+x+TclopVI6O5RLV1ZoUHQapmLj/big4S
	 Jo/RsH2wnMtQhvSY/qcyz7X6mOFJCv+eZH2882dKmWF8t75af3PqGXZI+cuPP32mpo
	 k9Xb96pMF7uuYyIh1gsJGyhPrbMeWkr5NPQM2Bpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Igor Bagnucki <igor.bagnucki@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 274/374] idpf: Interpret .set_channels() input differently
Date: Thu,  6 Jun 2024 16:04:13 +0200
Message-ID: <20240606131701.081572830@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 5e7695e0219bf6acb96081af3ba0ca08b1829656 ]

Unlike ice, idpf does not check, if user has requested at least 1 combined
channel. Instead, it relies on a check in the core code. Unfortunately, the
check does not trigger for us because of the hacky .set_channels()
interpretation logic that is not consistent with the core code.

This naturally leads to user being able to trigger a crash with an invalid
input. This is how:

1. ethtool -l <IFNAME> -> combined: 40
2. ethtool -L <IFNAME> rx 0 tx 0
   combined number is not specified, so command becomes {rx_count = 0,
   tx_count = 0, combined_count = 40}.
3. ethnl_set_channels checks, if there is at least 1 RX and 1 TX channel,
   comparing (combined_count + rx_count) and (combined_count + tx_count)
   to zero. Obviously, (40 + 0) is greater than zero, so the core code
   deems the input OK.
4. idpf interprets `rx 0 tx 0` as 0 channels and tries to proceed with such
   configuration.

The issue has to be solved fundamentally, as current logic is also known to
cause AF_XDP problems in ice [0].

Interpret the command in a way that is more consistent with ethtool
manual [1] (--show-channels and --set-channels) and new ice logic.

Considering that in the idpf driver only the difference between RX and TX
queues forms dedicated channels, change the correct way to set number of
channels to:

ethtool -L <IFNAME> combined 10 /* For symmetric queues */
ethtool -L <IFNAME> combined 8 tx 2 rx 0 /* For asymmetric queues */

[0] https://lore.kernel.org/netdev/20240418095857.2827-1-larysa.zaremba@intel.com/
[1] https://man7.org/linux/man-pages/man8/ethtool.8.html

Fixes: 02cbfba1add5 ("idpf: add ethtool callbacks")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Igor Bagnucki <igor.bagnucki@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/idpf/idpf_ethtool.c    | 21 ++++++-------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index 6972d728431cb..1885ba618981d 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -222,14 +222,19 @@ static int idpf_set_channels(struct net_device *netdev,
 			     struct ethtool_channels *ch)
 {
 	struct idpf_vport_config *vport_config;
-	u16 combined, num_txq, num_rxq;
 	unsigned int num_req_tx_q;
 	unsigned int num_req_rx_q;
 	struct idpf_vport *vport;
+	u16 num_txq, num_rxq;
 	struct device *dev;
 	int err = 0;
 	u16 idx;
 
+	if (ch->rx_count && ch->tx_count) {
+		netdev_err(netdev, "Dedicated RX or TX channels cannot be used simultaneously\n");
+		return -EINVAL;
+	}
+
 	idpf_vport_ctrl_lock(netdev);
 	vport = idpf_netdev_to_vport(netdev);
 
@@ -239,20 +244,6 @@ static int idpf_set_channels(struct net_device *netdev,
 	num_txq = vport_config->user_config.num_req_tx_qs;
 	num_rxq = vport_config->user_config.num_req_rx_qs;
 
-	combined = min(num_txq, num_rxq);
-
-	/* these checks are for cases where user didn't specify a particular
-	 * value on cmd line but we get non-zero value anyway via
-	 * get_channels(); look at ethtool.c in ethtool repository (the user
-	 * space part), particularly, do_schannels() routine
-	 */
-	if (ch->combined_count == combined)
-		ch->combined_count = 0;
-	if (ch->combined_count && ch->rx_count == num_rxq - combined)
-		ch->rx_count = 0;
-	if (ch->combined_count && ch->tx_count == num_txq - combined)
-		ch->tx_count = 0;
-
 	num_req_tx_q = ch->combined_count + ch->tx_count;
 	num_req_rx_q = ch->combined_count + ch->rx_count;
 
-- 
2.43.0



