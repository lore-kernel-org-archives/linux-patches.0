Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4A528030E;
	Sat, 12 Sep 2026 10:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207806; cv=none; b=YJ06Yw9T2XZDa2+XWUrPefP4dQr0YVC1NvJtJdtCZF/TrPXBy8ySUCMkoB5ASiqARlmilR+d1EKmv3Psf8Hla1WxI8FUgQkiJC2hiNXr+OE8PKSnYcnWxfkkh7YwMZgwbSakZcVCe3ZdDn33OTfDys5FiGEXywQHBQ8IRIOQ5kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207806; c=relaxed/simple;
	bh=KMbkfa4jYzzvU3gZn2Vz/nJClPi2WpU4cLo2l/TloEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF7XDW+yWckv2PusVzmlM9RD+XoBYbp3xvFhplUBm3wPQgClCY0QxQtjLJ1Z1HRdLOrF/jl06ZXIE8L0HxTVIjmRJHUf5bWmRP6iT1F6v3fNLXdprBwnxPP+6+FydhgMJQCnCigOAY0mImVGuu1BGUE4k6y5rQPlC7y8gpEiVQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYFd2AfX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYFd2AfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22F41F000FF;
	Sat, 12 Sep 2026 10:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207804;
	bh=MXYD9kS0kBAZAS1yYR0KzmoO6PztNkHJPIzaYhinc2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYFd2AfXPwg0IWyYFYVp82Grm4XHqd43ae/O4VyRmNo6T+AbwprqcsDEIqY2wJ9gy
	 2VtB8yDB5Z0w3ca5pG6QPpk7qo8PZEmWek4wSUiAJHxbaCSlRZPTDi0hCoMVATFjjA
	 tFNYuT1Y5SzKn0xgBtUeg2uxgS1skVU3GxZulXXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Md Shofiqul Islam <shofiqtest@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0461/1518] soc: ti: knav_qmss_queue: Implement resource cleanup in remove()
Date: Sat, 12 Sep 2026 08:43:50 +0200
Message-ID: <20260912065633.876418657@linuxfoundation.org>
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

From: Md Shofiqul Islam <shofiqtest@gmail.com>

[ Upstream commit 10a1969353b20caa50c320717e054601631c0d3e ]

Implement the TODO in knav_queue_remove() by stopping PDSPs and
freeing queue regions and queue ranges before disabling runtime PM,
mirroring the cleanup performed in the probe error path.

Set device_ready to false before cleanup to prevent any further
use of the device during teardown.

This ensures resources are released on driver unbind and avoids
leaking queue/region state.

Suggested-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Md Shofiqul Islam <shofiqtest@gmail.com>
Link: https://lore.kernel.org/linux-arm-kernel/20260506154114.2288-1-shofiqtest@gmail.com/
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: 3c8178627599 ("soc: ti: knav_qmss: Remove debugfs file on teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 6e56e7609ccd3..3557ee5779b96 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1884,7 +1884,12 @@ static int knav_queue_probe(struct platform_device *pdev)
 
 static void knav_queue_remove(struct platform_device *pdev)
 {
-	/* TODO: Free resources */
+	struct knav_device *kdev = platform_get_drvdata(pdev);
+
+	device_ready = false;
+	knav_queue_stop_pdsps(kdev);
+	knav_queue_free_regions(kdev);
+	knav_free_queue_ranges(kdev);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 }
-- 
2.53.0



