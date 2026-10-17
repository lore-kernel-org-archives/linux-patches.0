Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D064382F25;
	Sat, 17 Oct 2026 17:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259016; cv=none; b=ZTW78gsX2oNQ+tqh0FfsfoD8YFwVEDbH8AdnxsYDRYrEYZpLEAyxhA88We8oOpI7Bi6bNhq3HiWF4N64Z2N6Ha7H1M+hlYQrt3s2VingbpuTJpF55m7cdW/MMN2QXcWku2VPxwXPycavRXrP4MJcoAb+mDndEo0dXub/CGHuAV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259016; c=relaxed/simple;
	bh=WMBcT2dHcy6w30zH+iacJAueZoN6bk6kn+5YfXYyYKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JON9I/IrSqFki8WdygJtr6dTcUkRwExY1wfGX36kn0H8Rwl9aCGj0ESnc9PX8ZYzXsUlTLkFL3gI4vd1Mf4/Uyx4duSz35mKR+ynaHEpaz6LPxEBkZ5Mf7HlPlRbLs6C4vG+a5erf6FMGkkZXnV5RanlFWM41g5+OM8ft1JXH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrlLQKNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrlLQKNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4091F000C4;
	Sat, 17 Oct 2026 17:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259015;
	bh=w1brbQlCzzGhbtzlmOu8sZa3UACHr+EoYMcsylyb6GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrlLQKNtoa9k/3vz8xWREgMVwqK80wvlKGQENehNa69eDgNsCK01X1Udeg6k5Apyr
	 aLHHplgFvEc7EdaUcJUl7yhKTagEv79h7oCTfEedhd28ob598kfTFmEtNUKdIFRoyd
	 Wtif66L1tOPz4kSdNwWak6b0fODUOq49bLKCXcQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1075/1674] media: vivid: fix cleanup bugs in vivid_init()
Date: Sat, 17 Oct 2026 17:55:47 +0200
Message-ID: <20261017160458.712412105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit a07c179a92e949172ca52f6d4a13202ea88cd4b7 ]

When platform_device_register() fails in vivid_init(), the embedded
struct device in vivid_pdev has already been initialized by
device_initialize(), but the failure path jumps to free_output_strings
without dropping the device reference for the current platform device:

  vivid_init()
    -> platform_device_register(&vivid_pdev)
       -> device_initialize(&vivid_pdev.dev)
       -> setup_pdev_dma_masks(&vivid_pdev)
       -> platform_device_add(&vivid_pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before jumping to the common
cleanup path.

Also, the unreg_driver label incorrectly calls
platform_driver_register() instead of platform_driver_unregister(),
which breaks cleanup when workqueue creation fails after successful
driver registration. Fix that as well.

The reference leak was identified by a static analysis tool I developed
and confirmed by manual review. The incorrect cleanup call was found
during code inspection.

Fixes: f46d740fb0258 ("[media] vivid: turn this into a platform_device")
Fixes: d7c969f37515d ("media: vivid: Add 'Is Connected To' menu controls")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index e95bdccfc18e9..761f54b9f7a3e 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -2125,8 +2125,10 @@ static int __init vivid_init(void)
 	int ret;
 
 	ret = platform_device_register(&vivid_pdev);
-	if (ret)
+	if (ret) {
+		platform_device_put(&vivid_pdev);
 		return ret;
+	}
 
 	ret = platform_driver_register(&vivid_pdrv);
 	if (ret)
-- 
2.53.0



