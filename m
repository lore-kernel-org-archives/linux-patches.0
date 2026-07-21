Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C66C2BE05F;
	Tue, 21 Jul 2026 16:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649653; cv=none; b=X/MK7h9ouNf+TseVG9cXRfD1yh9T9Pce1jupQUURvhU4/O3xXInFk8JvoKmWiVIHSNu82w4sFISTq96Q3vTmhf/5lcL4izEOYQeLtYiYd6Tn9Jg1iO0QSGIzh9j1MyJWefitnJo4E3cYuwuZd2KRYROIOYqjpceV9mq/DEZx67M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649653; c=relaxed/simple;
	bh=uYIMd4QnGkMXb6AU+7AYnBw551TU8rl9wYo22uVKWgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKQID2fyEntUW1SBNtqVCLFJ+mcpObJI9XsV/qnDt144ZG73ZEsMnGP7IeyG3RPfKOWLvamzXr3TA6dAQUUIg9fY1bmW1TdIuB165i9/tCzqDVu+RrJYgbVU5XiNCyaUxFXRR2sgYi5yE+Jqr8eydzUSZpy8mg7oOSiEfmnj8wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQ+Skb7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQ+Skb7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C9A1F00A3A;
	Tue, 21 Jul 2026 16:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649652;
	bh=7bkR6F6rHCAV4BVhsPwZBRlwImf5M6uQuwYZIN1oRJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQ+Skb7H+pTXwTd7V/FQnGtYGffe3ejqzwMLURBqQv4UFqdbrxnA5wSkoxkL8SGEr
	 6bBQqLnJcsn6FczHFzv09qfcur0dT7FDEcOWVwNdM+upAuwESp1tb/9J4U1WupI67i
	 LZXGfRNXd6Ofd9jf/ZlwulFe/IFTuqr5z8sBS64I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0659/2077] vfio/qat: fix f_pos race in qat_vf_resume_write()
Date: Tue, 21 Jul 2026 17:05:32 +0200
Message-ID: <20260721152608.346521017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 4ec5e932e636896e97e4c6a8205b0ac76d52421a ]

qat_vf_resume_write() checks filp->f_pos before taking migf->lock, but
copies into the migration-state buffer after taking the lock and
re-reading the shared file position.

Two concurrent writers could therefore pass the bounds check with the
old offset, then have the second writer copy after the first advanced
f_pos, writing past the end of the migration-state buffer.

Take migf->lock before doing the boundary checks.

Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Link: https://lore.kernel.org/r/20260608151317.136613-1-giovanni.cabiddu@intel.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/qat/main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
index ac9652539d66a1..60ff907b6a67ac 100644
--- a/drivers/vfio/pci/qat/main.c
+++ b/drivers/vfio/pci/qat/main.c
@@ -298,14 +298,18 @@ static ssize_t qat_vf_resume_write(struct file *filp, const char __user *buf,
 		return -ESPIPE;
 	offs = &filp->f_pos;
 
-	if (*offs < 0 ||
-	    check_add_overflow(len, *offs, &end))
-		return -EOVERFLOW;
+	mutex_lock(&migf->lock);
 
-	if (end > mig_dev->state_size)
-		return -ENOMEM;
+	if (*offs < 0 || check_add_overflow(len, *offs, &end)) {
+		done = -EOVERFLOW;
+		goto out_unlock;
+	}
+
+	if (end > mig_dev->state_size) {
+		done = -ENOMEM;
+		goto out_unlock;
+	}
 
-	mutex_lock(&migf->lock);
 	if (migf->disabled) {
 		done = -ENODEV;
 		goto out_unlock;
-- 
2.53.0



