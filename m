Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523B330F931;
	Mon, 13 Oct 2025 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367867; cv=none; b=dYMavfINSn66GcgOCMBDfuYCXAEABkztcWhwRm6umYzoRa0sG/12CZThuOjS1D7yKKja4WngFU9GLhB5taAmO9mGPM0chV4NbplvSXlLKarUKXRJenPIGQETPHV24Kog3ID6/2VVGPJAhUxQQsjN8psex1GHC19sABdk5SWT8/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367867; c=relaxed/simple;
	bh=40C6nvBsSeMwaGzv5nwGBFPcUViP8Kz+qlkReaG8wUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2ZzwOup+nae3p1ia+NreMkgPZkRlnfSYGaPWeE3AZ/lLcKrvewnEBv0ezoCc8j3/Y17DgVyvgPoIud2cIvS8B2Qs+rGDeteYGVmvhlZYZoUZW5Ynxykmr7aOtZOsCeaIFaGwe1UiCdfI3ygDg7xOyFXsuOlK30X7HH1ajXqvcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npxz+2HP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npxz+2HP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFE7C4CEE7;
	Mon, 13 Oct 2025 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367867;
	bh=40C6nvBsSeMwaGzv5nwGBFPcUViP8Kz+qlkReaG8wUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npxz+2HPI2bpZeCA7Y0EGCIH/IfNPIFTz7Prcd22cmm8euSiR9l/XUin1klhZ702q
	 2f7GNbWZJAoUbsy2ptTtHRhmHMZW4eWqeYvrcldvLCSiL6dJIJF2IpfmsYj3s6QdR9
	 cwkAASlA8z5SsmTTlC5UTHKMMeOyync1nh9if/Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/196] net: ena: return 0 in ena_get_rxfh_key_size() when RSS hash key is not configurable
Date: Mon, 13 Oct 2025 16:45:51 +0200
Message-ID: <20251013144321.099222122@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit f017156aea60db8720e47591ed1e041993381ad2 ]

In EC2 instances where the RSS hash key is not configurable, ethtool
shows bogus RSS hash key since ena_get_rxfh_key_size() unconditionally
returns ENA_HASH_KEY_SIZE.

Commit 6a4f7dc82d1e ("net: ena: rss: do not allocate key when not
supported") added proper handling for devices that don't support RSS
hash key configuration, but ena_get_rxfh_key_size() has been unchanged.

When the RSS hash key is not configurable, return 0 instead of
ENA_HASH_KEY_SIZE to clarify getting the value is not supported.

Tested on m5 instance families.

Without patch:
 # ethtool -x ens5 | grep -A 1 "RSS hash key"
 RSS hash key:
 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00

With patch:
 # ethtool -x ens5 | grep -A 1 "RSS hash key"
 RSS hash key:
 Operation not supported

Fixes: 6a4f7dc82d1e ("net: ena: rss: do not allocate key when not supported")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Link: https://patch.msgid.link/20250929050247.51680-1-enjuk@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index d901877544445..82a7c52fdb721 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -752,7 +752,10 @@ static u32 ena_get_rxfh_indir_size(struct net_device *netdev)
 
 static u32 ena_get_rxfh_key_size(struct net_device *netdev)
 {
-	return ENA_HASH_KEY_SIZE;
+	struct ena_adapter *adapter = netdev_priv(netdev);
+	struct ena_rss *rss = &adapter->ena_dev->rss;
+
+	return rss->hash_key ? ENA_HASH_KEY_SIZE : 0;
 }
 
 static int ena_indirection_table_set(struct ena_adapter *adapter,
-- 
2.51.0



