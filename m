Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7C9264F9C;
	Tue,  8 Jul 2025 16:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992840; cv=none; b=YL6i1nYiduWqUkykSYyXmSsbItkt2pokbN7PwZkjtKonLXdmlDvz11/8MpvcCYrm8uS/XrXEIL64Rydd8NTEyHNx5PsxcJwkdcbqoeZCjvlxHeueWdMINkC8WKkJWysipk32ZIDrLtUiloI+mPNi3/9kgOqMj5WBfgfjfykPjjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992840; c=relaxed/simple;
	bh=DNaK590l+sYUctDiaQfwGZoxt4ZnQ1y05gUzPB8OLcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WgE3m0uNICK9X1T75jo/ckydCyJQOvebzMRUTwOjxhEXpTjZDtiY0XRKBKOialMJ9HWR+pdM2UyBluOZBusw/cjYl9+i1CHeFkigkBuQitqY+8x+eOW3m84llp//Gz6mlghprWczyJB8N9cSQGEtU9ATofm1ooAMdUcBFZCAu8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9tl8bTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9tl8bTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2E4C4CEED;
	Tue,  8 Jul 2025 16:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992839;
	bh=DNaK590l+sYUctDiaQfwGZoxt4ZnQ1y05gUzPB8OLcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9tl8bTLK+e6oyVeGJmS3ALkdJb9I3xyNYP9jhj/6HutqPVSq5isAs6+1EgOKi21t
	 EzCywokR8gXO4STB2vjwjJBw5UD59fdHVQojXGyGPwW9V0d9jyBsR/U9sRQZrDEbE2
	 Cl7eskeYB3FEhONDEhfY/wKmuPSj/GIhO9llF4TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/232] platform/x86: think-lmi: Fix class device unregistration
Date: Tue,  8 Jul 2025 18:21:05 +0200
Message-ID: <20250708162243.269681586@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit 5ff1fbb3059730700b4823f43999fc1315984632 ]

Devices under the firmware_attributes_class do not have unique a dev_t.
Therefore, device_unregister() should be used instead of
device_destroy(), since the latter may match any device with a given
dev_t.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250625-dest-fix-v1-2-3a0f342312bb@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index a7c3285323d6b..3a8e84589518a 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1487,7 +1487,7 @@ static int tlmi_sysfs_init(void)
 fail_create_attr:
 	tlmi_release_attr();
 fail_device_created:
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 fail_class_created:
 	return ret;
 }
@@ -1711,7 +1711,7 @@ static int tlmi_analyze(void)
 static void tlmi_remove(struct wmi_device *wdev)
 {
 	tlmi_release_attr();
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 }
 
 static int tlmi_probe(struct wmi_device *wdev, const void *context)
-- 
2.39.5



