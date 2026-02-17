Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EFB320CD9;
	Tue, 17 Feb 2026 20:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360793; cv=none; b=omDPo6JHsYWPbgA3MiyeOiNhpM0pVfr1AihgQeej+6TMXran2DroZwOEFiJk8Yag0AxwcTYWLGwsajobiVFXVx6wPhq14nP6dDcONYZmj6ldLSmjtNqAh0a4QKGEJ59PbyMmE4lhgNRwbnaOfoyu2QRSreXjUq2H4WvruhiIKb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360793; c=relaxed/simple;
	bh=f2ztiNzsjUpZpy+OlfiqfXpoySYwhKMPUDm/T0vz528=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+l9TSHlZBGRvI4myN1jSRzqIeuggL3+hbykXS2yn56PtO9qWlVfGImtnV60jFRX2qK3Ym7Ax2Ck47uLW/3eq1JQxJvU3W1oYkFXncZz4FxM4HZZVWhi3Ty9Jp5jfkOnsDkgcCyYbe9xY8GOEw6kVXn7lS6tyDEylYbP57CwLbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2iKE9tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2iKE9tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE2FC4CEF7;
	Tue, 17 Feb 2026 20:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360793;
	bh=f2ztiNzsjUpZpy+OlfiqfXpoySYwhKMPUDm/T0vz528=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2iKE9twBPwaavxpeEk3OImJ69wQD5K9Bg6WAbfYJBAUdPrRBBM18w67oj+JWY5d2
	 DYqYG/guPW/zOj5ZwfnMORYkaDkqQgojreTUO7aAU5lNtwI8rzUNALKG5Fiw67VeBn
	 Em7pbKPYt/0VNBBGoasKOfUctGN0zIdmkYt+if/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/39] platform/x86: panasonic-laptop: Fix sysfs group leak in error path
Date: Tue, 17 Feb 2026 21:30:39 +0100
Message-ID: <20260217200004.884582899@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 43b0b7eff4b3fb684f257d5a24376782e9663465 ]

The acpi_pcc_hotkey_add() error path leaks sysfs group pcc_attr_group
if platform_device_register_simple() fails for the "panasonic" platform
device.

Address this by making it call sysfs_remove_group() in that case for
the group in question.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3398370.44csPzL39Z@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/panasonic-laptop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 7365286f6d2dc..ad907c558997a 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -1077,7 +1077,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 			PLATFORM_DEVID_NONE, NULL, 0);
 		if (IS_ERR(pcc->platform)) {
 			result = PTR_ERR(pcc->platform);
-			goto out_backlight;
+			goto out_sysfs;
 		}
 		result = device_create_file(&pcc->platform->dev,
 			&dev_attr_cdpower);
@@ -1093,6 +1093,8 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 
 out_platform:
 	platform_device_unregister(pcc->platform);
+out_sysfs:
+	sysfs_remove_group(&device->dev.kobj, &pcc_attr_group);
 out_backlight:
 	backlight_device_unregister(pcc->backlight);
 out_input:
-- 
2.51.0



