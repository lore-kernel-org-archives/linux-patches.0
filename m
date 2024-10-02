Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3E11D014A;
	Wed,  2 Oct 2024 13:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875752; cv=none; b=C7qfACHfqpH2SR7TYLudkdqPvYnVcn5Rf7KzJ7dCLTlhO6vfr/Lx5VpiMfilsy6PBUIyVzKW4x10gDLptU4M4gZ7kETNVr3utBZyNmrSuOQrUac47H6+cmJ24UH3keZJIQN1vSbR7uLhvMIS5qMYBs/4IMYtRKvaeGLyRoGAcdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875752; c=relaxed/simple;
	bh=2/7AaWkVqQwADH8EkAuGgaibFZz5VKnnWMIAC4wWjfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJxoNHapWo9aJPmt69e+HFy6nh0TufgbHMlHSfus2tGtQpF2zPWK7dK7cdN0cBjqxcLXfINd8FZjMSprZqPsZmHaYYRQHTcr9D+QEjLUoo9tVtpB3vYH5HrJlqxs3FuxiMOstMVykRSFGIpLRfO/ypwQYnWQFyD9wxqKJrnEoyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H85a6xTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H85a6xTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E29AC4CECD;
	Wed,  2 Oct 2024 13:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875751;
	bh=2/7AaWkVqQwADH8EkAuGgaibFZz5VKnnWMIAC4wWjfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H85a6xTSrd075QwFJLBux5esfuuXiEE37RgbkH8CFKkAYA2FYNxG9ikvj9DHDgwPs
	 DLtYUoy/wZfVrn2EjJCTCWPqX6GTFCJ7IklTDOXP64krkg6aKt2mbjmEQtjb/9VUzO
	 yUoJgzD+vDDCHkb1n57hiGBTujpHLDil4MCs30Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 208/695] scsi: block: Dont check REQ_ATOMIC for reads
Date: Wed,  2 Oct 2024 14:53:26 +0200
Message-ID: <20241002125830.763889845@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit ea6787c695ab7595d851c3506f67c157f3b593c0 ]

We check in submit_bio_noacct() if flag REQ_ATOMIC is set for both read and
write operations, and then validate the atomic operation if set. Flag
REQ_ATOMIC can only be set for writes, so don't bother checking for reads.

Fixes: 9da3d1e912f3 ("block: Add core atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20240805113315.1048591-3-john.g.garry@oracle.com
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1217c2cd66dd8..bc5e8c5eaac9f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -799,6 +799,7 @@ void submit_bio_noacct(struct bio *bio)
 
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
+		break;
 	case REQ_OP_WRITE:
 		if (bio->bi_opf & REQ_ATOMIC) {
 			status = blk_validate_atomic_write_op_size(q, bio);
-- 
2.43.0



