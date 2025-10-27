Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06223331A4D;
	Mon, 27 Oct 2025 18:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591302; cv=none; b=U8QhKLw9nhxeNFGfZq8Xdt09Rv+NUyVuvdSPv/OOsT/mDQWJchF/tLhCjpl/Qmf6zUtaZA3Osnj8eMBjXtqD4R1cMg+hGEQBIrG+UmiXo1Z/UOdrz65DBnaEUqzmPoXmqKDmAHvRJyMLDkHr7eYoKnKhHFHvSRrMsj2bQv1a0G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591302; c=relaxed/simple;
	bh=Axl0M9bttNiWB/8Mw4zYBj3g1uE/A6yWsc7b1harRIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmGmUBrSn9glF+Y/VPZFbME7FxNGt2jIITscg/aPa8eOwB+p2O5ugVtkFU/GoROsgH/ag8+AaN6eP9drXkn6QVqoXK/YGQYQq07cETekNYOq7wUE3Xh0GTKnDG61xYw0P9mC6LrIVhRvop6de3MODPQzrtq+amUsUSL8yVEYydU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGgVK0+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGgVK0+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5CCC4CEF1;
	Mon, 27 Oct 2025 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591301;
	bh=Axl0M9bttNiWB/8Mw4zYBj3g1uE/A6yWsc7b1harRIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGgVK0+IddUcHjBJp0sE3Ac9+BolPEewtGk0c2OWtyzamShnYsxradndtI5EcoMnk
	 4p6szWCLsqnek/2cneXvKNIDELEuk0Dj5jM6L/2Ygtu6jXLlCo8A/493+GySg45UGX
	 +ahH0mFolX2L/hvVe+KQP9FYKPu3SsubytN6F+O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 143/332] iio: imu: inv_icm42600: Drop redundant pm_runtime reinitialization in resume
Date: Mon, 27 Oct 2025 19:33:16 +0100
Message-ID: <20251027183528.409528655@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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


