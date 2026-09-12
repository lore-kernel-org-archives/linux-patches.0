Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286F528E0;
	Sat, 12 Sep 2026 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229759; cv=none; b=bilNHdEgqNrb/0OrcII+objbDUqQ5M3N478iETdpO/zwv+VmtV5cXsbMU3VM3ATaFD5GlPM5bMkybE5BoPItbaCE9dTe2EovWSXAa8Ao/mSY/5KA19wp2QPip63SGaaQZ1maPGKP+dF1FGT5Fo3ZClbSRG1/i7y/5h+UIxkxyHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229759; c=relaxed/simple;
	bh=MdtYtdbB8p05wl65rZCR60irLhPFfaH5OH3hQzNhWBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmQNEGGoB13vjAn617XaFfp9fTEhto2AL0hAE/9jWd1DuO4knbwenyYEHmzyT6pAmsOY9LGeH6IlvbWV04TLX1fKHttsJLFKapuz3wvMAdxMUM2kk+IBMHQWtr+Yquh6b3VnSkcMDe7tTn0M9h54Z2Lr8gbMpXchgMG3q5ToTVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK46FtCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK46FtCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08341F000FF;
	Sat, 12 Sep 2026 16:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229758;
	bh=JOfVYtDcPc9H0ujeq88oUygFJ3D5eVbzXPEgOU3Hw0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GK46FtCvMw2UUGpaP6wKMbj43M9xOY5NNow26jygvMWiajA1VoENAdsV8+q9XSqJQ
	 3GMfrWb0bLm44NU+EimDJL2/8z7HM59PSTutXbPn+on+C7ST3HosGVUyPB3YVT3cnC
	 Ip6RwQ0bPf+I6FA7PJLE5kLNEZcHxntW8JQ4p5h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0656/1191] soc: ti: knav_qmss: Remove debugfs file on teardown
Date: Sat, 12 Sep 2026 08:56:24 +0200
Message-ID: <20260912065602.989699116@linuxfoundation.org>
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
index 4bcefef9635de..0b653271490d6 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1870,8 +1870,9 @@ static int knav_queue_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	debugfs_create_file("qmss", S_IFREG | S_IRUGO, NULL, NULL,
-			    &knav_queue_debug_fops);
+	knav_qdev->debugfs_file =
+		debugfs_create_file("qmss", 0444, NULL, NULL,
+				    &knav_queue_debug_fops);
 	device_ready = true;
 	return 0;
 
@@ -1889,6 +1890,8 @@ static int knav_queue_remove(struct platform_device *pdev)
 	struct knav_device *kdev = platform_get_drvdata(pdev);
 
 	device_ready = false;
+	debugfs_remove(kdev->debugfs_file);
+	kdev->debugfs_file = NULL;
 	knav_queue_stop_pdsps(kdev);
 	knav_queue_free_regions(kdev);
 	knav_free_queue_ranges(kdev);
-- 
2.53.0



