Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948DB17A2EA;
	Tue, 26 Aug 2025 13:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213219; cv=none; b=ZREHGPYP0ZU9nlZudk+mcF4coTAYVRfaiKy9BnzrppYN6xMyF7OcG+u/EzqHONZlp19G6Z8pT622ZgA4DWIrHwXFdWWXWTu0x0QTntJ5jYFOm/oOYDwcgJH4Nc12ptgMD48lEzof+L4Nu4Csp9iq/e+XjcmY1OJxwOD0YnUhXlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213219; c=relaxed/simple;
	bh=T4vK6KtyoEJAilOkBeOO9G3h2eUWFxRRJQOvBt0Jpxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khHAQaVII1cbdXEy5hbodeMFWO7gV7NNuoHNScNCMaQxfzWs/R4+UDjA/9+S++LToijID4BwN0og/zCb/Ecw5U4zWZpIloMlMOx0rJI8K/CUGnDs9VIpgvQd1KOfh+OZ5atlMMHKe5rPFkCWnSW1eYiPzKCUkKPm3yfvxWxfM7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU2kCq5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU2kCq5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28941C4CEF1;
	Tue, 26 Aug 2025 13:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213219;
	bh=T4vK6KtyoEJAilOkBeOO9G3h2eUWFxRRJQOvBt0Jpxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uU2kCq5dyfIEhNXJ95eF4X4f3jhl+LxE0g+YOM826UIz0W21h+tABMnA70PZiF50y
	 DXaFyCZdnilfHJowYJHZh2iRsatCoVGKx9Chxc5NiDtNf2nIYcrrDELS+C3OSPM4Qg
	 d80b6iOwiay0RiXgcBGRwh/v6DtlFFsxVInhzEMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/587] i3c: dont fail if GETHDRCAP is unsupported
Date: Tue, 26 Aug 2025 13:06:55 +0200
Message-ID: <20250826110959.694818971@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 447270cdb41b1c8c3621bb14b93a6749f942556e ]

'I3C_BCR_HDR_CAP' is still spec v1.0 and has been renamed to 'advanced
capabilities' in v1.1 onwards. The ST pressure sensor LPS22DF does not
have HDR, but has the 'advanced cap' bit set. The core still wants to
get additional information using the CCC 'GETHDRCAP' (or GETCAPS in v1.1
onwards). Not all controllers support this CCC and will notify the upper
layers about it. For instantiating the device, we can ignore this
unsupported CCC as standard communication will work. Without this patch,
the device will not be instantiated at all.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250704204524.6124-1-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 33254bc338b9..7e526da11524 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1398,7 +1398,7 @@ static int i3c_master_retrieve_dev_info(struct i3c_dev_desc *dev)
 
 	if (dev->info.bcr & I3C_BCR_HDR_CAP) {
 		ret = i3c_master_gethdrcap_locked(master, &dev->info);
-		if (ret)
+		if (ret && ret != -ENOTSUPP)
 			return ret;
 	}
 
-- 
2.39.5



