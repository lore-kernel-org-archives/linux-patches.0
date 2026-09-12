Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A308D4BEE38;
	Sat, 12 Sep 2026 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229754; cv=none; b=cL5Q9s5HEzz69Q6ihBcqgZQHF2EXEXk5O48DVRGVUEgzeUypaNbV3J/cMptrZjboTQ4lGkO3uY7gq88n5Uew+F+JlbWsdn1EUKSrdINFzxu/4hn5n5ugckLSw5PHa54H8w9wl4kVdIMdvu4hYpUlSp9Bpt5mR5v3q859yfjDMe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229754; c=relaxed/simple;
	bh=RQiDhyCnpnBVmt2gFdummjLbMZ4qUKvr3OPOPIC2kYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlRGbITYXcFQl5AoRtOUmoLH/cR4D1gRkcHtMH4NOkrLPcIJuQOz0TIlCwM39ISNiqzekOzxNyiTsdWH8SPt+uga4vOZKO9FkJOn4GaH9SCg/B/trbXHvRSlo7IuFXp1qzCeChawsHs3dXZ/uV3mGxiXlpi9uHXyjr8gAjuMH6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGdk1cS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGdk1cS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431691F000FF;
	Sat, 12 Sep 2026 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229753;
	bh=T00A7GdU7Nu/ZobLq+GSa7UtC6Vp8nSxyzhKw4HvW94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGdk1cS1Y4q0MGBEt8x+2vNOUZkTd3jfBEJlLWyr8wDPEahZBOMEzkDHUKSVX1rVB
	 QymoEMHP5mCTMFMfk2VUCWGGI47mugdb8NXhYi6oOdztsbquuwCI20UxA+TphpwQRC
	 WAo8rFO+dE5Ervjp3xrIvfr6AvPmN9TPUFj0XI9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Md Shofiqul Islam <shofiqtest@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0655/1191] soc: ti: knav_qmss_queue: Implement resource cleanup in remove()
Date: Sat, 12 Sep 2026 08:56:23 +0200
Message-ID: <20260912065602.967853926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8fb76908be704..4bcefef9635de 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1886,7 +1886,12 @@ static int knav_queue_probe(struct platform_device *pdev)
 
 static int knav_queue_remove(struct platform_device *pdev)
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
 	return 0;
-- 
2.53.0



