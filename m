Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA55D15705F;
	Mon, 29 Jan 2024 17:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548615; cv=none; b=WIzaaF+f8Z11rggJ3mbbg8l6fepObcTgehNZnX6yHTHSqnZuVFO9hSf0pA89qMsmMINdNe7MXMg7uDZikvuDcMUdrqNuk/MvCjA+IkGh6IPf8j6l4xlkb26XbelzsrkrlNrMELWtUSSMER25bnKxW9WA04XHXwtMEixZ7P4rxBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548615; c=relaxed/simple;
	bh=F9rRV1AUe2m9u7P7X+n0gj6EQ8YasPWLoaCxJHdrTvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVGUz9tYswZmehvDv2k1LiQNvHxQOPuhtGpRsB+CjpWB37NvB7+hYsYEzBOGdVweX1NXMKgyJmf6kXXBZ0RmJFteXirAt+MbGKzfwwyrxZrPLgGivIeLsiVCnf5cWw8X8xs2ttTOrexaYBKpSfZqxfnGulDtqBY1onaME3L4Cvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1cIO2Bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1cIO2Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A12C433C7;
	Mon, 29 Jan 2024 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548615;
	bh=F9rRV1AUe2m9u7P7X+n0gj6EQ8YasPWLoaCxJHdrTvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1cIO2BqzHduq47+T++tQ3HNJSxrg31MP4G92P5gdH/xxyndZ/JiykvLQAshAs/+9
	 IqUm9vrSR2uPNKt2lbDb3OZ1ukc+TUAHBuXTnyMLpQEQLoPkoM2XpIXXso2C3tu65x
	 u2VnbMU8Vf9QlWgkMLLKwsIwHnxPgAno4MaAD7Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/331] thermal: trip: Drop redundant trips check from for_each_thermal_trip()
Date: Mon, 29 Jan 2024 09:05:47 -0800
Message-ID: <20240129170023.140354963@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit a15ffa783ea4210877886c59566a0d20f6b2bc09 ]

It is invalid to call for_each_thermal_trip() on an unregistered thermal
zone anyway, and as per thermal_zone_device_register_with_trips(), the
trips[] table must be present if num_trips is greater than zero for the
given thermal zone.

Hence, the trips check in for_each_thermal_trip() is redundant and so it
can be dropped.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Stable-dep-of: e95fa7404716 ("thermal: gov_power_allocator: avoid inability to reset a cdev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_trip.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/thermal/thermal_trip.c b/drivers/thermal/thermal_trip.c
index 597ac4144e33..4b3a9e77c039 100644
--- a/drivers/thermal/thermal_trip.c
+++ b/drivers/thermal/thermal_trip.c
@@ -17,9 +17,6 @@ int for_each_thermal_trip(struct thermal_zone_device *tz,
 
 	lockdep_assert_held(&tz->lock);
 
-	if (!tz->trips)
-		return -ENODATA;
-
 	for (i = 0; i < tz->num_trips; i++) {
 		ret = cb(&tz->trips[i], data);
 		if (ret)
-- 
2.43.0



