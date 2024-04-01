Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7643A446D5;
	Mon,  1 Apr 2024 16:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987986; cv=none; b=SegJgcTDo8JSlLc6PuUKb78Sm4fmzj8suLtkwF0J7nbOVS3HNqZlXPXix3OmpOrvBdKnlJOr9yINWWkVy2eEJr3Ik0fuU4hKPeDRbIgpPzft1eCBJNjoXUNwE3xIibey+ptRm9FvrmbYqS+tp3quPWYa1INz5q3DC32Rq4s/ylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987986; c=relaxed/simple;
	bh=wP6WzThwrc8gIQjGY+x2HDbDv9O1KgDjvDvyGugp2sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYPE8DIed3yZ9Ctkbue4FtV1k10/iIgJSN8ST4QyX2TNxoeuygxVXwCfPpS/TWpFbgmO/JQ0yCAYCujtnUAZ4KK07K6saD65+9bHJI1u4RSfdFXEOjjMV9J+K65cFIfWXk4TnvjfFADEhJLt0MBN3xdOlAUdClhUQxb9GLjX8O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvxd1wle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvxd1wle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC955C43390;
	Mon,  1 Apr 2024 16:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987986;
	bh=wP6WzThwrc8gIQjGY+x2HDbDv9O1KgDjvDvyGugp2sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvxd1wleH/C3tFfk25PU60VwFlSPmoSrGLHbTS3eCmAcD4Sa1/zEuQQpfgs6EZT4O
	 lD7Lmk1wkuP2GyMAXjTm2JfFTI8/FSpmi2dyfZ6IJTqyWgzGUOnO/eY9Dp+jGsjXRU
	 pYWaObBG2PkPcubuE40lBO54kMO+5gcuKWbptoC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <cy54@illinois.edu>,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 051/432] ubi: Check for too small LEB size in VTBL code
Date: Mon,  1 Apr 2024 17:40:38 +0200
Message-ID: <20240401152554.649414260@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



