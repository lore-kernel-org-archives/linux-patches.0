Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D513B384CE2;
	Sat, 12 Sep 2026 10:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207446; cv=none; b=NEt2ux4L83DXMWR00vcq4rEi3jqMHc7aULwfQHCdiTCG0DIaTyST2jwzI6iyKj4Oabw5EZOXj56D6nRHZHd2/0qvL+DIeQU744HkFTt2p5/Rg6jELEvp9A7WTUcTaji16jGG/XsY9nzGBO0284NABSd2DAY0TO2TwkmWNi3vPeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207446; c=relaxed/simple;
	bh=jRulM9b9QEj23XUo0P6/vEr1I6/KMV6BKAdC4zKKRX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6J/w20k97HK80VkdV7woLBLz6ftPuiRDJhYFGrIb7qWJbCiOyMmcWuPIjOCwlfJy9mtWSROHSBB6n/CRrfE2zfvSkt2tTkgMKA9mNTfD0AYqofbh2umNQBaxxGCDyBu7fy9vi/0BSPm4ph593OS+dmLKeSgKRPJxSFfzHWvlUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6xiRgF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6xiRgF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A946C1F000FF;
	Sat, 12 Sep 2026 10:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207444;
	bh=IiIhh29c8cTUz13OcAsMadxOoUOnwtVmNIxdLsaLSXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6xiRgF6QG/wTQ0ecE48hLQyzF7KtvoQmclfD9PyiwSw43LheXbFG7HSN3dSfI09k
	 QoPWwqgiEilg3zd+VNb1p1o2E6KMqKS6Pmaxv53+z4JFFDRNjY3SQ5glcWeAnXkO6U
	 oqeO0/qWRMliUJ6KDu7XhPdaQQ9xTSz6Ji5K7Et0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0371/1518] cxl/mbox: Break poison list loop on an empty payload
Date: Sat, 12 Sep 2026 08:42:20 +0200
Message-ID: <20260912065631.860270496@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 8b301c4afbce4bc3f94528441d8d5ce1366504ad ]

A device that returns count == 0 with CXL_POISON_FLAG_MORE set on every
iteration never advances nr_records, so the max_errors guard never
trips and the do/while loops forever while holding poison.mutex. That
hangs the sysfs-triggered scan thread and blocks all subsequent poison
operations on the device. The existing "Protect against an uncleared
_FLAG_MORE" guard was intended to bound a misbehaving device but does
not cover the count == 0 case.

Stop the loop on an empty payload so a malfunctioning or malicious
device cannot wedge the poison scan.

Link: https://sashiko.dev/#/patchset/20260702090849.47501-1-icheng@nvidia.com?part=3
Fixes: ed83f7ca398b ("cxl/mbox: Add GET_POISON_LIST mailbox command")
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260709155714.1893280-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index fa775f50fe75e..e1c23aae2a2ed 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1449,6 +1449,11 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
 		if (rc)
 			break;
 
+		if (!le16_to_cpu(po->count)) {
+			dev_dbg(&cxlmd->dev, "Poison empty payload!\n");
+			break;
+		}
+
 		for (int i = 0; i < le16_to_cpu(po->count); i++)
 			trace_cxl_poison(cxlmd, cxlr, &po->record[i],
 					 po->flags, po->overflow_ts,
-- 
2.53.0



