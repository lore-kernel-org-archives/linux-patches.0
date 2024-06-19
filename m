Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB9412FB31;
	Wed, 19 Jun 2024 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802385; cv=none; b=N7bA6gh8DesYDVscvkwPsaXzA4nnIW7T33ulFjL2H1jHP+l8fyVfD0xk2Q7Qj0BTaZec/0QFzUUr0KNXJQorYxVtfMkU76vVLqk0HehHmR9OuuEX2E2nR8L9kyirGSjz22mmW12c4K2IDiH+vgKQ7VvuO2VhkOapED2qisSYLVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802385; c=relaxed/simple;
	bh=7ByCgtwC46Kw6ophOV8Ep1up4Pe9Voq/MHogPHkMNko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrHW2MsyWckYSJJaDTuPK9nAxTcug3LxieJGoGD7Jq1NUig+HHlWN1O8yNaSBaQNGDst30SXHFOBx4Y0ba7MLv4GpSMViHN/HlJDX8PACJmV0iATjrI7LSXE9HzdXSOYnR3oQi5u/SqISAPvbK04qwOKU5OSY1BZsAIBOCnKz3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZPEFVoo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZPEFVoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F62C2BBFC;
	Wed, 19 Jun 2024 13:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802385;
	bh=7ByCgtwC46Kw6ophOV8Ep1up4Pe9Voq/MHogPHkMNko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZPEFVoooak6kZcpuQzt3a8GW1kMjZms+Jqhe86lrmc0qQrLBOq1+HU8uoPWsBuL3
	 XU9xdlomNIekGMw+ewHzpq0QkIByrcCQBdV88kbrJ5Eh0DqYBSiyn+De4JzPOul7LD
	 crBZgoNH5n1nZMBzbA66RPSEVzp8mUgkeVNysKKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 178/267] iio: invensense: fix odr switching to same value
Date: Wed, 19 Jun 2024 14:55:29 +0200
Message-ID: <20240619125613.175492072@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
index fa205f17bd90..f44458c380d9 100644
--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -60,11 +60,15 @@ EXPORT_SYMBOL_NS_GPL(inv_sensors_timestamp_init, IIO_INV_SENSORS_TIMESTAMP);
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
-- 
2.45.2



