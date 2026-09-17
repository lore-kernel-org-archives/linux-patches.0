Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6204DA9B0;
	Thu, 17 Sep 2026 17:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665639; cv=none; b=rpeSlgFJ2x6Z6/JOXDw8ak3vH6CdXQM78oS8u+SJqo25TBvqzoPFbvsdFscfKRbnBJoiAPR6xkFEf48JuWjBY+NCbqxa8WPGIGKkfOjsvdmeME+jLZfwx3sUr3dyGWCFiz8YsfUCJ0rPaTuiumbm6SySA/2uPVxPnWXs9ibG8qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665639; c=relaxed/simple;
	bh=84za/Lo9pYAM3osc5oh0UhfhUCzv9zrUBZp+hUIyNxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEbGrZ1bBlJ8WF89lswpgmZnWs+TJH/ny06GyCjkPYreI8+9vvGYnxqIOX88t1dBkthQkljFC4k+SrbEAamV6s6eNKC3Z1Igbbw/HCN21o8CDgWkN1RYkXzbahEGfE+FW10eJdSKzBKSmNk4oJEHNKa0YS2hIez/cixOVfhNuUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qGAeaNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qGAeaNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A262A1F000FF;
	Thu, 17 Sep 2026 17:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665638;
	bh=ATYe+AlsKO7VrAzUmQS/3wvP6wdFi/4u7F9lbdzARmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qGAeaNItLmH7jRKYI1/bzqkRFoWQWkqlm1zlkNzHemstlCeyMyd7vOwTgRBZ+oy9
	 6kWL2f8K9Xp/Gpb63z+KIxuZr1xsGc7evmEUG39WYhjeGapEXhikifDKrXOpKQFS9G
	 8RMrqi/kWvI3uTF5dgcDZeWGZLvkm6MGFBf3QljA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0770/1250] net: bcmasp: fix tx_spb_ring_full() checking same slot cnt times
Date: Thu, 17 Sep 2026 16:09:25 +0100
Message-ID: <20260917151612.746871955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 0c5cf62e72d7a666ee4da757e122dc1600df1ecc ]

The loop initialised next_index from intf->tx_spb_index on every
iteration, so incr_ring() always produced the same result and only
one slot was ever tested.  Move the initialisation before the loop
so each iteration advances next_index and the function correctly
checks that cnt consecutive descriptor slots are available before
allowing a new transmission.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260831184235.4133351-3-danesh.petigara@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 4e2edd537da57..d4de48c3132a3 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -147,8 +147,9 @@ static int tx_spb_ring_full(struct bcmasp_intf *intf, int cnt)
 	int next_index, i;
 
 	/* Check if we have enough room for cnt descriptors */
+	next_index = intf->tx_spb_index;
 	for (i = 0; i < cnt; i++) {
-		next_index = incr_ring(intf->tx_spb_index, DESC_RING_COUNT);
+		next_index = incr_ring(next_index, DESC_RING_COUNT);
 		if (next_index == intf->tx_spb_clean_index)
 			return 1;
 	}
-- 
2.53.0



