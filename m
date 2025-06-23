Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7060221DA8;
	Mon, 23 Jun 2025 21:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715206; cv=none; b=UHoo0jDXRV8gpr+05WwNQrx5Jd2zzapV6DAUCw2wsXzmuKfIwGgtacOEzs0jEP2yPnsoActptX4JVIntDaAY8AwDsxb5gI5dVSFDZsWqZlU+d94TrMvpyLSfAV3TQm4i9rSNb3aorwIywYQatR6WWzWEjzWwuMqpcFBNNow/Cb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715206; c=relaxed/simple;
	bh=mS/yFNb3fUKAqImUZhfu1giKB3u1amHd2YDt1A2i9pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3xA2ECfbDubuEV0qBn9r2kFrCkyKTa7vhgkoq5ALn2VaMwdtH6mdcl0C+85oJ7Yue654ReqEUc5VmLUPAroM8mZlor/fJB71Ra0W2BCaRZZMOmPCuteDzYKiHHq00gqd/fFFxKyP3seZYrCwC+KA1jix3sFAhL6bdlTtWceQu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeK36ZTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeK36ZTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E695C4CEEA;
	Mon, 23 Jun 2025 21:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715205;
	bh=mS/yFNb3fUKAqImUZhfu1giKB3u1amHd2YDt1A2i9pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeK36ZTDNU+wLZmdOFFSXAQOZV703y8/XAQCYKUudf4Tkyn9jZKD9TVa0WktQvg1X
	 956YeuGBidaxkEwUU6tpKQY7gUxjOEnp+e3PIL4Xhz9ubb6WRP3KPY9GPKTYsexv1m
	 b/5SDugmfBac4Yid2rrdCvbaNDqK0fwZNZn4CaMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/414] power: supply: max17040: adjust thermal channel scaling
Date: Mon, 23 Jun 2025 15:05:26 +0200
Message-ID: <20250623130646.743280089@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit d055f51731744243b244aafb1720f793a5b61f7b ]

IIO thermal channel is in millidegree while power supply framework expects
decidegree values. Adjust scaling to get correct readings.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Link: https://lore.kernel.org/r/20250430060239.12085-2-clamor95@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17040_battery.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/max17040_battery.c b/drivers/power/supply/max17040_battery.c
index 51310f6e4803b..c1640bc6accd2 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -410,8 +410,9 @@ static int max17040_get_property(struct power_supply *psy,
 		if (!chip->channel_temp)
 			return -ENODATA;
 
-		iio_read_channel_processed_scale(chip->channel_temp,
-						 &val->intval, 10);
+		iio_read_channel_processed(chip->channel_temp, &val->intval);
+		val->intval /= 100; /* Convert from milli- to deci-degree */
+
 		break;
 	default:
 		return -EINVAL;
-- 
2.39.5



