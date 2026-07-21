Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D30B42DFEC;
	Tue, 21 Jul 2026 22:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673006; cv=none; b=ooWMAZGombHu1d2UDPKw+kBk50U/9KI037ZITuN4CGQSt4b/UXZ1nH35NW9MAb8EbfxJkdcSf63LibwIFTPBgX8mRLZlK+EbKnM1XW/iUotCtXhBg44+qrtI5aKheR2TsPLxIMMHMPXHBrhG+EbBEyeMRoAIe410w802T28Hu/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673006; c=relaxed/simple;
	bh=4AS8yGZ6mMyN7FUpAkoCQ79SzOH74u46dCk2v7o/IgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZUyAycKdFQ5E3wWpNFaoetWEh12hIQ01qNjUy8QLd7WCqUmeqiO6z+WjKqmSeJ6928bBnxKdgTScOlYYuwbcPBRgFkYDFA5GG+BpUG1lzxPpbZKR62Cq/vsUnrVS9VKDs93QlvIdg5IAKgqITQUJkhcOyJb/N5FAGTyYVrxp44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eASceduW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eASceduW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D011F00A3A;
	Tue, 21 Jul 2026 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673005;
	bh=giirzSu66pqKB7XONuPz4mPvYLlGSyufX2Mb0YLafAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eASceduWiCKKufCY38AQodTgiUT7/WwaaM7DiOfFIegSuNmaAHmtDHUERAVr/B2/5
	 Vy+hkc8+Cx5lbj54eL82QLkXDARoXsh28z1TcKDRXJX3Vu65v3wCxdQl2kgmaZxyv8
	 f3GgyzIS2jhTMGVWrs3h1T5Moz75xackinlhOl/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 839/843] iio: invensense: fix odr switching to same value
Date: Tue, 21 Jul 2026 17:27:54 +0200
Message-ID: <20260721152424.954288016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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


