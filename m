Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A535025A;
	Tue, 23 Jan 2024 01:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974096; cv=none; b=maJ4bUaGa5gveQathWPKy3+rmCpA/DIkYshIU4SiFsu1c1neCadzTa4wArT26kXBHGL+TdVOmuDggSUdrEsdQ7uROMHKb59o+ITh9XOSL/alY1t7Wp8wgc0/8+0BF2qn9F89rURwtWCmUFaPjnX1DqHaJ/OveVevCUl86f53dNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974096; c=relaxed/simple;
	bh=EEDIW6NmsJXnJQPSX/ruCxNTTFEz2diwZpuhnYgRffA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajeWiGOaVMEciiemxAzibxMzWyDCuzipsH3VCW8y7rUos+qv3iemf5Za7jn+Ot6fy3OtLWyxejO8j7j9ZdOUOuesFPMkFIdW6dgvq6sb0lUyloatAtUyQkkBim+8ciylFmY+RX2ZUewPLSJrKEXYwI4XM2wv9b2Nf69mZtSMnnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJVON5Yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJVON5Yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ADFC43390;
	Tue, 23 Jan 2024 01:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974095;
	bh=EEDIW6NmsJXnJQPSX/ruCxNTTFEz2diwZpuhnYgRffA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJVON5Yt0umqkLVHyl2doorTu7PS2h+GD08GvaPbkBxF4/17JCffQAO7AhdGOtGsO
	 gDtHVPMpBSw6yT3RxynU+tyW3BY8UVuDpU4onx3joSYBTXT0UFRHl/T0Ddi60aSkKT
	 ID2tbnb/JqOpjjx4dRfWNcEjDHy+T129pFBELLnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/583] thermal: core: Fix NULL pointer dereference in zone registration error path
Date: Mon, 22 Jan 2024 15:51:27 -0800
Message-ID: <20240122235813.264995853@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 04e6ccfc93c5a1aa1d75a537cf27e418895e20ea ]

If device_register() in thermal_zone_device_register_with_trips()
returns an error, the tz variable is set to NULL and subsequently
dereferenced in kfree(tz->tzp).

Commit adc8749b150c ("thermal/drivers/core: Use put_device() if
device_register() fails") added the tz = NULL assignment in question to
avoid a possible double-free after dropping the reference to the zone
device.  However, after commit 4649620d9404 ("thermal: core: Make
thermal_zone_device_unregister() return after freeing the zone"), that
assignment has become redundant, because dropping the reference to the
zone device does not cause the zone object to be freed any more.

Drop it to address the NULL pointer dereference.

Fixes: 3d439b1a2ad3 ("thermal/core: Alloc-copy-free the thermal zone parameters structure")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index e6f3166a9208..2de524fb7be5 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1382,7 +1382,6 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 	device_del(&tz->device);
 release_device:
 	put_device(&tz->device);
-	tz = NULL;
 remove_id:
 	ida_free(&thermal_tz_ida, id);
 free_tzp:
-- 
2.43.0



