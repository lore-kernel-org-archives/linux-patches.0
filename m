Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1C11E0B7B;
	Wed,  6 Nov 2024 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897370; cv=none; b=CvmY14bzFLEcQv7i9d+tcjdro2ndvDuMtU8k5Gwmppr9iADOZU2LAqk/bU4rpp8CwfhB9DEuqK9LO1tFFhHzviMKwSDKhKB5atcKKFetgWz1DbkgSkWeCyaNi/B024ZiKv/Bgyj62lT/WGyJWXGrtxXnkMZtQ81qPsxIOexrA0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897370; c=relaxed/simple;
	bh=uHsD3EJhJ41DQqa36760HsPuC86WpMPMzz5NmTQu3D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDyZr3WCUfzZ67HjuSf+WhcpMlsGqXuaoaWjecfIre4heAw5CPnb/1VZRqHr76fyE7xQFWNYXqSrxBaNAXo8jGAZ4/b67r+zjqmC5oY1kej7wWQqd0Z45kF63qsaGm7IHlZkvAS2lQZw4hQ1iAJVgXp+XsYOzV8qL3PpDLrzQZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjmAoxCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjmAoxCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5286C4CECD;
	Wed,  6 Nov 2024 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897370;
	bh=uHsD3EJhJ41DQqa36760HsPuC86WpMPMzz5NmTQu3D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjmAoxCrlSoQX/7xxpenfs2za8e10DIEYnINevhpGt/voZHPVdU4bH9c5VwYCgYmd
	 Xi3GsPHz8nAyqcs7kLBuJJ8uMpPcrFsb3okzB4h4NA1JVmW0/hDn1VvEYSwdeVu90d
	 BWySCjLrISZceN3r/8IVHpJLcdPaQKdgz28x1OXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/151] thermal: core: Free tzp copy along with the thermal zone
Date: Wed,  6 Nov 2024 13:03:11 +0100
Message-ID: <20241106120308.935160702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

[ Upstream commit 827a07525c099f54d3b15110408824541ec66b3c ]

The object pointed to by tz->tzp may still be accessed after being
freed in thermal_zone_device_unregister(), so move the freeing of it
to the point after the removal completion has been completed at which
it cannot be accessed any more.

Fixes: 3d439b1a2ad3 ("thermal/core: Alloc-copy-free the thermal zone parameters structure")
Cc: 6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/4623516.LvFx2qVVIh@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 69b89a71f44eb..d7ac7eef680e1 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1484,14 +1484,12 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	ida_destroy(&tz->ida);
 
 	device_del(&tz->device);
-
-	kfree(tz->tzp);
-
 	put_device(&tz->device);
 
 	thermal_notify_tz_delete(tz_id);
 
 	wait_for_completion(&tz->removal);
+	kfree(tz->tzp);
 	kfree(tz);
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
-- 
2.43.0



