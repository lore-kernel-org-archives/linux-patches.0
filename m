Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10243C13FD;
	Sat, 17 Oct 2026 17:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258278; cv=none; b=Uwb0oowrRtVRPar6DAHfsDSRh+SKWETn27P2hI8vADVqQZhz3x1HqGDliyAVvnhMnT4XbjYncEnRfA6np18HjWPreq7LsooOJo2qglrDOvmlkE+6YdhECyuz3YH7YBVWjfeTZ+MdatfhNll7E9z0oWCEPF3QR5wWrowlHvu9tMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258278; c=relaxed/simple;
	bh=aqebw9zij9W00tXEXhYNBqS6SgJVvA+NuqZU1KIuZOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCSfhhPeKCNvcEbCpptEsGJiyPFPlUl6Jd9A4c/Q/cNf+QAYfmww++0scaGJY0eNDZLTU1rUv+D9AHVbtFBIuIwEwHihfjew5rsaCqzbWkV4zR2bUwr/805dRKnUWcedXGhgkA0gvr7ovOGZDMSOdqztUL79h9eW+DaivJKVS3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+mc24bm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+mc24bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2B41F000C4;
	Sat, 17 Oct 2026 17:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258277;
	bh=eCYfevL58UFUHQqxH45XXXcTzA0KXa471g3fzis4P6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+mc24bmbawwi49ob7kBT+tbaREJYbuaxFwjKGOFXy/3tnaOBuAdMqyTdTMNhP0m1
	 XHOz82AO4qiSftcTodLjnDXGI2DrQL6qeX4P2w+1S6RTvf4/DpTVE9+/HN6J8Eyy6n
	 o24cYvV6Y/Z36NMQblgmAX2tiHgU9XuOOYISAaRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoqi Zhuang <xiaoqi.zhuang@oss.qualcomm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0830/1674] coresight: ETR: Fix ETR buffer use-after-free issue
Date: Sat, 17 Oct 2026 17:51:42 +0200
Message-ID: <20261017160452.429356195@linuxfoundation.org>
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

From: Xiaoqi Zhuang <xiaoqi.zhuang@oss.qualcomm.com>

[ Upstream commit 35501ac3c7d40a7bb9568c2f89d6b56beaf9bed3 ]

When ETR is enabled as CS_MODE_SYSFS, if the buffer size is changed
and enabled again, currently sysfs_buf will point to the newly
allocated memory(buf_new) and free the old memory(buf_old). But the
etr_buf that is being used by the ETR remains pointed to buf_old, not
updated to buf_new. In this case, it will result in a memory
use-after-free issue.

Fix this by checking ETR's mode before updating and releasing buf_old,
if the mode is CS_MODE_SYSFS, then skip updating and releasing it.

Fixes: bd2767ec3df2 ("coresight: Fix run time warnings while reusing ETR buffer")
Signed-off-by: Xiaoqi Zhuang <xiaoqi.zhuang@oss.qualcomm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/20251021-fix_etr_issue-v3-1-99a2d066fee2@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index f3312fbcdc0f8..e9b8a396e4ba8 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -1156,6 +1156,13 @@ static struct etr_buf *tmc_etr_get_sysfs_buffer(struct coresight_device *csdev)
 	 * with the lock released.
 	 */
 	spin_lock_irqsave(&drvdata->spinlock, flags);
+
+	/*
+	 * If the ETR is already enabled, continue with the existing buffer.
+	 */
+	if (drvdata->mode == CS_MODE_SYSFS)
+		goto out;
+
 	sysfs_buf = READ_ONCE(drvdata->sysfs_buf);
 	if (!sysfs_buf || (sysfs_buf->size != drvdata->size)) {
 		spin_unlock_irqrestore(&drvdata->spinlock, flags);
-- 
2.53.0



