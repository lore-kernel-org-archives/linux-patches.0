Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC565143757;
	Wed, 19 Jun 2024 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803481; cv=none; b=KjqibGijmtPoBC523tqIpRgLb2WzfaXNdZzDlo8tdx49yFbFWOu1wiTIWhRZl+gJr8f7MFNd/5AQ2uVeTqHBjLG/yNrZBmSw90HKy/qgupRbT06NImQP0CTl8ArL+f4Y9bTQid1RGNDzTNlZHykuGRfF7DT1JaO4Ixi66OBPr6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803481; c=relaxed/simple;
	bh=PxtEdK6XSieMHIyQlv0oR6hIjy9WtCdZOqkTwOZHVP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3ZTXoztQjU715cQoTpN7FkQUtuG742x/L2wsqV7JVbbKqZwZyfjasUlXhA1yXXMkVtKc8R1h7YypPGwDR7AcDMSv+rOWtPbdtTvOUOsWnbt+m7KDYisxnQ7UIs2R5uUWJfubqAuzm0sCUdd8iGhZs7/nJvw1xlNGiRSCS0UP68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zc0u3ZcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zc0u3ZcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6028CC2BBFC;
	Wed, 19 Jun 2024 13:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803480;
	bh=PxtEdK6XSieMHIyQlv0oR6hIjy9WtCdZOqkTwOZHVP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zc0u3ZcYd19oM5nuq+9Jl2goTbRsb68jTIwV+ESZCgCxhaB9zE4ziMmtrXD4/vXTV
	 o3G4IPeAkQbKCwIRl4Y0H1ZTXgcScsqwsWG6rr7HxwX1IkLGe4kKnhqLuG1nuLROXb
	 1tSgKQP43TOcm0Ke6OIbx1/xilSFEF0pWTB4sgug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 250/281] iio: invensense: fix interrupt timestamp alignment
Date: Wed, 19 Jun 2024 14:56:49 +0200
Message-ID: <20240619125619.592809545@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 0340dc4c82590d8735c58cf904a8aa1173273ab5 upstream.

Restrict interrupt timestamp alignment for not overflowing max/min
period thresholds.

Fixes: 0ecc363ccea7 ("iio: make invensense timestamp module generic")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240426135814.141837-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -105,6 +105,9 @@ static bool inv_update_chip_period(struc
 
 static void inv_align_timestamp_it(struct inv_sensors_timestamp *ts)
 {
+	const int64_t period_min = ts->min_period * ts->mult;
+	const int64_t period_max = ts->max_period * ts->mult;
+	int64_t add_max, sub_max;
 	int64_t delta, jitter;
 	int64_t adjust;
 
@@ -112,11 +115,13 @@ static void inv_align_timestamp_it(struc
 	delta = ts->it.lo - ts->timestamp;
 
 	/* adjust timestamp while respecting jitter */
+	add_max = period_max - (int64_t)ts->period;
+	sub_max = period_min - (int64_t)ts->period;
 	jitter = INV_SENSORS_TIMESTAMP_JITTER((int64_t)ts->period, ts->chip.jitter);
 	if (delta > jitter)
-		adjust = jitter;
+		adjust = add_max;
 	else if (delta < -jitter)
-		adjust = -jitter;
+		adjust = sub_max;
 	else
 		adjust = 0;
 


