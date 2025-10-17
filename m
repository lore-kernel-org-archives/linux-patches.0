Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2244732C95D;
	Fri, 17 Oct 2025 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715473; cv=none; b=hAuvycxlWMX2DOlczy7tkr0lEu4yOJRaN+soe0vNgaHkDFlFzZTS/D/CHZ/NMGUg1lZyhGnkeRbDg6zULUmtWle3ezgOMjqKqQCoSdQwji3Rm+jDoNJdD/5MMczElK9tydfVv48Imk3Rw4Bt1+uc3z78PZeWSOZweqmWvxOh5UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715473; c=relaxed/simple;
	bh=UF1v4kHjOWKoKub+AnaD+vFjmknmeuMgXROpfHZTl9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhJclQuUTaXg2F0qcO1l7cioRwXzlG7d/NvKwd/3B4Xhz2O/0salM6/je/rE9re+e6uaQChBNPp7FPbx7e+jUr8I29+lKfG4z3ShVDsl9iIt1Y67AEWiCG+if3WHYEDeegfjd6oJvDOVmYDtKDhX/PwzF+i/HpFOEUk3pt2moe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gR4qf4KC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gR4qf4KC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9C6C4CEE7;
	Fri, 17 Oct 2025 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715473;
	bh=UF1v4kHjOWKoKub+AnaD+vFjmknmeuMgXROpfHZTl9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gR4qf4KCykTlRf1jvjsVlKNUawu4pjaLB0Ch4Ygv8b7XNgj76tbjw6GRIlTgttmR8
	 TAR2BbUIY+W8MLrmUw9OjAp+HOhJgjSWrATvAq5I0syQ8TDvknEVrZ+ZDHe5kDt5bN
	 RzQBMRyUqI8NDQFpKWgbcfy6cgG7nxeE2lb2h3Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 227/371] iio: imu: inv_icm42600: Drop redundant pm_runtime reinitialization in resume
Date: Fri, 17 Oct 2025 16:53:22 +0200
Message-ID: <20251017145210.297949713@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -917,10 +917,6 @@ static int inv_icm42600_resume(struct de
 			goto out_unlock;
 	}
 
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
 	/* restore sensors state */
 	ret = inv_icm42600_set_pwr_mgmt0(st, st->suspended.gyro,
 					 st->suspended.accel,


