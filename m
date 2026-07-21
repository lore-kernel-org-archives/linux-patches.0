Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B17D43935B;
	Tue, 21 Jul 2026 23:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674829; cv=none; b=uR42cKe+2dn2AF41IFcz9+HMNuydtpcmm/PC+0aJG9z8LpoM+srIyJsLYtQkbKy1WN4ZzaqJ6eOWY+pKWSVcX7vzt0A1euhhjeoTOYkVLpeeyoF839sisCUM+mLGmQLg9YQedBYL7CG3CXpia9OpH6agkf0h6cg5w+E2za39+/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674829; c=relaxed/simple;
	bh=wELYb2yKMwXAg5n2+51Pkj3GR34w7Q59r00o5MrDT5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hc0z5LTSQAvwUGywEwIbxOco9XE7CDNeaCSw+9GZSohpOMC8jDLPvb9NmNNiLN96JNh+WKDUZEdz/bdS43fATuGHyaKQtVUNvIkVUI1k1vtmTBl18KdbqaValq3RiroQKXkLwhs8+n88OBojhmod7ulkE+kE/COFkqEIoDrSzYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvz6wZeQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvz6wZeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D161A1F000E9;
	Tue, 21 Jul 2026 23:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674828;
	bh=KGuUpTdX0367L0ZfWJzAuhdtIaUZZDW+L69/bUgWjcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvz6wZeQQ/QEVaSvLd39UkDDphw39W70tX4n+cUwVmZ6DGEy8jaXx9bv6NWONe2WC
	 pzJHnvQNHt70TBgGDDZYnhsGF3SbM/LkVO0tIgL9nUOpsPvV9ZXg9Tl8Mqx8U6rTAV
	 4jwCdS99nRtRZkGr/EPYLOb/t7r1ThL9lJAYQpzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 689/699] iio: invensense: fix odr switching to same value
Date: Tue, 21 Jul 2026 17:27:28 +0200
Message-ID: <20260721152411.315251820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 95444b9eeb8c5c0330563931d70c61ca3b101548 upstream.

ODR switching happens in 2 steps, update to store the new value and then
apply when the ODR change flag is received in the data. When switching to
the same ODR value, the ODR change flag is never happening, and frequency
switching is blocked waiting for the never coming apply.

Fix the issue by preventing update to happen when switching to same ODR
value.

Fixes: 0ecc363ccea7 ("iio: make invensense timestamp module generic")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240524124851.567485-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -60,11 +60,15 @@ EXPORT_SYMBOL_NS_GPL(inv_sensors_timesta
 int inv_sensors_timestamp_update_odr(struct inv_sensors_timestamp *ts,
 				     uint32_t period, bool fifo)
 {
+	uint32_t mult;
+
 	/* when FIFO is on, prevent odr change if one is already pending */
 	if (fifo && ts->new_mult != 0)
 		return -EAGAIN;
 
-	ts->new_mult = period / ts->chip.clock_period;
+	mult = period / ts->chip.clock_period;
+	if (mult != ts->mult)
+		ts->new_mult = mult;
 
 	return 0;
 }


