Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9227A38F94C;
	Sat, 12 Sep 2026 19:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242644; cv=none; b=Q/Vqbiac1NyEnwpscn5Fr96Gzu8pyHlJbxrkn9EVN8rVCYb72AoU9/lxoAHJjKpWL/bopAngj+uIbrPZ8p9SR8j2tTAIhmqOsbTHiiohzL3644/Ba3YJ3EIJ2X/OQAdGB6OhXUxSKYajj0RefhFXgU3vMITvRenz3Y+0w3IeK4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242644; c=relaxed/simple;
	bh=LoGYJPrduIWZ0QSHWRv1PW8OIg6+kB9HuYcItr8noUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFzCG5RIz9xlMHzlgKJjw2cvky6cN/7Ix5Hfg7KzZcATuG2NfckA0Wp/mGI8eh+hiX8fU8wyHyp+Qhdb18BgPJD7iSex7/S431DFb8wCQ6Kcfth8LS0xrLRo6n5WfzooG8ZMiufUv14RDnu3q5oGf5ppFQgN5E86VlLcSjZTCBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Viz3P2/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Viz3P2/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A921F00893;
	Sat, 12 Sep 2026 19:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242643;
	bh=6zwHz44SsOBQuL3gqj8y10644wjlbuEefVCrJTkLmCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Viz3P2/L+sSht9AvipLkXoryFLNFcQaWvWwCUpNnUk/O2kxL3Ri7YAn/d6dEKomjS
	 LjyVA8iLfNEhmzCwCHIPULbNntMvGF4HyPu9tnvoZDMj1ZpbL3pBQzaqxHrxrfoD6Q
	 OqdJOVx7N33UdMJpMkuZUXfeqvTz/75jm2izalC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 469/798] soc: ti: knav_qmss: Remove debugfs file on teardown
Date: Sat, 12 Sep 2026 09:01:37 +0200
Message-ID: <20260912065527.894856256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a01eda720bf6c..44d6976bbafc3 100644
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
index 1075ab64fd320..95b4ec6156332 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1869,8 +1869,9 @@ static int knav_queue_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	debugfs_create_file("qmss", S_IFREG | S_IRUGO, NULL, NULL,
-			    &knav_queue_debug_fops);
+	knav_qdev->debugfs_file =
+		debugfs_create_file("qmss", 0444, NULL, NULL,
+				    &knav_queue_debug_fops);
 	device_ready = true;
 	return 0;
 
@@ -1888,6 +1889,8 @@ static int knav_queue_remove(struct platform_device *pdev)
 	struct knav_device *kdev = platform_get_drvdata(pdev);
 
 	device_ready = false;
+	debugfs_remove(kdev->debugfs_file);
+	kdev->debugfs_file = NULL;
 	knav_queue_stop_pdsps(kdev);
 	knav_queue_free_regions(kdev);
 	knav_free_queue_ranges(kdev);
-- 
2.53.0



