Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3FC3AFD15;
	Sat, 12 Sep 2026 09:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206731; cv=none; b=qFPzz5CWpKrCb4oxqKO7OuhJUuwm1DQd1dm2W2sjclOWtVOUitPvKr9CawRkZI7C/GkuW0jmi6aCNkoiBuFOJYOX0PTE7gMesMU4nIV0qOYAGfbcYKK/0wWuayY823m7eMDInRrVlu55aFUSsBK0Q0/IOmiaUIRStjn7cY6+T0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206731; c=relaxed/simple;
	bh=FKn3BzcV8qH3OxPGKUyXXouXxdEnvwMFqXtolsq0MQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTIbgSBSuXKnXn/HJT7fO4qvAowdgNxrOEgtrbNN38nz0MSFyfZq3e//Df6EFQEZd522LE2onpod8HcZ0iJ0Fr+uc9sPh8Xkv/uDjt/ItCvtK5gEROQLJIFlPCyrwxiRYQLI7HOg+k9kttE9zCZ7VQIYGafC1DjqDfKvNPkoCZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umfIsj4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umfIsj4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7F61F000FF;
	Sat, 12 Sep 2026 09:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206730;
	bh=ZL+/ALTIhTkQnOcEWFusFH3SHxFSxZ1ZIogvPodxe78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umfIsj4Xx7TJ5hX6+wjKIhGuRgjSdrijjuMLtSZObmA/5TMRoR0byo4XVB9vm2/2e
	 sGTsjFgRxL7/z0wSJdjXiNgUsW2a+4GPP/aroBfSgxw0iXqzpqUMdFivdLBNimzBff
	 1C/GfKWiKh+WWSk6xQlwMYb8Opf8iwrNDnYTJeO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0266/1518] staging: media: ipu7: fix pm_runtime refcount leak in ipu7_init_fw_code_region_by_sys()
Date: Sat, 12 Sep 2026 08:40:35 +0200
Message-ID: <20260912065629.504927789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidhu Sarwal <vidhu.linux@gmail.com>

[ Upstream commit 843644e1c3347670498d247d7cd20dff1569181c ]

ipu7_init_fw_code_region_by_sys() calls pm_runtime_get_sync() before
accessing the firmware code region. If resuming the device fails,
pm_runtime_get_sync() leaves the runtime PM usage count incremented,
but the error path returns without dropping the reference.

Use pm_runtime_resume_and_get() instead, which balances the usage count
automatically on failure and avoids the leak.

The ipu6 driver uses pm_runtime_resume_and_get() in the equivalent
location.

Fixes: b7fe4c0019b1 ("media: staging/ipu7: add Intel IPU7 PCI device driver")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu7/ipu7.c b/drivers/staging/media/ipu7/ipu7.c
index 8ec571c6bd07f..83e73fac3a7e0 100644
--- a/drivers/staging/media/ipu7/ipu7.c
+++ b/drivers/staging/media/ipu7/ipu7.c
@@ -2343,7 +2343,7 @@ static int ipu7_init_fw_code_region_by_sys(struct ipu7_bus_device *sys,
 		return ret;
 	}
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to get runtime PM\n");
 		return ret;
-- 
2.53.0



