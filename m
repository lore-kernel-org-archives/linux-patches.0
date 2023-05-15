Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C871D507
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8ADFC433D2;
	Mon, 15 May 2023 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173500;
	bh=9Ew0Z4GvGT1idRXRSUmaiQGiEpcbYCEd36ai2ZMxikA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUwYydARiusTUrxhJKIWn6PaBg0+y6TAAAMjuhLMDBGohEsqkLxkfE8D/UyiUazj5
	 4dNlWJdAs4U9HCe1XMb6f7K9p55uke8maWfyj/pjzw3uov1otsJ17r0aso6WMnG0Zt
	 1nUW136yAq8freaodjvXHAHm1d91548rrPDSW/xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gan Gecen <gangecen@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/282] net: amd: Fix link leak when verifying config failed
Date: Mon, 15 May 2023 18:28:13 +0200
Message-Id: <20230515161725.689549880@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gencen Gan <gangecen@hust.edu.cn>

[ Upstream commit d325c34d9e7e38d371c0a299d415e9b07f66a1fb ]

After failing to verify configuration, it returns directly without
releasing link, which may cause memory leak.

Paolo Abeni thinks that the whole code of this driver is quite
"suboptimal" and looks unmainatained since at least ~15y, so he
suggests that we could simply remove the whole driver, please
take it into consideration.

Simon Horman suggests that the fix label should be set to
"Linux-2.6.12-rc2" considering that the problem has existed
since the driver was introduced and the commit above doesn't
seem to exist in net/net-next.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Gan Gecen <gangecen@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/nmclan_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 9c152d85840d7..c9d2a6f150624 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -652,7 +652,7 @@ static int nmclan_config(struct pcmcia_device *link)
     } else {
       pr_notice("mace id not found: %x %x should be 0x40 0x?9\n",
 		sig[0], sig[1]);
-      return -ENODEV;
+      goto failed;
     }
   }
 
-- 
2.39.2



