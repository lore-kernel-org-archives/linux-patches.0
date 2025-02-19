Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9151AF0C8;
	Wed, 19 Feb 2025 08:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954583; cv=none; b=TpZejjGJpANrQ18roM+Ebgv6NHzrxrxLSpB7hH0njvwkwKz2nLocWDkiUb41RlD5yW/BU583OQI74s+mIpG+HdEwMCF+YxYSh5seRH0g2Iw5L+XX3srN9gabIYf2iL92XSAfjsNet/QFgnleA+G8MfzKyIgSmcZOJv5pKluDZ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954583; c=relaxed/simple;
	bh=T/BKVZ/BvSvsZa88A7wQnV4t2CgloaWO8Rf9ebI+YNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=md7IpajX5uLERwOgLQ9Rd2p/CXEPsAKCwN0GB9ljf2vKfFg7Adn2xLGAMATezTUUUlztkfW7JzWlCsX37+a5jzRKqSFUuDUdVy2aJr6uGv8Lv0C8RJ8OKlfsfcjq+JgGPxVz6BJv02zwc4r0L5okMhhCaN8PRMveFPzcvHXuJr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZobAbtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZobAbtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C85C4CED1;
	Wed, 19 Feb 2025 08:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954583;
	bh=T/BKVZ/BvSvsZa88A7wQnV4t2CgloaWO8Rf9ebI+YNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZobAbtDIBtMUTmYp/LCD5oir+eXa4LUM/Qb+lUqoci2oAS1FOOL8eUPN8NEQYD1i
	 ue8NJwNMLrwYqvNzXzSE98l9BThOmD4oFUkXlnC1jlcfG1+xrkfhUeW1nVC0qQzA49
	 2HU/48sx/6dNZv8cqs6CASdikUSfgeHUUnB00Rko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 249/274] s390/qeth: move netif_napi_add_tx() and napi_enable() from under BH
Date: Wed, 19 Feb 2025 09:28:23 +0100
Message-ID: <20250219082619.324177916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 0d0b752f2497471ddd2b32143d167d42e18a8f3c ]

Like other drivers qeth is calling local_bh_enable() after napi_schedule()
to kick-start softirqs [0].
Since netif_napi_add_tx() and napi_enable() now take the netdev_lock()
mutex [1], move them out from under the BH protection. Same solution as in
commit a60558644e20 ("wifi: mt76: move napi_enable() from under BH")

Fixes: 1b23cdbd2bbc ("net: protect netdev->napi_list with netdev_lock()")
Link: https://lore.kernel.org/netdev/20240612181900.4d9d18d0@kernel.org/ [0]
Link: https://lore.kernel.org/netdev/20250115035319.559603-1-kuba@kernel.org/ [1]
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Acked-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20250212163659.2287292-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index a3adaec5504e4..20328d695ef92 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -7050,14 +7050,16 @@ int qeth_open(struct net_device *dev)
 	card->data.state = CH_STATE_UP;
 	netif_tx_start_all_queues(dev);
 
-	local_bh_disable();
 	qeth_for_each_output_queue(card, queue, i) {
 		netif_napi_add_tx(dev, &queue->napi, qeth_tx_poll);
 		napi_enable(&queue->napi);
-		napi_schedule(&queue->napi);
 	}
-
 	napi_enable(&card->napi);
+
+	local_bh_disable();
+	qeth_for_each_output_queue(card, queue, i) {
+		napi_schedule(&queue->napi);
+	}
 	napi_schedule(&card->napi);
 	/* kick-start the NAPI softirq: */
 	local_bh_enable();
-- 
2.39.5



