Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADA721B9F6;
	Mon,  2 Jun 2025 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876302; cv=none; b=V+3TOuVfpErOeejX4hOz9Mc2PkRU0+WlMOx9jjs8zYYrOVppHzhzPJHrbKJj9xYCyj5F8wq8ESPXjnH0wMnVb9lqTT0+dTjICWKy8j4rNamZyRPT0+nDv2ND/gS+de+uJOw7sFl1Sfc/ECkm0xArihNw/bYShOMxQ2ez0BVM5uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876302; c=relaxed/simple;
	bh=vRl7iyBlBP17GGiOf0XWOXVenQGmBBzrrpj214AigOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEE+s55BluhbjN5yWhTyFTsMsOZGa8m78RYESO6ZIeFpTAvrPom7Q1S8ugsjGeoAFOw3nS4yFJOWp1/0VUNNBTvXhYtevqFk0qU5oN+DnHVybO7wIZ2UWlsuK9P576a6jlTODbCYVBcOIdh4hFtIssyykLA0j1riQdoW/38N1lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWlFUfCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWlFUfCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A2DC4CEEB;
	Mon,  2 Jun 2025 14:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876302;
	bh=vRl7iyBlBP17GGiOf0XWOXVenQGmBBzrrpj214AigOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWlFUfCNATGgapkdTg9tgIwxK7z8s8a1NGOBBBTBx8SR3El9HKgostJ6YCbj1FAm5
	 krxWOrkk8DjF/VH6rXIdFGc0lWUyZywVv/UOzUaxINB7cJ3x9K//Gaqo5yFskfJ8PX
	 h2VIzzxM2KrdNDTEVqHQyQEksH1tlkv6Gnjd5p4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/207] hwmon: (xgene-hwmon) use appropriate type for the latency value
Date: Mon,  2 Jun 2025 15:48:27 +0200
Message-ID: <20250602134304.007159488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 60a8ff56c38e9..9e82ba43f5cd2 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -110,7 +110,7 @@ struct xgene_hwmon_dev {
 
 	phys_addr_t		comm_base_addr;
 	void			*pcc_comm_addr;
-	u64			usecs_lat;
+	unsigned int		usecs_lat;
 };
 
 /*
-- 
2.39.5



