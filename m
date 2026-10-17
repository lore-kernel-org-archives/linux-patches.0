Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AFF4CF49A;
	Sat, 17 Oct 2026 16:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253672; cv=none; b=ZyjoKqr0Uy86Ux+ZxlTdhTrYUxMPp55y+Aw2kulSN5WpfK2asgjvSIN1f+zJi2Uo1Ty6iZB8dq9LvDsNwvPA7D3WVsegYNVmCNFA+4k8yf0FnHxHLk0r1B5RKfCFibTUe/q3cVBaNRWUMOxyPjvoe6mosdQX4SR7bEl45jWHydE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253672; c=relaxed/simple;
	bh=yDtPMzpHHvJA574xsTXTJXDGy/jtUpQUaI5HF9695XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECvUGUcyWewFVz2imwmHnWfMmGoWZZ7cllEn1gNlakiLh8D9aZeGk8AEFWWjrnZ2nCcfd9V0bBtVgBLkCT3avJ0OVl0dMx3sP3Osz8/cNau+Rb42ZeLyYO+5Y8sx7NL0sChDehuroE5yjK0OzMLHPQ6IUx1JMTuEJpT8OdJoSoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+3S1xh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+3S1xh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6631F000C4;
	Sat, 17 Oct 2026 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253671;
	bh=3O0XqSitaFV/ZCqT9nrWlVYdAyG2MCraoOuiIcS3C7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+3S1xh2MZujWuu10xW78wG3EFv0fSJ1gUdYNC3V8c9fd6hAVz82nHg/Oi9PhrQDT
	 1EGvLesECedi4Qqd/4JDG64SCJW4242I+KQdUrOjV9Ga4w4Ig++HCOTtvlaXL55+47
	 DswRnoa85ud/+OB3DY9GXE7BTGhStBEH8a9ivCCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoqi Zhuang <xiaoqi.zhuang@oss.qualcomm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/869] coresight: ETR: Fix ETR buffer use-after-free issue
Date: Sat, 17 Oct 2026 17:49:59 +0200
Message-ID: <20261017160041.095712622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a0a90ce7333e9..25f0335e2db05 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -1177,6 +1177,13 @@ static struct etr_buf *tmc_etr_get_sysfs_buffer(struct coresight_device *csdev)
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
2.53.0



