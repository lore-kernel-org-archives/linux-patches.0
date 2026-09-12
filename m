Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B221FBEA6;
	Sat, 12 Sep 2026 19:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242761; cv=none; b=pXFBPK/Gixq8QxhpIt2kzVG8hCuOz3XOQ3+3Fbsqh2cxodRdmMceCUKEXUr7s/R8EC/qrk+42TVsXgoE84uUTTO/BZ0Bhs5L+p2Xf8dX8zWnFnTVyuR3bVgYZi7nfTz2WCySg8LiDCk1qDwI/AucymQmxz6eOtLiZ1UjJftX50I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242761; c=relaxed/simple;
	bh=0WTlDKAELz9O7rxmCf1FlTNBCvsz131HyUjEhNJKgqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fp/ADtIQlwzbmgUaSbXZCpojwx/7RsD1e5foeGhp7J6IP+oMXxrKLSxMfTpeAa3RlfMMA0VMP7IpuU5JV5UcjpkDkLvO1NP6oyG85vCkHLRfvaDtsTooDDLM5lK1dAaihurUpAjVoYLMfu6aUcNuOE9W+TbhlquYWEI6UgKPn1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp83EWGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp83EWGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5398F1F000FF;
	Sat, 12 Sep 2026 19:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242759;
	bh=P9vXGEmlNCGf3MejJevVF6ycfnLhrDN2TLRNrqtp0y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vp83EWGwq5unz7BYfB5n3XkYYMzuU0mysWh7PUV09T7GCcFkskqKI4NdebibuYtML
	 VtkfNThMxpBS7uHZ7695cMJb1rNssMS79ByskgmiKKjnwMRf5WdXrBjIPDLRuGhiBq
	 SsiDmzRT4J3XigOKx3AaJW4asYLF6nWFlGfXvZdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 474/798] driver core: soc: remove layering violation for the soc_bus
Date: Sat, 12 Sep 2026 09:01:42 +0200
Message-ID: <20260912065528.008119743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d34609bb73866..50b760f1e2a3f 100644
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



