Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EC24E4302;
	Tue, 13 Oct 2026 11:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892103; cv=none; b=GFbPC6euE9vpPTzWnQPW6JesSYeBa9SV0rshRMhdJuFiSKsv1sapEhAe96ZqnKRa8ZzDNrn233tbHWY34MwbpYZAWCSbvhEDTp0j2uoB7RLPPthxj4UDpUq5DNXxENS5BsPGGlC2i3EHukixWbj1pl5ne7g/SqMej0WLSKfh7I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892103; c=relaxed/simple;
	bh=GBiOWJScyO9DN+8/9ov8oGATSfsKTbdsaTaHa7RZG7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2HRDm3EYeIre4qkNmvkjbqIIw9drk1MRceNE1jdDajPNVRflb7mjvtnly63UKjgGdnlOw0eZlV65jVyHeEf5fkHWlzAcB/yB+Nqux2M5eTzgt2Skrq1rf9FooNSGePVNU0/vVExuiwbJpXCUehCfriXBprkc8heW0xfH4zfLcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVDkGwcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVDkGwcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5DC1F000FF;
	Tue, 13 Oct 2026 11:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892102;
	bh=IiWhz80EMAb4Q55uKRe7p7gQNCxoQv3v3MiCBhtQTQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVDkGwcfYGICfet3aySzzRRnljBFIeMtVoB5afFjsrJJAXubCXfGgtUIL+xJzX5yk
	 X9YX8Pkt/coI9/EQZSTto44AMwKL+8j3WF/26kqUbiedp4QoR7u400JPwwI48LkyxP
	 JCUI4mpw1rXj5nGdNlaBZinsdv0JmdhNrakaTKqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 060/281] ibmveth: h_free logical LAN on open-fail after register
Date: Tue, 13 Oct 2026 13:36:16 +0200
Message-ID: <20261013112856.583854107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingming Cao <mmc@linux.ibm.com>

commit af0524bf4ce1a4cbd2946aa81751582951cfcab5 upstream.

ibmveth_open() registers the logical LAN, then allocates the RX
buffer pools. A pool failure jumps to out_free_buffer_pools without
h_free_logical_lan(), so PHYP still owns the buffer-list page when
it is unmapped. request_irq() failure already issued the hypercall
before taking the same label.

Move that h_free to the shared post-register unwind so both paths
deregister before the buffer list is unmapped.

Fixes: d43732ce021f ("ibmveth: properly unwind on init errors")
Cc: stable@vger.kernel.org
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
Link: https://patch.msgid.link/7a56fbfb9e0674f011f4e310fbd7dfd8e67c30aa.1790357373.git.mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -718,10 +718,6 @@ static int ibmveth_open(struct net_devic
 	if (rc != 0) {
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
-		do {
-			lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
-		} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
-
 		goto out_free_buffer_pools;
 	}
 
@@ -737,6 +733,9 @@ static int ibmveth_open(struct net_devic
 	return 0;
 
 out_free_buffer_pools:
+	do {
+		lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
+	} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
 	while (--i >= 0) {
 		if (adapter->rx_buff_pool[i].active)
 			ibmveth_free_buffer_pool(adapter,


