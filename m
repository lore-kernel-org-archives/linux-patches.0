Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C418274B35;
	Tue, 21 Oct 2025 20:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077339; cv=none; b=ScJwxWNLZneh9JkDj+trNF4YVIj8AhoP0AMYX4V8aZ6sb1cORY754Ch8GTYyaEncPXrtsKLu8Zpn5XF3qR8uqKjSPYCBoa4YO/zw5Z9biJKGTonq4GEPbuv5ZYApDm/TMMurgN47sK3842FyjyeweRqp0+9QwnOMYl7EZB88lbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077339; c=relaxed/simple;
	bh=qW8lJ6DUM++mR7p5E3HgMGCWO2MKAAdyITVz/3DmPwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqAxKgPJD4Pnh1gxqyUdrK2c4vc2HE8ga4ROklelPHH2ZBA69xEmsUXkMCGRhe5XkRlsUWh7x2XGv7jKFysqD4SOl86htx2Lmopku+KSm59usDavlGT1pD/+hYX9it5jUnduhISQQwYfmXUx0PBJoLeGBZuoAWU2PHV34IkJh5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xElqhBz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xElqhBz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223BCC4CEF1;
	Tue, 21 Oct 2025 20:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077338;
	bh=qW8lJ6DUM++mR7p5E3HgMGCWO2MKAAdyITVz/3DmPwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xElqhBz5do3nEYG+/4FHZlg0XaOQWU8+UCdIhD9q8kWfggCu525AZqSrNdC2Xa/RX
	 um55HSD69Yv3KY+N4RBj5xaXKyRI65SBphyr1BipctRWPkVJKoMcziI0Knhj3t883j
	 jQnHZNorkmOnxQaXJBSp4KP2hSsKayc9GY9xi7B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milena Olech <milena.olech@intel.com>,
	Anton Nadezhdin <anton.nadezhdin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 073/159] idpf: cleanup remaining SKBs in PTP flows
Date: Tue, 21 Oct 2025 21:50:50 +0200
Message-ID: <20251021195044.959475797@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milena Olech <milena.olech@intel.com>

[ Upstream commit a3f8c0a273120fd2638f03403e786c3de2382e72 ]

When the driver requests Tx timestamp value, one of the first steps is
to clone SKB using skb_get. It increases the reference counter for that
SKB to prevent unexpected freeing by another component.
However, there may be a case where the index is requested, SKB is
assigned and never consumed by PTP flows - for example due to reset during
running PTP apps.

Add a check in release timestamping function to verify if the SKB
assigned to Tx timestamp latch was freed, and release remaining SKBs.

Fixes: 4901e83a94ef ("idpf: add Tx timestamp capabilities negotiation")
Signed-off-by: Milena Olech <milena.olech@intel.com>
Signed-off-by: Anton Nadezhdin <anton.nadezhdin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251009-jk-iwl-net-2025-10-01-v3-1-ef32a425b92a@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_ptp.c          | 3 +++
 drivers/net/ethernet/intel/idpf/idpf_virtchnl_ptp.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ptp.c b/drivers/net/ethernet/intel/idpf/idpf_ptp.c
index ee21f2ff0cad9..63a41e688733b 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ptp.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ptp.c
@@ -855,6 +855,9 @@ static void idpf_ptp_release_vport_tstamp(struct idpf_vport *vport)
 	head = &vport->tx_tstamp_caps->latches_in_use;
 	list_for_each_entry_safe(ptp_tx_tstamp, tmp, head, list_member) {
 		list_del(&ptp_tx_tstamp->list_member);
+		if (ptp_tx_tstamp->skb)
+			consume_skb(ptp_tx_tstamp->skb);
+
 		kfree(ptp_tx_tstamp);
 	}
 
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl_ptp.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl_ptp.c
index 4f1fb0cefe516..688a6f4e0acc8 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl_ptp.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl_ptp.c
@@ -517,6 +517,7 @@ idpf_ptp_get_tstamp_value(struct idpf_vport *vport,
 	shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
 	skb_tstamp_tx(ptp_tx_tstamp->skb, &shhwtstamps);
 	consume_skb(ptp_tx_tstamp->skb);
+	ptp_tx_tstamp->skb = NULL;
 
 	list_add(&ptp_tx_tstamp->list_member,
 		 &tx_tstamp_caps->latches_free);
-- 
2.51.0



