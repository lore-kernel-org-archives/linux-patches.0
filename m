Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F07481C4;
	Mon,  1 Apr 2024 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986679; cv=none; b=DrU+49ibLfUMEfdNaDzH1Vmbm85oFufM89zYAQywx69Aa2AMy6l2xmMCkISQLcvDKrJUlaOHywrWmoWd8qs+Wr9ekHwKaO5ahEY2t0xW3BsMIkG34lkv5YGPKBE82TQA1dkHYWPie3fsWRSIXrwuhbfoM0+EprMasGAJRnI5WqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986679; c=relaxed/simple;
	bh=pqwDKkfLjjskvr32r0rzrl7SssZdk26kYuhttXx5PUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSf7daDAzFpmVRln3e8Bm5uRFRw/CcU6YRinrMgBQu7uXD51fUHKMH45LNt3C2IkorEgroKrI9k56mEUcj8qxhNwEpdgtE14r11seJU5JFMqIqAneNlykrAvNwKVqt6M4bs97DPZSLL+anF2db1sK6750Ps46wNx91TwSzzPwmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUmBAZMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUmBAZMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB4BC433F1;
	Mon,  1 Apr 2024 15:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986679;
	bh=pqwDKkfLjjskvr32r0rzrl7SssZdk26kYuhttXx5PUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUmBAZMd605OzQXBXJIkdfhodjE8PUlpQgVt2D/co6K3G4KI7S7+tIG+pNDkO4TNS
	 goqEkXH4Qr7q5uNVaF+HNHhPhrhBN/SjfOUbHca7vFPrEh7CKpNM2srzHExh4Qnv63
	 o0ElrGh9jZxdHQKa4p0rjm34KcvpvexYxyrE04Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <cy54@illinois.edu>,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 051/399] ubi: Check for too small LEB size in VTBL code
Date: Mon,  1 Apr 2024 17:40:17 +0200
Message-ID: <20240401152550.708381369@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 68a24aba7c593eafa8fd00f2f76407b9b32b47a9 ]

If the LEB size is smaller than a volume table record we cannot
have volumes.
In this case abort attaching.

Cc: Chenyuan Yang <cy54@illinois.edu>
Cc: stable@vger.kernel.org
Fixes: 801c135ce73d ("UBI: Unsorted Block Images")
Reported-by: Chenyuan Yang <cy54@illinois.edu>
Closes: https://lore.kernel.org/linux-mtd/1433EB7A-FC89-47D6-8F47-23BE41B263B3@illinois.edu/
Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/vtbl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index f700f0e4f2ec4..6e5489e233dd2 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -791,6 +791,12 @@ int ubi_read_volume_table(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	 * The number of supported volumes is limited by the eraseblock size
 	 * and by the UBI_MAX_VOLUMES constant.
 	 */
+
+	if (ubi->leb_size < UBI_VTBL_RECORD_SIZE) {
+		ubi_err(ubi, "LEB size too small for a volume record");
+		return -EINVAL;
+	}
+
 	ubi->vtbl_slots = ubi->leb_size / UBI_VTBL_RECORD_SIZE;
 	if (ubi->vtbl_slots > UBI_MAX_VOLUMES)
 		ubi->vtbl_slots = UBI_MAX_VOLUMES;
-- 
2.43.0



