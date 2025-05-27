Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562101FB3;
	Tue, 27 May 2025 17:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367955; cv=none; b=DO6crI/M0DRPpBgdiq3w1hOeC14Rggs+pKMWyS06WGW92IiroMB+MVoBWnhE4vNUEBtLC6CMxxIz+qNf0hliyAXlLKnkTEH8EHjz1CfJ4EqblV6UWNSCzpXaqTAt6aNlvExttBUdtIoReZswAA5lCX7cBn9vvvSWiA6F2y8VkrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367955; c=relaxed/simple;
	bh=b03Eee/sK8n0984R2xAmZTP+GAhMDOTb5hZu3GQc+HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB5F3SkSvKTvQL1OE6N5yzSEm7/JJ639qVr6T6RIQg88rp3Brj0cvLXNAkroL8t2dY20Jh/0tt/hKkXlBSmQYZvFzeMQ3aKFL0sNLUFlKva5G2A26MJC2R7i+J5XqS5CVlkoH1lpqwmVXB9+Sw7d8+rDeqPZ4YxCK6pWYN1XcbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+KWlDvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+KWlDvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DD1C4CEE9;
	Tue, 27 May 2025 17:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367955;
	bh=b03Eee/sK8n0984R2xAmZTP+GAhMDOTb5hZu3GQc+HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+KWlDvlw0RghP1/r0PmD3baHLLoJpvenXCFLubvv2CA8bJrSYkfaP8iQwomNBvSk
	 qEWy4zsoVm7ptMzPK93R8usw11Mt/5RzZ/T87xaMlHja7zHHUvgxzWpx0HJ7ErKK+L
	 vT2eys2N3W28Qa976jTqhNhEHcZKsgcI8/fTBy8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 553/783] hwmon: (xgene-hwmon) use appropriate type for the latency value
Date: Tue, 27 May 2025 18:25:50 +0200
Message-ID: <20250527162535.668225066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 7087197383c96..2cdbd5f107a2c 100644
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



