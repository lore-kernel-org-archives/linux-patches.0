Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D14FDA7D;
	Thu, 17 Sep 2026 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667279; cv=none; b=WvOoqD8fnyl5/atbvwubma4BSbBKEcRTkdbxcvEe+9YF8LwWW5njHiM2+2njknbEs5oXsgscAanIDt5OS2mK/f2MR0o8pUCnT5NJ++aswMDRwJBM0AxZe3hHS3jhE0KPErVtlZ1GJA8zHUcJFrhmQq6wCysvAI+xpCGW4issscs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667279; c=relaxed/simple;
	bh=SKArkqHL3nCd+RgsIz+QKvJ+zjBusWCuSWSTpThc81s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvbGrkPyIauT8QaR8ePmGSvriuxDHjNEAQEhVSbspWOz8BwV8GPH8KSUJxqiWfVZNN+KeUYDgXhBtxxbKFKZRCBfjXBkhYqSaGHo50uHMAW1v/SyZOXtivZmvHkSDWO77CSmcbLRZcgZ8UM9u+conBRDkHznguegi7EDgLGsZo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiO636CM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiO636CM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2764F1F000FF;
	Thu, 17 Sep 2026 17:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667277;
	bh=0+1J58pqd90CwyUE/In8wBlsbhIXPwCLKqaC4CmEVq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SiO636CM7NwBLeWZd72/8XqHQKzecWV2p2chDEpaxb5JowE2rqq5HoyGg/kvWqZUV
	 X7xKiV/rkPGmbtkMsCc+6BCcsax9NgQOfOQVr2AQ+BbaMRGG54a/yTBNplFNqwpbBo
	 juv0cvOxSyP2nKalBGRFQweauBn7B5k7zuCMF8ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0038/1102] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Thu, 17 Sep 2026 15:59:41 +0100
Message-ID: <20260917151540.401357074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8b4060998637f06975fceee9b73845d8672d411e ]

This is needed because we release the service ID in tb_service_release()
and the ID array is owned by the parent XDomain.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/xdomain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 01444cf383d01..0532bbbb49cf8 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1025,6 +1025,7 @@ static void tb_service_release(struct device *dev)
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 const struct device_type tb_service_type = {
@@ -1133,7 +1134,7 @@ static void enumerate_services(struct tb_xdomain *xd)
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);
-- 
2.53.0



