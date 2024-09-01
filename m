Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F55381BD;
	Sun,  1 Sep 2024 17:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210341; cv=none; b=idkuuYQAsANTvK5zbYQuazEkUTt5NLy5GejdkrdlE0Hmap5sZNZ3quTU4EKc9TsEHqbVe9U+p6RkJpoNdPrNb46YKHCC9ZIKWxn+E8gWJGs8ahgo/CmysOgZZEBGgIHu8oPOjSq1ZbAGwBq/7kOOlkTziIj2FsV7gqPDLPPoiSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210341; c=relaxed/simple;
	bh=/Qw7ofdn2XQtF8WvJJhS7hTFf82zpBbPjAfJSABynHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxbS3z9rTcrnQauelXFkuEPRqMtWDWYsybwKEbeSIy33wHMK7QcUOiAqTW6R0eawqMcFVKNxUTccwBonaCAokaokgiGvojHIO7Sb6cRtqwEtJBeV13eihdkhncscGcWi2UsE0ijqVKb5U63o/q8q5zD7gvPHrF7EeXlNs1N+UbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=petr3gi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="petr3gi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4B1C4CEC3;
	Sun,  1 Sep 2024 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210341;
	bh=/Qw7ofdn2XQtF8WvJJhS7hTFf82zpBbPjAfJSABynHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=petr3gi7TixAffMHXW29OMLst7eF712/2cGJF0jgTZYMUNZIh3XY84bP5LCkPs7vV
	 FmAayuL6ulkF3hNokU9B5CDY2HCEXCKqiVEKKwDOuV8gZEMb8dDRtZ+3OUPpcECd0d
	 zAVLduP4GdYP0O9p5EpiXkjv8YLqaSeHXDFc6GmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 160/215] scsi: core: Fix the return value of scsi_logical_block_count()
Date: Sun,  1 Sep 2024 18:17:52 +0200
Message-ID: <20240901160829.409217340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaotian Jing <chaotian.jing@mediatek.com>

commit f03e94f23b04c2b71c0044c1534921b3975ef10c upstream.

scsi_logical_block_count() should return the block count of a given SCSI
command. The original implementation ended up shifting twice, leading to an
incorrect count being returned. Fix the conversion between bytes and
logical blocks.

Cc: stable@vger.kernel.org
Fixes: 6a20e21ae1e2 ("scsi: core: Add helper to return number of logical blocks in a request")
Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Link: https://lore.kernel.org/r/20240813053534.7720-1-chaotian.jing@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/scsi/scsi_cmnd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -247,7 +247,7 @@ static inline sector_t scsi_get_lba(stru
 
 static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
 {
-	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
+	unsigned int shift = ilog2(scmd->device->sector_size);
 
 	return blk_rq_bytes(scsi_cmd_to_rq(scmd)) >> shift;
 }


