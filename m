Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE01A592
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YW1ayFFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3939AC433C7;
	Mon,  9 Oct 2023 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857658;
	bh=IjjuDzuT9+fZOzRB62sFw2nV5rDKoVUI2E+6nOuJ/OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YW1ayFFLNP8onT5z/mI2E1FTbN6g649+FxeX+SWlitfKHLTp2CxtxkGfUZYJeRhG8
	 HwaBuFNuuiwf+876RTLENVytOIPIFCazXsfybLs+QF1PvkcpExNAEXRUxX1SEKMYhF
	 AuJbghqFzLPGfbGMrIsGgpOP0UQcpPzmoXF0oioA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Cline <jeremy@jcline.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+c1d0a03d305972dbbe14@syzkaller.appspotmail.com
Subject: [PATCH 6.1 116/162] net: nfc: llcp: Add lock when modifying device list
Date: Mon,  9 Oct 2023 15:01:37 +0200
Message-ID: <20231009130126.135550161@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: Jeremy Cline <jeremy@jcline.org>

[ Upstream commit dfc7f7a988dad34c3bf4c053124fb26aa6c5f916 ]

The device list needs its associated lock held when modifying it, or the
list could become corrupted, as syzbot discovered.

Reported-and-tested-by: syzbot+c1d0a03d305972dbbe14@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c1d0a03d305972dbbe14
Signed-off-by: Jeremy Cline <jeremy@jcline.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 6709d4b7bc2e ("net: nfc: Fix use-after-free caused by nfc_llcp_find_local")
Link: https://lore.kernel.org/r/20230908235853.1319596-1-jeremy@jcline.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index f60e424e06076..6705bb895e239 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -1636,7 +1636,9 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	timer_setup(&local->sdreq_timer, nfc_llcp_sdreq_timer, 0);
 	INIT_WORK(&local->sdreq_timeout_work, nfc_llcp_sdreq_timeout_work);
 
+	spin_lock(&llcp_devices_lock);
 	list_add(&local->list, &llcp_devices);
+	spin_unlock(&llcp_devices_lock);
 
 	return 0;
 }
-- 
2.40.1



