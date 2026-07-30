Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AAF446BFA;
	Thu, 30 Jul 2026 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428199; cv=none; b=H+zg/LhLRR/NPng5pPx0VRLlhe5tC0hsyYQ2CuDbQhofTXwx7DrmOVPNs8BlrqvUvAUIyoghxRboBAM53ZDL9LRodonBJ7Wn3LI20LY1K8uY2c6TX8g0y+T9173xCbfrP0RbjIXsLO22CEkTa300XlUnLPqMUuq2NsRKn6rATXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428199; c=relaxed/simple;
	bh=RX4sFzh1d7RINrobr85tyEa/u7ju7WxEHwYF+i6/I8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fwi8QzMrfps2iEdBF+YckZYOZkIpZpek0f6G1KfhSAtXbLYKmE2a0WKcomFbEC8Wsc7WaRphVGO1H4tT4uDjErp9g00DtOqfEFgtuk3sad06Mw25LW11AMtShpdM7ilYX5wojKHPxU63S9Y82Uef1oYdjpT9SGCU/NJQSjjsnnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeGak4/N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeGak4/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C960E1F00A3D;
	Thu, 30 Jul 2026 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428196;
	bh=ENAQSgbcHqsLaEJJ1NB8niNNaJicBz1h2Ugfu4P0Yvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeGak4/NCuYX3pcXif+ZCmhn1cdYSWaUTzWwdK1aivw4Fs5yLJAGkqNkd484/iDRk
	 j71HAxMVwyUluMkn7QsySJKFKgw56wS7bU77E6O2jH9H4t85UuG6VxdfIdWScUT934
	 hrS06ekdh019/468g2o/wCWluVj/3LkZxsI7i00Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 437/484] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Thu, 30 Jul 2026 16:15:34 +0200
Message-ID: <20260730141432.973956872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8b4060998637f06975fceee9b73845d8672d411e ]

This is needed because we release the service ID in tb_service_release()
and the ID array is owned by the parent XDomain.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1008,6 +1008,7 @@ static void tb_service_release(struct de
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 struct device_type tb_service_type = {
@@ -1116,7 +1117,7 @@ static void enumerate_services(struct tb
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);


