Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D8615C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B81C433D6;
	Mon,  5 Dec 2022 19:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267843;
	bh=sTrhUg/jjmnp9IXgZiphojMaqmaWo/rJG10o05pRJws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4MaujYLAcw3AUgNVE9SxDVWiJI3MEkZyPUK6s4lAVhGXaef6PeAtUT/SHHltPWom
	 vM/V/kD/tR8Mxo+pO+BX+WbCre3lKgx3nEXITqME6xUfN3xFYyWsexfElXdrG9y3Vx
	 d9XIHMxUoUoRJDpbagh8Otyi7Uk2sTICgoICTJZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Frank Rowand <frowand.list@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 44/77] of: property: decrement node refcount in of_fwnode_get_reference_args()
Date: Mon,  5 Dec 2022 20:09:35 +0100
Message-Id: <20221205190802.446591451@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 60d865bd5a9b15a3961eb1c08bd4155682a3c81e ]

In of_fwnode_get_reference_args(), the refcount of of_args.np has
been incremented in the case of successful return from
of_parse_phandle_with_args() or of_parse_phandle_with_fixed_args().

Decrement the refcount if of_args is not returned to the caller of
of_fwnode_get_reference_args().

Fixes: 3e3119d3088f ("device property: Introduce fwnode_property_get_reference_args")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Frank Rowand <frowand.list@gmail.com>
Link: https://lore.kernel.org/r/20221121023209.3909759-1-yangyingliang@huawei.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index fd9b734fff33..c017b11b00cb 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -922,8 +922,10 @@ of_fwnode_get_reference_args(const struct fwnode_handle *fwnode,
 						       nargs, index, &of_args);
 	if (ret < 0)
 		return ret;
-	if (!args)
+	if (!args) {
+		of_node_put(of_args.np);
 		return 0;
+	}
 
 	args->nargs = of_args.args_count;
 	args->fwnode = of_fwnode_handle(of_args.np);
-- 
2.35.1



