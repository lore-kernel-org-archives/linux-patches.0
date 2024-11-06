Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC421DF73E;
	Wed,  6 Nov 2024 12:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895659; cv=none; b=sbDN8yeJKiypJBx+8cLLhQmBVK3bFAu1BTyApBl3kfeczy/bDqXhrY2dsBIJhWxW/3HE/i/RHbVwMeu0pcOSXsQ7B1058tMhUKiRvtVpvR4tt41H7ECbhLLtNHfUzOXMxknBcIxraxPyQeNY1ZhBKW3ww6efOj7Bdk9Rw0qkxqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895659; c=relaxed/simple;
	bh=ciUnMmhgVbettT7JxVk8Y3WMcgHBaUGJwrprMT85Ddk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbU6UzfT3gOblMv3HKgJA1uQ3oibqQmhFtaa464M6q5j7LOSBKcIHmqOSCatxmt+dJQnO6OZ4s2I4x+ZHpFEYm7tgmcgC/fy5Tp4/IHm6RhTCffQDjC+MHDFKzVTbJ/tQvp9V0puN5UmEMnx6WyDiGo4wngOzJm32m5fdRS/uO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oiz8ZPZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oiz8ZPZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FBCC4CECD;
	Wed,  6 Nov 2024 12:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895659;
	bh=ciUnMmhgVbettT7JxVk8Y3WMcgHBaUGJwrprMT85Ddk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oiz8ZPZZqDjeJ34gJhLVeRPo0F4jkEbuSLBlwmqHeBqmlw1GaSd4aaK3nyCTvRScX
	 jkVwA5H0tOBOhc/FzhALu5lsKsfuNiFpA+KuP1Adl4eQfctSkM9FF/9SLIo4zN8M1/
	 sImirJvnfOeC9sbyPpX+TdNBHGBXMevAe6netNlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 246/350] driver core: bus: Return -EIO instead of 0 when show/store invalid bus attribute
Date: Wed,  6 Nov 2024 13:02:54 +0100
Message-ID: <20241106120327.008778917@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e06a57936cc96..aad13af4175b8 100644
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



