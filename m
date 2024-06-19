Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B553282495;
	Wed, 19 Jun 2024 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803181; cv=none; b=flFnQ3hcKoN0pNKIYrMx0HTgbbMr+fKPefNc/SiYqSbcF0PGPxu/YteBfGQcj1DwiRTN9PxdNfrLCcGclKpfVvEes9dmga8+uzSOfyFWuXhp706zUY9p7DA9nAoHRXQoeK1NYCdBMisn0GYBRb2kkaL83VnB2SGrXdeaI37FijY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803181; c=relaxed/simple;
	bh=6PfhWGOmBvUweNQkNu4yo0hjbQaTz+9wBsLHxrAUjAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnTx++rreEEov0S9j4QsoisMK4IZUzDKxMUh4D3uObn2fYUeNr7vVRW2VR3YvEoEz/z6gbeFt5ZLW9bvED3cPpYSHwJD5wkyc6hFQFSbStPAx2r+svjhMvc68FWvFjPjuD8rEOCjJJYUgdykSaIl/QGIVUv55MTpm5KH+Vi5x94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foVIXcyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foVIXcyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6F8C2BBFC;
	Wed, 19 Jun 2024 13:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803181;
	bh=6PfhWGOmBvUweNQkNu4yo0hjbQaTz+9wBsLHxrAUjAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foVIXcyi2OILJH6+SXEfY6oHis8o0Jex1tzEypMLh1Jt1g+BaxxmKj9kC6MdS+Rl+
	 jHWOKhl4z5VlBxn5hY5proQphiVz1H4gRtGo/IzxbHPq+EVDnJsEua+fNJUBUWIS1U
	 5UKTg7go4Aa/+9bbyEhOI3wQrdWO4diEZnFx+2VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laura Nao <laura.nao@collabora.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 149/281] thermal: core: Do not fail cdev registration because of invalid initial state
Date: Wed, 19 Jun 2024 14:55:08 +0200
Message-ID: <20240619125615.574366060@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1af89dedc8a58006d8e385b1e0d2cd24df8a3b69 ]

It is reported that commit 31a0fa0019b0 ("thermal/debugfs: Pass cooling
device state to thermal_debug_cdev_add()") causes the ACPI fan driver
to fail probing on some systems which turns out to be due to the _FST
control method returning an invalid value until _FSL is first evaluated
for the given fan.  If this happens, the .get_cur_state() cooling device
callback returns an error and __thermal_cooling_device_register() fails
as uses that callback after commit 31a0fa0019b0.

Arguably, _FST should not return an invalid value even if it is
evaluated before _FSL, so this may be regarded as a platform firmware
issue, but at the same time it is not a good enough reason for failing
the cooling device registration where the initial cooling device state
is only needed to initialize a thermal debug facility.

Accordingly, modify __thermal_cooling_device_register() to avoid
calling thermal_debug_cdev_add() instead of returning an error if the
initial .get_cur_state() callback invocation fails.

Fixes: 31a0fa0019b0 ("thermal/debugfs: Pass cooling device state to thermal_debug_cdev_add()")
Closes: https://lore.kernel.org/linux-acpi/20240530153727.843378-1-laura.nao@collabora.com
Reported-by: Laura Nao <laura.nao@collabora.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Laura Nao <laura.nao@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 38b7d02384d7c..258482036f1e9 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -936,9 +936,17 @@ __thermal_cooling_device_register(struct device_node *np,
 	if (ret)
 		goto out_cdev_type;
 
+	/*
+	 * The cooling device's current state is only needed for debug
+	 * initialization below, so a failure to get it does not cause
+	 * the entire cooling device initialization to fail.  However,
+	 * the debug will not work for the device if its initial state
+	 * cannot be determined and drivers are responsible for ensuring
+	 * that this will not happen.
+	 */
 	ret = cdev->ops->get_cur_state(cdev, &current_state);
 	if (ret)
-		goto out_cdev_type;
+		current_state = ULONG_MAX;
 
 	thermal_cooling_device_setup_sysfs(cdev);
 
@@ -953,7 +961,8 @@ __thermal_cooling_device_register(struct device_node *np,
 		return ERR_PTR(ret);
 	}
 
-	thermal_debug_cdev_add(cdev, current_state);
+	if (current_state <= cdev->max_state)
+		thermal_debug_cdev_add(cdev, current_state);
 
 	/* Add 'this' new cdev to the global cdev list */
 	mutex_lock(&thermal_list_lock);
-- 
2.43.0



