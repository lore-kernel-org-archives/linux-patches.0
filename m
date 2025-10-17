Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBCF335085;
	Fri, 17 Oct 2025 15:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713721; cv=none; b=jcxlJORZIXn6c34P2H2N5DMYdyIbIkT9KZoq2EzUyBonsJz4+Z5vnAzZparGIfCwOr3g+25Lv6T1piyx+KdLVTG/Ca8VIhggqOLbbhxplWTJXrT1eUa/K3DWjAmOkJFxZsoxebfp20a4gAenJHV7yniauqyVkYQSzA/dyjdKaps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713721; c=relaxed/simple;
	bh=aywmOkiumjIPVg8ljAo6HgOelm7SnyCYYfxEOR7jR2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f88YSNOBquv3ruJIBkhxrMnrGJh84IgBSN2qn1JxKri49NJZyLDPTdAfmZlcheofgA25W83TWnrq+E2GRGKyEInU/z85hKvCB8cF8R+g9yxfkAyc5Q//WmURhMnq7uDR4jtC+RgfJVryKnZJ/tKhT5D8ZwhvfrPM0e7dnM2lf9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHXbKdM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHXbKdM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED81C4CEE7;
	Fri, 17 Oct 2025 15:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713721;
	bh=aywmOkiumjIPVg8ljAo6HgOelm7SnyCYYfxEOR7jR2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHXbKdM/39g1rCtYxm1n28ULThrWsXpBJg+O2UmSruO/Ut+iJNmLQlSBdAzFJlCfh
	 NSphcFkxXhJvtj5xKd8Kghqd9krqnHQtb1aMgVMjp2iOQTE81MybMUlYYasiY7ZQQq
	 fo6f3Kmanyb16DDRYEB1aTeCMudjJ3pBpy7vCGoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 097/201] iio: imu: inv_icm42600: Drop redundant pm_runtime reinitialization in resume
Date: Fri, 17 Oct 2025 16:52:38 +0200
Message-ID: <20251017145138.313644584@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -747,10 +747,6 @@ static int inv_icm42600_resume(struct de
 	if (ret)
 		goto out_unlock;
 
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
 	/* restore sensors state */
 	ret = inv_icm42600_set_pwr_mgmt0(st, st->suspended.gyro,
 					 st->suspended.accel,


