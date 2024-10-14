Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647381AA790;
	Mon, 14 Oct 2024 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916047; cv=none; b=O7KWaioj0XmxG2TZBXDZRmDbtI9Jw9EvT4GGqfxonRgchwcHHUkeTQi5SvKd0eCpL54tZJTIopevLoAclwGiDLSVTIm7QzUJRMYvIMJpck6JP620pNJn7Io0+8L2x8s8DVn/UgF+uw8Yzu04kl7kcENkk5eeqQabrn6jIcsvIIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916047; c=relaxed/simple;
	bh=NV3RJ4Xn1yeMkTHCZ9JIXbMPCDJ1LmztQD4O1txEF/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFuDg0WGSosFnBVZijkw2xpztFRHHquSjiwQqjkqvAKb/FClcmqsqh0ZpzEjiq7c4OvjY+X7Fgvzcwfhht5fJT9XKv/kIIkA5WmFPBJ5T3s8hje3fTMgOCrd9FhUDNevVPo79BULysymWXwezy22hD/inOuIobdPddqGCd4htps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1C1Bldd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1C1Bldd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99291C4CEC3;
	Mon, 14 Oct 2024 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916047;
	bh=NV3RJ4Xn1yeMkTHCZ9JIXbMPCDJ1LmztQD4O1txEF/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1C1BlddPAATO/AxIzdQcEJrwuhf11YK2SSCs0jZBZEdyxTML4nkEEcuZLVVDv+Hf
	 kQIoy6+eDuGi56GdxYKdSSdy5z2t0Zn4L9EFkzh66ww66EB3i4oL/ghaiulu7lOcCT
	 1qo0Pw+143nKhnXorXI7l/Jh1IsjnpBNYs3mEKkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 071/214] driver core: bus: Return -EIO instead of 0 when show/store invalid bus attribute
Date: Mon, 14 Oct 2024 16:18:54 +0200
Message-ID: <20241014141047.759518416@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 08362ecec0ecb..6a68734e7ebd1 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -152,7 +152,8 @@ static ssize_t bus_attr_show(struct kobject *kobj, struct attribute *attr,
 {
 	struct bus_attribute *bus_attr = to_bus_attr(attr);
 	struct subsys_private *subsys_priv = to_subsys_private(kobj);
-	ssize_t ret = 0;
+	/* return -EIO for reading a bus attribute without show() */
+	ssize_t ret = -EIO;
 
 	if (bus_attr->show)
 		ret = bus_attr->show(subsys_priv->bus, buf);
@@ -164,7 +165,8 @@ static ssize_t bus_attr_store(struct kobject *kobj, struct attribute *attr,
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



