Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DF58F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F39C433B7;
	Sun, 16 Jul 2023 19:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537543;
	bh=795XjNeKTIUuV2hjpNON2NWXeeZ7ellz9oGaPgUy2ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/ZmTo6ZRC3FnpAVYnXFynTezI0Zz4n6TuZVNG4N0coCAGtqGygAF9tqP/CBoJ/Sr
	 28TNSIzTvw/e1EjIbO+lbQYGJW+UGVCiaY6tIXLbw7kO5xeQOB38K8yixWCk5/mj/I
	 AMRTgjFAAc8Gl1o/JE1TIqMlnk4UoOOHnYRih2IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 133/800] wifi: orinoco: Fix an error handling path in orinoco_cs_probe()
Date: Sun, 16 Jul 2023 21:39:46 +0200
Message-ID: <20230716194952.190445658@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 67a81d911c01225f426cc6bee2373df044c1a9b7 ]

Should orinoco_cs_config() fail, some resources need to be released as
already done in the remove function.

While at it, remove a useless and erroneous comment. The probe is
orinoco_cs_probe(), not orinoco_cs_attach().

Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/e24735ce4d82901d5f7ea08419eea53bfdde3d65.1684568286.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intersil/orinoco/orinoco_cs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_cs.c b/drivers/net/wireless/intersil/orinoco/orinoco_cs.c
index a956f965a1e5e..03bfd2482656c 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_cs.c
@@ -96,6 +96,7 @@ orinoco_cs_probe(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv;
 	struct orinoco_pccard *card;
+	int ret;
 
 	priv = alloc_orinocodev(sizeof(*card), &link->dev,
 				orinoco_cs_hard_reset, NULL);
@@ -107,8 +108,16 @@ orinoco_cs_probe(struct pcmcia_device *link)
 	card->p_dev = link;
 	link->priv = priv;
 
-	return orinoco_cs_config(link);
-}				/* orinoco_cs_attach */
+	ret = orinoco_cs_config(link);
+	if (ret)
+		goto err_free_orinocodev;
+
+	return 0;
+
+err_free_orinocodev:
+	free_orinocodev(priv);
+	return ret;
+}
 
 static void orinoco_cs_detach(struct pcmcia_device *link)
 {
-- 
2.39.2



