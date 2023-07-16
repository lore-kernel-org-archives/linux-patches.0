Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0D68F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE45BC433C8;
	Sun, 16 Jul 2023 20:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540686;
	bh=EJz73ZbXKgKBDytimUerB75VxU9y57I2UoRp3f3MSVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rLIzB/omNVijM+7dJHLSgGMue7kdqrFHw9e/8KleuHL4EDnUOOBJu44hSFkieLLD
	 otErkdGdD+U6As8fjEY1XDIW83qkjquFriA0SyjxRNlZUtUBa9neCezntZVtrcLXsC
	 wUnQ0k8uWmKWI44Dd2RmG/x5ICimJsq3KwG7geto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 451/591] misc: fastrpc: check return value of devm_kasprintf()
Date: Sun, 16 Jul 2023 21:49:50 +0200
Message-ID: <20230716194935.577313563@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit af2e19d82a116bc622eea84c9faadd5f7e20bec4 ]

devm_kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: 3abe3ab3cdab ("misc: fastrpc: add secure domain support")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230615102546.581899-1-claudiu.beznea@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 8b1e8661c3d73..e5cabb9012135 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2030,6 +2030,9 @@ static int fastrpc_device_register(struct device *dev, struct fastrpc_channel_ct
 	fdev->miscdev.fops = &fastrpc_fops;
 	fdev->miscdev.name = devm_kasprintf(dev, GFP_KERNEL, "fastrpc-%s%s",
 					    domain, is_secured ? "-secure" : "");
+	if (!fdev->miscdev.name)
+		return -ENOMEM;
+
 	err = misc_register(&fdev->miscdev);
 	if (!err) {
 		if (is_secured)
-- 
2.39.2



