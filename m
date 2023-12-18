Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B766129ED2;
	Mon, 18 Dec 2023 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2kplZ4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7ABC433C7;
	Mon, 18 Dec 2023 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907555;
	bh=H79vucaDcN2cN8yzJnL0xU4hGTsqsBeCmvDCVJebpX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2kplZ4w6mnAj+IoHIkVzEfaUQCyEePCGs19DCtHTmKUSUrZUNzLevW/UPZNjvvau
	 m9zQnO4xk1LreHOtozXb5kyA5IpmG5Ikxcf6KL528OZ6xfdqA2b7eAwaCX2VFOdcPi
	 t/uwQNjD+TQ58sd/SHqzBCYUbvHVeJEUBchcj7Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/26] atm: solos-pci: Fix potential deadlock on &tx_queue_lock
Date: Mon, 18 Dec 2023 14:51:07 +0100
Message-ID: <20231218135040.860983335@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135040.665690087@linuxfoundation.org>
References: <20231218135040.665690087@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <dg573847474@gmail.com>

[ Upstream commit 15319a4e8ee4b098118591c6ccbd17237f841613 ]

As &card->tx_queue_lock is acquired under softirq context along the
following call chain from solos_bh(), other acquisition of the same
lock inside process context should disable at least bh to avoid double
lock.

<deadlock #2>
pclose()
--> spin_lock(&card->tx_queue_lock)
<interrupt>
   --> solos_bh()
   --> fpga_tx()
   --> spin_lock(&card->tx_queue_lock)

This flaw was found by an experimental static analysis tool I am
developing for irq-related deadlock.

To prevent the potential deadlock, the patch uses spin_lock_bh()
on &card->tx_queue_lock under process context code consistently to
prevent the possible deadlock scenario.

Fixes: 213e85d38912 ("solos-pci: clean up pclose() function")
Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/solos-pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 3a115c7f224fb..07a136cc20ab5 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -968,14 +968,14 @@ static void pclose(struct atm_vcc *vcc)
 	struct pkt_hdr *header;
 
 	/* Remove any yet-to-be-transmitted packets from the pending queue */
-	spin_lock(&card->tx_queue_lock);
+	spin_lock_bh(&card->tx_queue_lock);
 	skb_queue_walk_safe(&card->tx_queue[port], skb, tmpskb) {
 		if (SKB_CB(skb)->vcc == vcc) {
 			skb_unlink(skb, &card->tx_queue[port]);
 			solos_pop(vcc, skb);
 		}
 	}
-	spin_unlock(&card->tx_queue_lock);
+	spin_unlock_bh(&card->tx_queue_lock);
 
 	skb = alloc_skb(sizeof(*header), GFP_KERNEL);
 	if (!skb) {
-- 
2.43.0



