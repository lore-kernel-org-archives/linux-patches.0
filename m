Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925151B85E2;
	Mon, 14 Oct 2024 15:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919966; cv=none; b=t6IijdqkXm62SqRPU6xATIlokVmBfxqsMRX/2d8MYh8wk76dp0bQY2Emtog/OOuwkmFkM/bt0mYGnoT+xHOKzXJ6C/8UIpMdObhVB+aDNg5fVUETfMpuYTn1+htr7ZJa8ZhbNLRxyWESucR9c5Wf7Rhi52fSX62IE+pmkliZMPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919966; c=relaxed/simple;
	bh=f8/nNFcRK2ThEeaEmX8u3z9WH7afdHpvZJzaFr9l2Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0dwYpKLJggsiTIegRp/4+l/M/W5w4Z2hhtVZbO6RHKWvOUJT7mecemY+KN6TnnHPtWoXHVQdsiKqMsgE4QBwNIqn0drauNvFzDNB5GE0He2K4DWqqizViD8zAFNFgsnvhzmhScfNEn5/KOYvvWygZxX6Hq0og2bbX9vX5Aw2oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnFIsUMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnFIsUMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1049C4CEC3;
	Mon, 14 Oct 2024 15:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919966;
	bh=f8/nNFcRK2ThEeaEmX8u3z9WH7afdHpvZJzaFr9l2Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnFIsUMBzgy0ygYbJYLvCfgVFngF/m5OdWkaga3Y2Ia6pThP4s/xaRl4bG9h1ypdl
	 yjEdVEVgCsmeKoTqICqGTxhMqCeMdWJPEWLcAPcIerU1jk9JsaYqkaYE7P+ThLht8E
	 nOb8qj11ZMZQ/qyQo+8+n4BDqyVa5GHCQp6pb/NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 759/798] net: ibm: emac: mal: add dcr_unmap to _remove
Date: Mon, 14 Oct 2024 16:21:53 +0200
Message-ID: <20241014141247.886119810@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 080ddc22f3b0a58500f87e8e865aabbf96495eea ]

It's done in probe so it should be undone here.

Fixes: 1d3bb996481e ("Device tree aware EMAC driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20241008233050.9422-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index 7a74975c15fa5..1ebe44804f9d0 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -740,6 +740,8 @@ static int mal_remove(struct platform_device *ofdev)
 
 	free_netdev(mal->dummy_dev);
 
+	dcr_unmap(mal->dcr_host, 0x100);
+
 	dma_free_coherent(&ofdev->dev,
 			  sizeof(struct mal_descriptor) *
 			  (NUM_TX_BUFF * mal->num_tx_chans +
-- 
2.43.0



