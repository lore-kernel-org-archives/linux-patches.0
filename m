Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2121023A9BE;
	Mon, 23 Jun 2025 13:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685098; cv=none; b=tuwIbCp3JI8J9pkqprE5LLPd/OZ9VnYTpt3kCpAEHmSXIcrgzfjBCuAjDAyzV6fclLNHzwWdwMJ4Rgqzt4aDHliq4tpizRF5IF4wbV4q43nihTx+wXAUFaS3TErinX9wG5O9TD531HJPLqVBbBwTUdgOKjmJsVv6Tsl3j1ojLTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685098; c=relaxed/simple;
	bh=Mkwzd9jqtV26CacxyJ6WsbNrgpFNAZmrH6dcEJff2Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGm3TLTPAZMK63gDSW/mxAkRMwfFoGg9t0t0LSaViBD+1UTSJ02FP6AhIkdGBwFqtsqYmHaeNURft9yndRw1iJdEn121+CQJH3vNOHjj/xpYhri0pSNZzXSyXt7fhc2JXXCHz6sRpNTkls19LCjHFXWCEI/jGTyaVDTd7tatupg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvaFskhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvaFskhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9E4C4CEEA;
	Mon, 23 Jun 2025 13:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685098;
	bh=Mkwzd9jqtV26CacxyJ6WsbNrgpFNAZmrH6dcEJff2Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvaFskhRcJf6DvvXA6OVBHf8tSifF7SgHikiUF0m+o1mh4F3Cwr6zjTPKvhYgzgcw
	 bD4AaVRhreRJ+9e/ziK+A3V5UIsSWSmr7OdtAuEaTylJaTMGepS8cL32UDoizrvjza
	 lwM/RgRYlJYR5Q7y+ZFtya+6cwrrmn/PvrXm52ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 232/592] power: supply: max17040: adjust thermal channel scaling
Date: Mon, 23 Jun 2025 15:03:10 +0200
Message-ID: <20250623130705.809771099@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



