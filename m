Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423FE23D2B2;
	Mon, 29 Dec 2025 16:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025520; cv=none; b=AUmqPGeP0JWB97Z3gqky6Ye+K9v7gx13/Ve3F03EfQzQjKc8kJ+a+FAc5/Ls9MD4yePqDixbQgXtPWEId6CLcQzsguatoYvsPEp6oS3LloEXz0mAt3VCElDHGP3qGA2pcPwLz+YmlABHKnVFeAsNBKhejhMEFSun4Dmblz5BFOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025520; c=relaxed/simple;
	bh=agM2di2YcbUeb8gsuTnOcpn1PXabZPdXsNQrqAKYVyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHYY3t8Ygw9VFsvPtifrPVjtJXbzauqdGxtlQwjHIKv+M+71GJRCdDOGwVKArPL1Si1M2AJ+JjPrEgmZUrp700L/NRhORIWn3cGNaazcs+EiaMa9+kFsAsmb85XsH0CBlvEKkOYEb/l4ZoU3mudL1BkjZ8AKkBolQX+dwa7orHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnFjLgKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnFjLgKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30BFC4CEF7;
	Mon, 29 Dec 2025 16:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025520;
	bh=agM2di2YcbUeb8gsuTnOcpn1PXabZPdXsNQrqAKYVyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnFjLgKjJtIB5KTFsttEiVCmTFD9RLThGp0Di96r5ND0IXJjzh3lMtD0YDOqbElHa
	 V4ezEPxS7GgEnArYjzL5fUDdCMKLwvbuG2TJg0tZx3xZRax3tMgo0nq7nUF2bhZvwm
	 YE904PAMKDbraiZLi8l+kppuxAahUCWyl/SQdIA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/430] hwmon: (emc2305) fix double put in emc2305_probe_childs_from_dt
Date: Mon, 29 Dec 2025 17:10:12 +0100
Message-ID: <20251229160732.081708146@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 541dfb49dcb80c2509e030842de77adfb77820f5 ]

./drivers/hwmon/emc2305.c:597:4-15: ERROR: probable double put

Device node iterators put the previous value of the index variable, so an
explicit put causes a double put.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/tencent_CD373F952BE48697C949E39CB5EB77841D06@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc2305.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hwmon/emc2305.c b/drivers/hwmon/emc2305.c
index 84cb9b72cb6c..ceae96c07ac4 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -593,10 +593,8 @@ static int emc2305_probe_childs_from_dt(struct device *dev)
 	for_each_child_of_node(dev->of_node, child) {
 		if (of_property_present(child, "reg")) {
 			ret = emc2305_of_parse_pwm_child(dev, child, data);
-			if (ret) {
-				of_node_put(child);
+			if (ret)
 				continue;
-			}
 			count++;
 		}
 	}
-- 
2.51.0



