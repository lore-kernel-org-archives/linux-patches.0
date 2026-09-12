Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C32928E0;
	Sat, 12 Sep 2026 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229786; cv=none; b=Q5fBP0HpONo5EbeU+GOcpQMRBxUpgFDWH19npx59JxebsAvJsZWmquYR3xQBZKZ6dhSHpGU2T0354B9pmIPdaBJJA+6E4VGestd+VY4bwCDjySZjOEaJ1CSE24Aq3YO9Thenh4HXiCjDk6k+hRKe+HDO7Z9DbeCxnFiCXRf6P5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229786; c=relaxed/simple;
	bh=bb6QdGc8k+GqvhrTpPaVDhdpLx/H8dHVXeQkjisjg3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6BJsxK0lVOArBeA5zmryw6OQdXCEH1+EpsQpW9RBm59/PA5EhrvCRK7AP2H8muk2+d1GrdWM+wF/75bW/qobQa5jvtgOIDUJGcdbDhXc6Cc1kyKnLX/BOtjn1Cfi34uHIUVqEg67jh9NM3UilAOVw/rBDWRI7DH2W4aL/aBw80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rvXDo2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rvXDo2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744431F000FF;
	Sat, 12 Sep 2026 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229783;
	bh=SqKv4YNogM5KqfMX3m23yARfaJ/hVAsjtWuYMCn7cS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2rvXDo2JhWsWwRjXiClD/75rgvCplGkgbZZI5pSGUlAZJTIGLkChuZWPu0HGhIs4h
	 QLmL+TVOXjb527rBTeBEfJFqvqCMtxqRw5xP+D0ksZyB+u1OHbOuk2qxrp20pWkHmC
	 FxwmMVe4RgpS4N8U0F5uz6OWQF8VrxqnqPyPAoXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0661/1191] driver core: soc: remove layering violation for the soc_bus
Date: Sat, 12 Sep 2026 08:56:29 +0200
Message-ID: <20260912065603.103731056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 90be1f15c39858a4f0f4346c39fa150697d231c1 ]

The soc_bus code pokes around in the internal bus structures assuming
that it "knows" if a field is not set that it has not been registered
yet.  That isn't a safe assumption, so just remove the layering
violation entirely and keep track if the bus has been registered or not
ourselves.

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20230130171059.1784057-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 45dfa004893d ("driver core: soc: Unregister bus on early device registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/soc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/soc.c b/drivers/base/soc.c
index 22130b5f789d9..0fb1d4ab9d8a6 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -30,6 +30,7 @@ struct soc_device {
 static struct bus_type soc_bus_type = {
 	.name  = "soc",
 };
+static bool soc_bus_registered;
 
 static DEVICE_ATTR(machine,		0444, soc_info_show,  NULL);
 static DEVICE_ATTR(family,		0444, soc_info_show,  NULL);
@@ -117,7 +118,7 @@ struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr
 	const struct attribute_group **soc_attr_groups;
 	int ret;
 
-	if (!soc_bus_type.p) {
+	if (!soc_bus_registered) {
 		if (early_soc_dev_attr)
 			return ERR_PTR(-EBUSY);
 		early_soc_dev_attr = soc_dev_attr;
@@ -183,6 +184,7 @@ static int __init soc_bus_register(void)
 	ret = bus_register(&soc_bus_type);
 	if (ret)
 		return ret;
+	soc_bus_registered = true;
 
 	if (early_soc_dev_attr)
 		return PTR_ERR(soc_device_register(early_soc_dev_attr));
-- 
2.53.0



