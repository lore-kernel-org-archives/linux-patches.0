Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014881E0DBD;
	Wed,  6 Nov 2024 13:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898678; cv=none; b=i8H5JajJ4eNREwde1RnJ7/C1E9AEDv03PzQ1CVJwRZX4A13PO94orwP6YxL1eRjShpWYdXJAvNFr6IWXj3sYJ1PtEFr/xw9LmE7kz60nnJtY5iqGzbayBTOYWKceKWtw9t38IaPe9G8Z32hBjiLrkmd9cMqbd+54+sc8KCt0DME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898678; c=relaxed/simple;
	bh=BUsowi3QMYCEZnladAyy0SGKKQXif84Um55CnQ3z3WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdfcWGm72fKMtt8SYs/wt/Yq1vuV9tqNQS0N25sWrWRbDwiX7ntRTX3/jxNsLprDGytVCsKknAb6ez3LXjrVi1NiODBXxnSOdaUs+PDEOSOxQUmSSwwKj6/YN4ZrfDzmH7lf9nt1D4EOcqJe8HVIJm2PSSDmTdJ8sTtAZUtnlmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tERqiwCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tERqiwCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD40C4CECD;
	Wed,  6 Nov 2024 13:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898677;
	bh=BUsowi3QMYCEZnladAyy0SGKKQXif84Um55CnQ3z3WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tERqiwCWAAQWtFwhy0vOJb+4ixxDUAavNeSEUcj2ZNlbb8qE2rl498hxWxunom1oP
	 BkIIBWmKCwG32gfpv62dFnxOTZbCBGJYTiX3fq7xxbr9mADeFma2nJjJmkpLJymHSb
	 3SxRqOG/H3nCfY4BwD/7fZGbG1NX2ptcw+TYxzRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 319/462] driver core: bus: Return -EIO instead of 0 when show/store invalid bus attribute
Date: Wed,  6 Nov 2024 13:03:32 +0100
Message-ID: <20241106120339.405139958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit c0fd973c108cdc22a384854bc4b3e288a9717bb2 ]

Return -EIO instead of 0 for below erroneous bus attribute operations:
 - read a bus attribute without show().
 - write a bus attribute without store().

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240724-bus_fix-v2-1-5adbafc698fb@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 7d7d28f498edd..f970a40a2f7ad 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -103,7 +103,8 @@ static ssize_t bus_attr_show(struct kobject *kobj, struct attribute *attr,
 {
 	struct bus_attribute *bus_attr = to_bus_attr(attr);
 	struct subsys_private *subsys_priv = to_subsys_private(kobj);
-	ssize_t ret = 0;
+	/* return -EIO for reading a bus attribute without show() */
+	ssize_t ret = -EIO;
 
 	if (bus_attr->show)
 		ret = bus_attr->show(subsys_priv->bus, buf);
@@ -115,7 +116,8 @@ static ssize_t bus_attr_store(struct kobject *kobj, struct attribute *attr,
 {
 	struct bus_attribute *bus_attr = to_bus_attr(attr);
 	struct subsys_private *subsys_priv = to_subsys_private(kobj);
-	ssize_t ret = 0;
+	/* return -EIO for writing a bus attribute without store() */
+	ssize_t ret = -EIO;
 
 	if (bus_attr->store)
 		ret = bus_attr->store(subsys_priv->bus, buf, count);
-- 
2.43.0



