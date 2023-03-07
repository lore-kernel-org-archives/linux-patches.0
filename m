Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54751BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB2FC433D2;
	Tue,  7 Mar 2023 18:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215561;
	bh=LFemGSKCbuEZ/jtF309PKpIx6NTq5rVCygcMlALJsps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ba3sl0JTCd+3Zi4MHMxpaaVodjzgjbbj3aVVWBkowRbybx224/XHIEUJbApa9Dm+u
	 vFar6sMOyoLMdQxW9JUlcD0Q1fM5ezfFY7WQMBiYAlcGyNUEgpy//z0kXBR5ympPS6
	 ZTiNVBwWXfhDJ688CHyZmkitAh4fgL1eoHehAr+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/567] Revert "char: pcmcia: cm4000_cs: Replace mdelay with usleep_range in set_protocol"
Date: Tue,  7 Mar 2023 18:00:38 +0100
Message-Id: <20230307165918.942606992@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 70fae37a09268455b8ab4f64647086b61da6f39c ]

This reverts commit be826ada52f1fcabed5b5217c94609ebf5967211.

The function monitor_card() is a timer handler that runs in an
atomic context, but it calls usleep_range() that can sleep.
As a result, the sleep-in-atomic-context bugs will happen.
The process is shown below:

    (atomic context)
monitor_card()
  set_protocol()
    usleep_range() //sleep

The origin commit c1986ee9bea3 ("[PATCH] New Omnikey Cardman
4000 driver") works fine.

Fixes: be826ada52f1 ("char: pcmcia: cm4000_cs: Replace mdelay with usleep_range in set_protocol")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20230118141000.5580-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/pcmcia/cm4000_cs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 8f1bce0b4fe50..7057b7bacc8cf 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -530,7 +530,8 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 			DEBUGP(5, dev, "NumRecBytes is valid\n");
 			break;
 		}
-		usleep_range(10000, 11000);
+		/* can not sleep as this is in atomic context */
+		mdelay(10);
 	}
 	if (i == 100) {
 		DEBUGP(5, dev, "Timeout waiting for NumRecBytes getting "
@@ -550,7 +551,8 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 			}
 			break;
 		}
-		usleep_range(10000, 11000);
+		/* can not sleep as this is in atomic context */
+		mdelay(10);
 	}
 
 	/* check whether it is a short PTS reply? */
-- 
2.39.2



