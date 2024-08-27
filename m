Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DC91BD514;
	Tue, 27 Aug 2024 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771558; cv=none; b=fcPS1ny2C5T5HH55h67Ut6XJI1cWa+WQmu07b0SrhVJmQ9SBfAf5DUWdteIbS6SALc6KjeXa9Fr+cYP+MvU3WOjl/9EvXjnOOt6d5GqM5150m4uekdipfWvrn99RFExzSYgucIayEQSGvux8Q9+JMK2sjo1ReXCAX5B4szfXzs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771558; c=relaxed/simple;
	bh=8o5W3h52bsCHvHnt0qFUDVx5YBmhbS7hEM7Q9TLjhkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VH3g5Hw1pE4yjobslolrfNDmAxqeXUNDekXQrLt+7Lp+jKohOuqSoOfNcxv2Grf2rIBFZf/CJCAF1SATEJI87prJTBc7bkHLlHGWN0yVaW3lcQD57/2F6ztK4mLKXFooWFOoPvgi3o1Pc3Z6J0t2zHRu9MJ3OcoiLynb0xGTVR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGw5ShQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGw5ShQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676FCC61042;
	Tue, 27 Aug 2024 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771557;
	bh=8o5W3h52bsCHvHnt0qFUDVx5YBmhbS7hEM7Q9TLjhkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGw5ShQ+crixpHrUtJyI9xwf4CkX3xeT+jZfJRNTcgVK9wjHGKBDcIZaXCz7KvT+r
	 r8HsWWbT4PvuHoJD/ezKWYt1+oN474sLuC4ppIrtB+87ITtwxqo246v95jO8XXXC4R
	 U4tCj52nLGN2bNFpZlahXrFwTSXReqs3DH1hnznE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 224/273] scsi: core: Fix the return value of scsi_logical_block_count()
Date: Tue, 27 Aug 2024 16:39:08 +0200
Message-ID: <20240827143841.929332131@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -234,7 +234,7 @@ static inline sector_t scsi_get_lba(stru
 
 static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
 {
-	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
+	unsigned int shift = ilog2(scmd->device->sector_size);
 
 	return blk_rq_bytes(scsi_cmd_to_rq(scmd)) >> shift;
 }


