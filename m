Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27D34F393C;
	Thu, 17 Sep 2026 16:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661028; cv=none; b=JYGMzN8atVdpEF3Ljy/DekERfBhzjOQvATZ3BQhast4mIR4+8HFBUdBrExNxfCEfbxkLMqhgOd0CdCH5BXiNT3vrbxMCfhS5MDWAFMrMmdSZG5GnHwfpzl8FdPKSQhImKTXTPUJcFr59u8UG8p5KW9FjphaDA+eBrVW7J2/7s0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661028; c=relaxed/simple;
	bh=3f0iR7+RU8LtsSNk3wFVmsFMXXW5gjnB0CAzxzkqQds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noz2fErLw/2qGofdK+Xz65Ab1OD8W8d5vV9jleL1n9HzeT0GXO0EmzVoAXj7z4zOitHUu15nF/RTD//51iE2LRfsR2RhtZoMJ89csR/wPB5f0jojfCxmmbloaQzARmZAllR0bnZnNSHHgv9EaySG0YhBp5S7pzXJ+WsiuIadaAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YL2rHkg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YL2rHkg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF741F00898;
	Thu, 17 Sep 2026 16:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661027;
	bh=N8Cz3j+4Cv/xiQmEuLcnSlRkU5YJ0CjBLqdPzHG8dHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YL2rHkg85Vb5aKOXfda8rGWpqDuOces8J0gxPbPdsS1RJn6yt5uE/Yp0cpSwFdT5y
	 hGTF5Cziz+txfeRJ5M0++NoWGA2ueRLWtJdNow7rmDo7W9tV2mDZ7u3S+GJ3yx9xht
	 M7EQUu+qC9C0dPqFVVv9YOkzXC/B/uVvKzX+jR38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0058/1250] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Thu, 17 Sep 2026 15:57:33 +0100
Message-ID: <20260917151553.513997141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5fbdd412a712f..fed0fae2a6299 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1029,6 +1029,7 @@ static void tb_service_release(struct device *dev)
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 const struct device_type tb_service_type = {
@@ -1137,7 +1138,7 @@ static void enumerate_services(struct tb_xdomain *xd)
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);
-- 
2.53.0



