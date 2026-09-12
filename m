Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE434BEE43;
	Sat, 12 Sep 2026 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238913; cv=none; b=fdCf6fKWOCgwE8GGoLFhhTQN/jmpuwgrO6YUnNHKy/d6vD7prbBouu8S2JXW9S+LLra+mSy/ct0hbsJ0u0u8SoMZ5ZvqeUHrH4WZhWnX/T2Pkjwk+2fS7nE7+ISip7eQOnPr4LoA2LDcUAGYlGERyaEFwtclQwG7ZSLgYXRuI3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238913; c=relaxed/simple;
	bh=EOROttHv9CnN8SleEbTDi6vSeBBq+EbTzPhVczkNdJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6YIH+gwTjztItJYUI/EbZ2MEqE3m8ETCSbWntZeetv3FcsSh7JUWv2PzVUtXw7XT/CSW7GaKawSUtmYdPG13L1zzzR24tNChbZ4WATZvhWGii0vVOyf6h+syvEpnjK5E4nAG9nITp5dAqSWwvicc9oDLGUlaeEU9dW8ohDPO+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deOeKi9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deOeKi9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA821F000FF;
	Sat, 12 Sep 2026 18:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238912;
	bh=7k9kh1gtqj5ADmIUy/pjxAzrF88UAhwmugID01o6UEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=deOeKi9Aaeo8+bLpf0CyhIo6gnMNW5BCoKMBjVxuxur2C+IQVGmiVvb21hRnnmCg9
	 driE/km6hIlYvIsPBrMklzTWh44X9tX0Ah6NUm9r/ytI3Akmnh5Zn7XYWufbayGvBK
	 +ocvW3eT5NKzV5f4QczdTP6mkFSC++pa0X+CiWxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 558/935] driver core: soc: remove layering violation for the soc_bus
Date: Sat, 12 Sep 2026 08:59:48 +0200
Message-ID: <20260912065539.630160497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0af5363a582c3..ea57b8ddb1510 100644
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



