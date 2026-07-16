Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AE7332604;
	Thu, 16 Jul 2026 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211741; cv=none; b=FHLJcfCMjTPzypldVro43GwkZGBWS8Wd6Avp1qO+EH8ctmi81KP77kzLIz1npRuaAu+TrYeUH50z1EhUtgej5RoKCOEKrrhj2cT8K4EKItpmk4cce3UKUqZMEk3vxZQI8f0ZG9abCa9r4VtZqC+Qc9q6Zf98o1ZseTdaK6YML/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211741; c=relaxed/simple;
	bh=DCRX10BcYlOPHMJ5cTQpmyschV7e7dBRC8pHckuO18I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya4qMKowK9oswLDb5svKm0kn3gqcIoJP+cD5MkAi3H/dFpcNe4T0YRA7E5WLcxfQcJTkCaBkmA4ZtdUMVEIjdE6toTeO5UnLj+gHBwpFtQEXhBF/HiyuALEgr1ijK3q/RojFP9ky4iu3r5cS4CdTjn00HYS4c/i2drPS5HrDjGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kci/EXao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kci/EXao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7461F000E9;
	Thu, 16 Jul 2026 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211740;
	bh=toL+owbeCPIjNodOqhMCu+Qy+FXMVFjXGSqjeWAgeRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kci/EXaoyVWLoYRZAnFYQx0qwu2oDAwTvRbCAkIQid8wZzGJ+NTOTFSLtiEvdIsFk
	 XENxoxhz5Eaju7DygfJkufkg/N5eMBlRIrhpNdyb5BRTtg7cgaI7FEMMPqSgWZx6TT
	 GpGxPVmdRllOXc0+0NWrcQlTqXprCbp1YejwwUYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 063/349] iio: light: opt3001: fix missing state reset on timeout
Date: Thu, 16 Jul 2026 15:29:57 +0200
Message-ID: <20260716133034.735757907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit c123ca6ee26ad98f70a866ff428b08145c5a24fe upstream.

Currently in the function opt3001_get_processed(), there is a check
that directly returns -ETIMEDOUT if the conversion IRQ times out,
completely bypassing the err label, leaving ok_to_ignore_lock
permanently true, potentially breaking the device's falling threshold
interrupt detection.

Assign -ETIMEDOUT to the return variable and jump to the error label
to ensure ok_to_ignore_lock is properly reset.

Fixes: 26d90b559057 ("iio: light: opt3001: Fixed timeout error when 0 lux")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260525-opt3001-cleanup-v4-0-65b36a174f78%40gmail.com?part=1
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -280,8 +280,10 @@ static int opt3001_get_lux(struct opt300
 		ret = wait_event_timeout(opt->result_ready_queue,
 				opt->result_ready,
 				msecs_to_jiffies(OPT3001_RESULT_READY_LONG));
-		if (ret == 0)
-			return -ETIMEDOUT;
+		if (ret == 0) {
+			ret = -ETIMEDOUT;
+			goto err;
+		}
 	} else {
 		/* Sleep for result ready time */
 		timeout = (opt->int_time == OPT3001_INT_TIME_SHORT) ?


