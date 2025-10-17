Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72375330B00;
	Fri, 17 Oct 2025 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716518; cv=none; b=Jo2RISnzR1xn3tmembLho/vairUIvVJZOQqGd3ap0QXbl+0MNHhqAQVWUmWPKPP57qlgeTuOdPnHwNN5Y62y7qmxtGO221Jhm5BjuidvYuM8n7QFEjSrFuCOmuxLFWxywxK5hgs/kJtzRNInAYcMcuDRXPwJpOIYcE3SFnlOhe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716518; c=relaxed/simple;
	bh=gsHisVrDePyZJzgho+CxKFCxUT3Rrvb1Ns1S3GDstfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gfsjyq6x7V0PQy3rSVVARHkR7UU1o4iS+ysuO+eATdylAyqlWXEPf1qRa7CBoUKBnjntgvBeLOaTisLsHUncv2mwl55jjkCGWy++Mps9quv6Lp9JTFRC41hpBQjNRFHJH3hypDpWl0WtnDQDHlusa41FbmNYAF4N77SMvY1n7Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2E/GPET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2E/GPET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF534C4CEE7;
	Fri, 17 Oct 2025 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716518;
	bh=gsHisVrDePyZJzgho+CxKFCxUT3Rrvb1Ns1S3GDstfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2E/GPETOjm/ihcJjqCsYPsrIVMHyhmT7YVBy9OueL2kMq2bNXRU+pTD/K/pUL2R/
	 0ZH2TGDlcq9VQrf2vUyGkkF3Y+vYxgbET6IJnWDCQ/F4rmFri9VX4tyXuVSLIRyh1b
	 NN/h/eUG6jMugjqD0DhcUBAfYfKkUsT2f4WpbyWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 185/276] iio: imu: inv_icm42600: Drop redundant pm_runtime reinitialization in resume
Date: Fri, 17 Oct 2025 16:54:38 +0200
Message-ID: <20251017145149.226590204@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

From: Sean Nyekjaer <sean@geanix.com>

commit a95a0b4e471a6d8860f40c6ac8f1cad9dde3189a upstream.

Remove unnecessary calls to pm_runtime_disable(), pm_runtime_set_active(),
and pm_runtime_enable() from the resume path. These operations are not
required here and can interfere with proper pm_runtime state handling,
especially when resuming from a pm_runtime suspended state.

Fixes: 31c24c1e93c3 ("iio: imu: inv_icm42600: add core of new inv_icm42600 driver")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250901-icm42pmreg-v3-2-ef1336246960@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -730,10 +730,6 @@ static int __maybe_unused inv_icm42600_r
 	if (ret)
 		goto out_unlock;
 
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
 	/* restore sensors state */
 	ret = inv_icm42600_set_pwr_mgmt0(st, st->suspended.gyro,
 					 st->suspended.accel,


