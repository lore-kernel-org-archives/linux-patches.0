Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3233E36CE03;
	Tue, 16 Dec 2025 12:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887477; cv=none; b=GORwi5kSec4cksVoi4J41Ui4Ln3ex/BvjHlbxJXYgKh+Q7dgarK0naWi8abLHyHcNcpTPn1H2NbD81IbT0ELOMRCQ+g85D1a80WWXQjijV4ExDJUVbT+H4x1xgIW7OQR4g+Fxg5goa9HGidZ9bqt/N8rMkFqCaTGQIT5HXKbMxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887477; c=relaxed/simple;
	bh=U8G3rveA/QpVMuECVKc3o6nVFDRrkVpkvN5EKCwoH+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eh2HwkIz1TDrWQdzz75geeW1eQT2z+rZBVyKJ3br3RZ+rAo6CYcUYn46c/H7klUPrKyU3F3J8Ly4Zdl8qjSykkTN/ZRlnSembMMgYIPiItKT6ZQJxuV4YPj0WGOMgIUqKSOZ14S8bHopSP34eiDGWWBZLAI9eUwYbLZvaL4BaBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPHtB4bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPHtB4bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B36C4CEF1;
	Tue, 16 Dec 2025 12:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887477;
	bh=U8G3rveA/QpVMuECVKc3o6nVFDRrkVpkvN5EKCwoH+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPHtB4bdHVe+M53A+APU6K4u1PvsFAD3LlHctajl9RZwv8p6VR/H708ocUcSgUE0x
	 yUZ2g50sG40v2dDb7AeaUH6Xd+Ah/HGF+BOxbdf1jzSZbNWG83JHtlJwOj6DMNn8Gk
	 GDsqoJkQfKkeTJypejglOIzCn1qWjNGWr5S5XrM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoqi Zhuang <xiaoqi.zhuang@oss.qualcomm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/614] coresight: ETR: Fix ETR buffer use-after-free issue
Date: Tue, 16 Dec 2025 12:09:36 +0100
Message-ID: <20251216111408.947237575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index b07fcdb3fe1a8..800be06598c1b 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -1250,6 +1250,13 @@ static struct etr_buf *tmc_etr_get_sysfs_buffer(struct coresight_device *csdev)
 	 * with the lock released.
 	 */
 	raw_spin_lock_irqsave(&drvdata->spinlock, flags);
+
+	/*
+	 * If the ETR is already enabled, continue with the existing buffer.
+	 */
+	if (coresight_get_mode(csdev) == CS_MODE_SYSFS)
+		goto out;
+
 	sysfs_buf = READ_ONCE(drvdata->sysfs_buf);
 	if (!sysfs_buf || (sysfs_buf->size != drvdata->size)) {
 		raw_spin_unlock_irqrestore(&drvdata->spinlock, flags);
-- 
2.51.0



