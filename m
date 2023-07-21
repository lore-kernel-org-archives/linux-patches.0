Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0341ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D411AC433C8;
	Fri, 21 Jul 2023 18:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965627;
	bh=J9pkeaCV0UT1GIW6w3VEDVQADQrrPwu34yl4uPoHnmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAkC7CLHS3jLgjBOzqBv1k1FQYCrNsAgtyAnydnoDYxhkkyGdymCFFYPLusLHl9A/
	 aySBq32AwPtmivm1T5FHeWc/mbgqYqpwdo4alXl6z2WXuacJx9fctGEsjfOFb3j8C+
	 41TnyM5OkcDZSIIRiITLoAFP0wRGLcmmhReyReP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/532] wifi: ray_cs: Fix an error handling path in ray_probe()
Date: Fri, 21 Jul 2023 17:59:21 +0200
Message-ID: <20230721160617.734753924@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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

[ Upstream commit 4f8d66a9fb2edcd05c1e563456a55a08910bfb37 ]

Should ray_config() fail, some resources need to be released as already
done in the remove function.

While at it, remove a useless and erroneous comment. The probe is
ray_probe(), not ray_attach().

Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/8c544d18084f8b37dd108e844f7e79e85ff708ff.1684570373.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ray_cs.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 81e0945fa443d..96330a6c066be 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -270,13 +270,14 @@ static int ray_probe(struct pcmcia_device *p_dev)
 {
 	ray_dev_t *local;
 	struct net_device *dev;
+	int ret;
 
 	dev_dbg(&p_dev->dev, "ray_attach()\n");
 
 	/* Allocate space for private device-specific data */
 	dev = alloc_etherdev(sizeof(ray_dev_t));
 	if (!dev)
-		goto fail_alloc_dev;
+		return -ENOMEM;
 
 	local = netdev_priv(dev);
 	local->finder = p_dev;
@@ -313,11 +314,16 @@ static int ray_probe(struct pcmcia_device *p_dev)
 	timer_setup(&local->timer, NULL, 0);
 
 	this_device = p_dev;
-	return ray_config(p_dev);
+	ret = ray_config(p_dev);
+	if (ret)
+		goto err_free_dev;
+
+	return 0;
 
-fail_alloc_dev:
-	return -ENOMEM;
-} /* ray_attach */
+err_free_dev:
+	free_netdev(dev);
+	return ret;
+}
 
 static void ray_detach(struct pcmcia_device *link)
 {
-- 
2.39.2



