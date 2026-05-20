Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0303E27E045;
	Wed, 20 May 2026 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296588; cv=none; b=tkH4U6M5L+RT/oBFBA6VqifqhVZVc2UiRC2cZ9KJPVRlNE4Xj+2tVonA2eQS48YTcB2gZycCuVEDKvgNHkQfWtumF7xjf61Zi8kdkmJT349OaHQLVtD3KqXl/sq9R1w1YCi4jlAxjtj0NAotoPoG6AJyX92uuuohXQf8TfeuIhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296588; c=relaxed/simple;
	bh=DJNAU/Qhqg7nLRLD16Vh3dB1p9+sodAp5EzXFFzZ/Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uStxSqVS9a3FEx3hDbGP1g8pPO3TFR5XCRqhOwCw1wnnBFVXfOFM3E+BX7tCLOV+Ahafn09lXhOViQkkL50UKhzU/JIrm1iBoSrHAbbsn6AciB9Q5ZE3FOnk/t7UgDjZ0VVGKEZKm2uDyEzudr2eNd09ZV4ONiRIvrPMsoxMsoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yql7GLOc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yql7GLOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD03B1F000E9;
	Wed, 20 May 2026 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296585;
	bh=63iGXUbq4/KktTLZnv673niiGkBdI9U+cshMNcctqMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yql7GLOcZgcooxIKcAEnX9EVTna6QjVTAej8EkJcGE1b4r5lIFDnNW7FnCyX2iRP6
	 GJhV9quvsigecuxkHbBk462RGtlXXwh0w+QCJi2h3Ci/sAsysFy55ZN0dn+pl6yXs3
	 /eXGV1og7/Hb9iv6dM9rX4HtKtRzq1BW4TnflS7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0854/1146] net: mana: Fix EQ leak in mana_remove on NULL port
Date: Wed, 20 May 2026 18:18:24 +0200
Message-ID: <20260520162207.566329562@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 65267c9c4f28199985505977bc2c628c82fc50ef ]

In mana_remove(), when a NULL port is encountered in the port iteration
loop, 'goto out' skips the mana_destroy_eq(ac) call, leaking the event
queues allocated earlier by mana_create_eq().

This can happen when mana_probe_port() fails for port 0, leaving
ac->ports[0] as NULL. On driver unload or error cleanup, mana_remove()
hits the NULL entry and jumps past mana_destroy_eq().

Change 'goto out' to 'break' so the for-loop exits normally and
mana_destroy_eq() is always reached. Remove the now-unreferenced out:
label.

Fixes: 1e2d0824a9c3 ("net: mana: Add support for EQ sharing")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260420124741.1056179-6-ernis@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 09d67617dfbbf..14d6f68eaa695 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3715,7 +3715,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 		if (!ndev) {
 			if (i == 0)
 				dev_err(dev, "No net device to remove\n");
-			goto out;
+			break;
 		}
 
 		apc = netdev_priv(ndev);
@@ -3746,7 +3746,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	}
 
 	mana_destroy_eq(ac);
-out:
+
 	if (ac->per_port_queue_reset_wq) {
 		destroy_workqueue(ac->per_port_queue_reset_wq);
 		ac->per_port_queue_reset_wq = NULL;
-- 
2.53.0



