Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140BF353EF7;
	Sat, 12 Sep 2026 10:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207860; cv=none; b=FZItlA+A3TVlUgPqb/o1MgeG8ACu7TMCwack2DycHgePpc1c7+Rq5YqSVYX7WAj+iFuRmXSde2kQH9jDvrs35uku0W3CbAknpL8F/bTzXXuHU4jm2HSIx9wP4S/AAxRrB8fRo3PeGehglMXXQ2A8+8UcJh8Lqm8wd+RgRCZ0b2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207860; c=relaxed/simple;
	bh=H5mBUUKOXfyl6sgZmBILZs9K/Nak178fWEeZNgsnvZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWxAhWSUEDugulpNw9SDmIyJk9hfYyjYseprpXWpoXFLE0BQxdMhZv46AbAEVgsfzTd5ViXHK4h/JrBo6dxzDTwY8NjnQcXjRtv9JDHY7vNgEs63G2p3UuUfs/9Zr7Kd1Ti9MaxXEr+W4X4F0asH+AyKgdNM+vd5gdwIcayU3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uu8HZX6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uu8HZX6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38211F000FF;
	Sat, 12 Sep 2026 10:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207859;
	bh=gHL9ub9rWN21zuIUgdYqk1gvbplKqZnDvwdv9IrzbqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uu8HZX6iCESTzQTM11m13FpCs2EY57sAlN8sHslWtT7CXlm3mZFR/IXrIGo0SDwu8
	 vdlcXdCUtyucTueUmA5JXMUUwB6SWzMV3xPqwRos5j3EfYntkXHNGvR0MwAHDZVZT4
	 VIlaKsnGBQtrUHSBJ+KowaFg4NZC4MOtGVamgUD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0462/1518] soc: ti: knav_qmss: Remove debugfs file on teardown
Date: Sat, 12 Sep 2026 08:43:51 +0200
Message-ID: <20260912065633.898324238@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3c817862759913097f11467ed4ed2bbf974dabaf ]

knav_queue_probe() creates the global qmss debugfs file whose show
callback reads the global knav_qdev state. knav_queue_remove() tears
down the queue manager resources but leaves the debugfs file published.

Save the debugfs dentry in struct knav_device and remove it during
teardown before the resources used by the show callback are released.
While touching the debugfs_create_file() call, spell the unchanged read-
only file mode as 0444.

Fixes: 41f93af900a2 ("soc: ti: add Keystone Navigator QMSS driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706144706.96313-1-pengpeng@iscas.ac.cn
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss.h       | 1 +
 drivers/soc/ti/knav_qmss_queue.c | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/ti/knav_qmss.h b/drivers/soc/ti/knav_qmss.h
index 9325e8ce2e25c..bd3426a30d958 100644
--- a/drivers/soc/ti/knav_qmss.h
+++ b/drivers/soc/ti/knav_qmss.h
@@ -304,6 +304,7 @@ struct knav_device {
 	struct list_head			pools;
 	struct list_head			pdsps;
 	struct list_head			qmgrs;
+	struct dentry				*debugfs_file;
 	enum qmss_version			version;
 };
 
diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 3557ee5779b96..6d775a261737c 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1868,8 +1868,9 @@ static int knav_queue_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	debugfs_create_file("qmss", S_IFREG | S_IRUGO, NULL, NULL,
-			    &knav_queue_debug_fops);
+	knav_qdev->debugfs_file =
+		debugfs_create_file("qmss", 0444, NULL, NULL,
+				    &knav_queue_debug_fops);
 	device_ready = true;
 	return 0;
 
@@ -1887,6 +1888,8 @@ static void knav_queue_remove(struct platform_device *pdev)
 	struct knav_device *kdev = platform_get_drvdata(pdev);
 
 	device_ready = false;
+	debugfs_remove(kdev->debugfs_file);
+	kdev->debugfs_file = NULL;
 	knav_queue_stop_pdsps(kdev);
 	knav_queue_free_regions(kdev);
 	knav_free_queue_ranges(kdev);
-- 
2.53.0



