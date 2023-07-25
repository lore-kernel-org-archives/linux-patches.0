Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575EA1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB075C433C8;
	Tue, 25 Jul 2023 11:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283657;
	bh=905kj+cyhD84Ow9wl57BaLq8KPCLPUVi+LswrRUxjY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlO4zbXz2AcM/imNLopMm7z5cjUA3giUfAXhJSHeSZp2XVnX7PXtKCx85RZj/W7SX
	 cLwYYG5U6LSiLrp7vw4K894tYMLC5+RYCQbNGjtX6rGrW+MiXN2LCVgz+TVK9NhHiZ
	 3iWOxNgxmu4IqQGLXAierUMqnoecB1wRPyHSBLFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/509] wifi: atmel: Fix an error handling path in atmel_probe()
Date: Tue, 25 Jul 2023 12:39:57 +0200
Message-ID: <20230725104556.343258377@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

[ Upstream commit 6b92e4351a29af52c285fe235e6e4d1a75de04b2 ]

Should atmel_config() fail, some resources need to be released as already
done in the remove function.

While at it, remove a useless and erroneous comment. The probe is
atmel_probe(), not atmel_attach().

Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1e65f174607a83348034197fa7d603bab10ba4a9.1684569156.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/atmel/atmel_cs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/atmel_cs.c b/drivers/net/wireless/atmel/atmel_cs.c
index 368eebefa741e..e64f108d288bb 100644
--- a/drivers/net/wireless/atmel/atmel_cs.c
+++ b/drivers/net/wireless/atmel/atmel_cs.c
@@ -73,6 +73,7 @@ struct local_info {
 static int atmel_probe(struct pcmcia_device *p_dev)
 {
 	struct local_info *local;
+	int ret;
 
 	dev_dbg(&p_dev->dev, "atmel_attach()\n");
 
@@ -83,8 +84,16 @@ static int atmel_probe(struct pcmcia_device *p_dev)
 
 	p_dev->priv = local;
 
-	return atmel_config(p_dev);
-} /* atmel_attach */
+	ret = atmel_config(p_dev);
+	if (ret)
+		goto err_free_priv;
+
+	return 0;
+
+err_free_priv:
+	kfree(p_dev->priv);
+	return ret;
+}
 
 static void atmel_detach(struct pcmcia_device *link)
 {
-- 
2.39.2



