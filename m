Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A402405E1;
	Tue, 26 Aug 2025 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214635; cv=none; b=hYRNowuEfSyUGQpmzBJS9Un9fB5uwgCJp7ssBCvfggwrio1YXw6d6y1ko6goNMlEIa+QHO3A+wrRsbvvrZODFurT4a59s/T2NvkSyn2ptOXrqgdX6MelDaHG7C6Kig2IKV5H2GwSvoX/96+TrEUrVpYYyJ6qeUrvA5g7oVNv6WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214635; c=relaxed/simple;
	bh=QNi4ETE9xdBq+TgeIfLTiwvRKagz7gSYEik0QTNj+2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twnTkejTvZTnkjrUB7+1XvkWb+fqTVjmvKTuo67w/pn/WQZ9RAJ1nbJ8ozY5fNPe4TSATLtXr+PeoqY8Jyig9W3DdHnWv4XUORrmEUFqDTWXDbgOWuVYUMYQQpGz1VuBc+bhGU4v/bo0vubOAhyeUr6zY2AOhN+KcMzzkLJxD4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SylXz0vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SylXz0vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CF0C113CF;
	Tue, 26 Aug 2025 13:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214635;
	bh=QNi4ETE9xdBq+TgeIfLTiwvRKagz7gSYEik0QTNj+2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SylXz0vnb1YxuLCBu/0uhdd8XlSeCz6d4cIpGfa5+phaEHQe0QH3Y17vRZs12JQsC
	 W0fFQUfuPuTHb1XaLLNqmiltZ3mdTVVI1x6J3xEW5lb8ZLBuAh+hNHnFKdPZe8ecyv
	 SzSZGtQP4YFhLkgO2U23UcNPEd8pgGoAjWE6vuY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meagan Lloyd <meaganlloyd@linux.microsoft.com>,
	Tyler Hicks <code@tyhicks.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/482] rtc: ds1307: handle oscillator stop flag (OSF) for ds1341
Date: Tue, 26 Aug 2025 13:07:44 +0200
Message-ID: <20250826110935.991922749@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meagan Lloyd <meaganlloyd@linux.microsoft.com>

[ Upstream commit 523923cfd5d622b8f4ba893fdaf29fa6adeb8c3e ]

In using CONFIG_RTC_HCTOSYS, rtc_hctosys() will sync the RTC time to the
kernel time as long as rtc_read_time() succeeds. In some power loss
situations, our supercapacitor-backed DS1342 RTC comes up with either an
unpredictable future time or the default 01/01/00 from the datasheet.
The oscillator stop flag (OSF) is set in these scenarios due to the
power loss and can be used to determine the validity of the RTC data.

This change expands the oscillator stop flag (OSF) handling that has
already been implemented for some chips to the ds1341 chip (DS1341 and
DS1342 share a datasheet). This handling manages the validity of the RTC
data in .read_time and .set_time based on the OSF.

Signed-off-by: Meagan Lloyd <meaganlloyd@linux.microsoft.com>
Reviewed-by: Tyler Hicks <code@tyhicks.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/1749665656-30108-3-git-send-email-meaganlloyd@linux.microsoft.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 73f2dd3af4d4..530b9340db21 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -273,6 +273,13 @@ static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 		if (tmp & DS1340_BIT_OSF)
 			return -EINVAL;
 		break;
+	case ds_1341:
+		ret = regmap_read(ds1307->regmap, DS1337_REG_STATUS, &tmp);
+		if (ret)
+			return ret;
+		if (tmp & DS1337_BIT_OSF)
+			return -EINVAL;
+		break;
 	case ds_1388:
 		ret = regmap_read(ds1307->regmap, DS1388_REG_FLAG, &tmp);
 		if (ret)
@@ -371,6 +378,10 @@ static int ds1307_set_time(struct device *dev, struct rtc_time *t)
 		regmap_update_bits(ds1307->regmap, DS1340_REG_FLAG,
 				   DS1340_BIT_OSF, 0);
 		break;
+	case ds_1341:
+		regmap_update_bits(ds1307->regmap, DS1337_REG_STATUS,
+				   DS1337_BIT_OSF, 0);
+		break;
 	case ds_1388:
 		regmap_update_bits(ds1307->regmap, DS1388_REG_FLAG,
 				   DS1388_BIT_OSF, 0);
-- 
2.39.5



