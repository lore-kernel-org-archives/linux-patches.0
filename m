Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7266D28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEF9C433EF;
	Mon, 30 Jan 2023 14:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087676;
	bh=qAigYmVnhWrA1SAgZkR6sg3n71WGOUPRl3FJMONYG5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ft46r9hYZ9qY/5serF5Gh4b3dPAZle9kbm+s/OGLcq7L6PSfZbfG8N174cL+jIaOI
	 qDfBI8It3PLZO+FWRWD0aJ1PE46Q7GSPZmKc+SC7vdg5IBMJoQnFMxwIePA6OhU86I
	 FaxDN57t+C9tScOyNAivRtFySnVPLn42svibWw4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 287/313] net: ravb: Fix lack of register setting after system resumed for Gen3
Date: Mon, 30 Jan 2023 14:52:02 +0100
Message-Id: <20230130134350.095128927@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit c2b6cdee1d13ffbb24baca3c9b8a572d6b541e4e ]

After system entered Suspend to RAM, registers setting of this
hardware is reset because the SoC will be turned off. On R-Car Gen3
(info->ccc_gac), ravb_ptp_init() is called in ravb_probe() only. So,
after system resumed, it lacks of the initial settings for ptp. So,
add ravb_ptp_{init,stop}() into ravb_{resume,suspend}().

Fixes: f5d7837f96e5 ("ravb: ptp: Add CONFIG mode support")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b4e0fc7f65bd..3f61100c02f4 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2973,6 +2973,9 @@ static int __maybe_unused ravb_suspend(struct device *dev)
 	else
 		ret = ravb_close(ndev);
 
+	if (priv->info->ccc_gac)
+		ravb_ptp_stop(ndev);
+
 	return ret;
 }
 
@@ -3011,6 +3014,9 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	/* Restore descriptor base address table */
 	ravb_write(ndev, priv->desc_bat_dma, DBAT);
 
+	if (priv->info->ccc_gac)
+		ravb_ptp_init(ndev, priv->pdev);
+
 	if (netif_running(ndev)) {
 		if (priv->wol_enabled) {
 			ret = ravb_wol_restore(ndev);
-- 
2.39.0



