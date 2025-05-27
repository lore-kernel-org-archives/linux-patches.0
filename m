Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65A026868E;
	Tue, 27 May 2025 17:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365636; cv=none; b=NXJm0Hmghf4k4ofKh1oLfx+nWeHM54GVdKtQWZ5B3cL2j+8KwEGqs1O3wDE+0sc+U/nPM3E7pK68x4KHyvMmOvmA1KoQdj8OxuEyqPrBIg2QCOT2Yi/QyMayY6U3TyQSpAL598k5kkPfo3WCJZ0/NTZoZCrOX9euBy4kuEl0Tn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365636; c=relaxed/simple;
	bh=ZGWfNEtTeg49sVHDfkguv7wo5YTC76062DnsrvcnG2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArIsLndATHjJZo1DzY0dhSTDgMvYrzwTOtD8KaT6m7S7yXZj2nBTKxs/JjFM7WHGfb3u4abe0QJvY6+uWKVfhJqzn+3bHvRm3jQUorEWVphTTYyc+FaWQh3YQhHYV+Ok3T/fFz6XV12RudJEyb7Eey3UdtJyNGhDFG7IZvYlg5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccK9Z93u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccK9Z93u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AF2C4CEE9;
	Tue, 27 May 2025 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365636;
	bh=ZGWfNEtTeg49sVHDfkguv7wo5YTC76062DnsrvcnG2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccK9Z93uk9/ePVVJPv08oGhEVNy91ZuMbfbW7qhhgZ61rWdqpw/9E8A5sg2HK1+ih
	 1p519dY+TDOKDmgse/91DErsBGFB5VEw5PYi8YJCOQ/X0idc0/1DWrOOMZI0yV//fi
	 CBnvZNppGgajIS0fhiY6sl9ZBOMOv6DKnoOn/h2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 439/626] hwmon: (xgene-hwmon) use appropriate type for the latency value
Date: Tue, 27 May 2025 18:25:32 +0200
Message-ID: <20250527162502.841708732@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

[ Upstream commit 8df0f002827e18632dcd986f7546c1abf1953a6f ]

The expression PCC_NUM_RETRIES * pcc_chan->latency is currently being
evaluated using 32-bit arithmetic.

Since a value of type 'u64' is used to store the eventual result,
and this result is later sent to the function usecs_to_jiffies with
input parameter unsigned int, the current data type is too wide to
store the value of ctx->usecs_lat.

Change the data type of "usecs_lat" to a more suitable (narrower) type.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Link: https://lore.kernel.org/r/20250204095400.95013-1-a.vatoropin@crpt.ru
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index 92d82faf237fc..4e05077e4256d 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -105,7 +105,7 @@ struct xgene_hwmon_dev {
 
 	phys_addr_t		comm_base_addr;
 	void			*pcc_comm_addr;
-	u64			usecs_lat;
+	unsigned int		usecs_lat;
 };
 
 /*
-- 
2.39.5



