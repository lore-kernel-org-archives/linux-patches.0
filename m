Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF876FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B05C433CB;
	Sun, 17 Sep 2023 20:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983298;
	bh=jVMoetdjx2myosw4xd8mjeQZe2Rvi3UtzKFjsDmbzMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbG19bQP2wxm/NmFgejcKYqwS3XQgRzBvei6Y3t5H4guFeg/MGVpCg50lngNtiJa7
	 fkQCsS5pY9f2jvbIbVrfv8C9a6RSomCQJyGA4XBNCqY3yx5AnU5n9bjBRQRbh+qYhW
	 5ofuSALWb6T4QNQyrXZTPFBvycphQ1CzIV5lPVoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 500/511] r8152: check budget for r8152_poll()
Date: Sun, 17 Sep 2023 21:15:27 +0200
Message-ID: <20230917191125.798348313@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit a7b8d60b37237680009dd0b025fe8c067aba0ee3 ]

According to the document of napi, there is no rx process when the
budget is 0. Therefore, r8152_poll() has to return 0 directly when the
budget is equal to 0.

Fixes: d2187f8e4454 ("r8152: divide the tx and rx bottom functions")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 579524cb5d9b2..4cd9bcca84c5b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2625,6 +2625,9 @@ static int r8152_poll(struct napi_struct *napi, int budget)
 	struct r8152 *tp = container_of(napi, struct r8152, napi);
 	int work_done;
 
+	if (!budget)
+		return 0;
+
 	work_done = rx_bottom(tp, budget);
 
 	if (work_done < budget) {
-- 
2.40.1



