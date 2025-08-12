Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35E82FAC06;
	Tue, 12 Aug 2025 18:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024997; cv=none; b=jGhlhGAJhw/u6v+UfWPHormE5DeKeyDJEim+VGWNU0Je2/5OXRkXhC+IJlbRB9VW9r5Uu2Ujdrfdsl2CrjuM8d8Pm0pI9fagQ31ELCULBIh63EqGl4hGuYO/ka3G1x2zU+Drr4Rp+kBfwJytcp1kvnIhgM+w2dHkxzVXf4VfLxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024997; c=relaxed/simple;
	bh=iCCYMdWtXCTxVQi6v7v2aSoUOd3q8EvZ4XdLEeFNfeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVPTPWiuijj3Y3HGBqG0lH10H8wHCdApZZjRJWH6wR1f7EgGfgRB6lq3otap1OTiVbydnaVdr7pyEVU4SuPgT6BYaXisGQrM8wZ+DQgAYTwDFvzmVCluREvN0yWz3eZfnyqCVDkj/K3uFJIT5nSAzxf8oMGXav1Tq0vTdpNzxkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JopbUZjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JopbUZjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43278C4CEF0;
	Tue, 12 Aug 2025 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024997;
	bh=iCCYMdWtXCTxVQi6v7v2aSoUOd3q8EvZ4XdLEeFNfeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JopbUZjgSzh54iqCvCGmm9skm/n03iALDkoXuc2Tdn+5hnOP6MGZIepWwWL/RFAwr
	 NmDkAPaI+sODIZFIWK4CqcsD24oIwGoyMZdiIjPG/N2IKZEByp8hncGhctKULjllz/
	 Grwcy4Q1tkrBelkVhfPWAH355zu+y6uBG7QGWY3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 540/627] eth: fbnic: unlink NAPIs from queues on error to open
Date: Tue, 12 Aug 2025 19:33:55 +0200
Message-ID: <20250812173452.449881637@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4b31bcb025cb497da2b01f87173108ff32d350d2 ]

CI hit a UaF in fbnic in the AF_XDP portion of the queues.py test.
The UaF is in the __sk_mark_napi_id_once() call in xsk_bind(),
NAPI has been freed. Looks like the device failed to open earlier,
and we lack clearing the NAPI pointer from the queue.

Fixes: 557d02238e05 ("eth: fbnic: centralize the queue count and NAPI<>queue setting")
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250728163129.117360-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index aa812c63d5af..93717cf5bd8f 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -33,7 +33,7 @@ int __fbnic_open(struct fbnic_net *fbn)
 		dev_warn(fbd->dev,
 			 "Error %d sending host ownership message to the firmware\n",
 			 err);
-		goto free_resources;
+		goto err_reset_queues;
 	}
 
 	err = fbnic_time_start(fbn);
@@ -57,6 +57,8 @@ int __fbnic_open(struct fbnic_net *fbn)
 	fbnic_time_stop(fbn);
 release_ownership:
 	fbnic_fw_xmit_ownership_msg(fbn->fbd, false);
+err_reset_queues:
+	fbnic_reset_netif_queues(fbn);
 free_resources:
 	fbnic_free_resources(fbn);
 free_napi_vectors:
-- 
2.39.5



