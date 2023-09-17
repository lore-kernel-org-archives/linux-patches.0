Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231E77469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4D7C433C7;
	Sun, 17 Sep 2023 19:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979057;
	bh=EKZjRaC8JK6Jat9H8DI33O5PIe+C9yDoSyIoFPEbikM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqBaWSpEfYZ4Gphf7WNBRk47mDmzZi9TJ/oQl8jID936JGLfY6Tx/2100utERnbeY
	 V8AA6Y/s3HXApItE6VhMtXBX5MW+oR5cDsPX8MTMvZ5Iw7tUaggZMXbVf47BtozfmT
	 vdEDLaB/nsXD7hfxvtfzdDR9vJpX3xclJLdi7fEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/406] media: i2c: tvp5150: check return value of devm_kasprintf()
Date: Sun, 17 Sep 2023 21:10:56 +0200
Message-ID: <20230917191106.525219315@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 26ce7054d804be73935b9268d6e0ecf2fbbc8aef ]

devm_kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: 0556f1d580d4 ("media: tvp5150: add input source selection of_graph support")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tvp5150.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 3b3221fd3fe8f..cf0570a6760ca 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -2078,6 +2078,10 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 		tvpc->ent.name = devm_kasprintf(dev, GFP_KERNEL, "%s %s",
 						v4l2c->name, v4l2c->label ?
 						v4l2c->label : "");
+		if (!tvpc->ent.name) {
+			ret = -ENOMEM;
+			goto err_free;
+		}
 	}
 
 	ep_np = of_graph_get_endpoint_by_regs(np, TVP5150_PAD_VID_OUT, 0);
-- 
2.40.1



