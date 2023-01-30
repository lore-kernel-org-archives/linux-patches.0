Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3409E3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB298C433D2;
	Mon, 30 Jan 2023 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088469;
	bh=WhGFyZdoup3sRzO58cjQqNssyyojMyHlYLG9ARTJIp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUz80VifdP7kZkhBPcoF6a8J5qw87qb6hBKKvfS6Gx64BpD7HJkBTyU7UvwOzV7zm
	 B2+VNCsWDuAuTvfgOuv6hSSsseP67N9SGiM6ABlMSY3pPRdToMj2rvvGAsz+mwZ8cp
	 qU76dhXwP20gUSNCj+uEvBu44b33W6NG+48cN1d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esina Ekaterina <eesina@astralinux.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/143] net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs
Date: Mon, 30 Jan 2023 14:51:27 +0100
Message-Id: <20230130134308.091921917@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Esina Ekaterina <eesina@astralinux.ru>

[ Upstream commit 488e0bf7f34af3d42d1d5e56f7a5a7beaff188a3 ]

If uhdlc_priv_tsa != 1 then utdm is not initialized.
And if ret != NULL then goto undo_uhdlc_init, where
utdm is dereferenced. Same if dev == NULL.

Found by Astra Linux on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 8d68100ab4ad ("soc/fsl/qe: fix err handling of ucc_of_parse_tdm")
Signed-off-by: Esina Ekaterina <eesina@astralinux.ru>
Link: https://lore.kernel.org/r/20230112074703.13558-1-eesina@astralinux.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 7eac6a3e1cde..ae1ae65e7f90 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1245,9 +1245,11 @@ static int ucc_hdlc_probe(struct platform_device *pdev)
 free_dev:
 	free_netdev(dev);
 undo_uhdlc_init:
-	iounmap(utdm->siram);
+	if (utdm)
+		iounmap(utdm->siram);
 unmap_si_regs:
-	iounmap(utdm->si_regs);
+	if (utdm)
+		iounmap(utdm->si_regs);
 free_utdm:
 	if (uhdlc_priv->tsa)
 		kfree(utdm);
-- 
2.39.0



