Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853FFBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D820EC433D2;
	Tue,  7 Mar 2023 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213325;
	bh=kxyWRbwOrMsaR1MkwOzO/TcOcPQYENZ5YzewcG8QVLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQIb/S1QO5+BcTdNw4E4VM3qaZIEjvjuWL6ciFdDKtfFHEZTNQHmGDFhUeQSxyxke
	 7suIWB7rtZ15CQyYdOqrxYtxV6w7hvm1m+J5/2gG3EjUGF5P7Ye5foFill+/SwTW8D
	 Qr37uW2kRaNPXbIlGaXHWBBz/YwLSJY9wTcOsEJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 441/885] misc: fastrpc: Fix an error handling path in fastrpc_rpmsg_probe()
Date: Tue,  7 Mar 2023 17:56:15 +0100
Message-Id: <20230307170021.578901099@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 11819ed2b70da94acc41fec34178a011c4d3d25d ]

If of_platform_populate() fails, some resources need to be freed as already
done in the other error handling paths.

Fixes: 278d56f970ae ("misc: fastrpc: Reference count channel context")
Fixes: 3abe3ab3cdab ("misc: fastrpc: add secure domain support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/b909d2f3273b794ea0f1f78d14bc24affb08ea5f.1669398274.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 80811e852d8fd..02d26160c64e6 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2127,7 +2127,18 @@ static int fastrpc_rpmsg_probe(struct rpmsg_device *rpdev)
 	data->domain_id = domain_id;
 	data->rpdev = rpdev;
 
-	return of_platform_populate(rdev->of_node, NULL, NULL, rdev);
+	err = of_platform_populate(rdev->of_node, NULL, NULL, rdev);
+	if (err)
+		goto populate_error;
+
+	return 0;
+
+populate_error:
+	if (data->fdevice)
+		misc_deregister(&data->fdevice->miscdev);
+	if (data->secure_fdevice)
+		misc_deregister(&data->secure_fdevice->miscdev);
+
 fdev_error:
 	kfree(data);
 	return err;
-- 
2.39.2



