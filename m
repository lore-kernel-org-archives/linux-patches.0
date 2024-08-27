Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E8418039;
	Tue, 27 Aug 2024 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772607; cv=none; b=OC5uScpZqDop3F1aRW8r7rqwv61KfM2jA6aydNtMWPtix7nA7CMiZahvyWLHna+83z7RLYQdSef5/THSFprMf3MyYJSBswypXanSJ+QDsHyp1Dt8+okBnvdzPD1X4mOnFsqS7WtP4Tn1zZr+S4wWGMG/0Y514H2TKniTl+PHxNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772607; c=relaxed/simple;
	bh=mEGeoVjVYdaXQVP1xsWipKW9KsxOhby4bxe8tIB+HI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEl8+zNjoUVLtcVhR78qCN5z0Tl+pYl80RVlco09xfGQL5kXoa1WwjPSNk+h15NuCRwuVQJA2lPXWm63r2vbu0UCmVPEroZMMl+1xIuZa/Av54VF4EJZpsMe1idD6pfENl8WnpXxcVXc33LY2/I7lxd7w2U9NygzpEIkVNY6m9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgJsR15l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgJsR15l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0911BC4AF15;
	Tue, 27 Aug 2024 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772607;
	bh=mEGeoVjVYdaXQVP1xsWipKW9KsxOhby4bxe8tIB+HI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgJsR15l7sOh+xzupdCuGRNM8Aumrt4iv5wX+3hupL8FIQg4M5HZOZE0pZPeD04hb
	 9SbVrlXcslkSRjMWhWCJVh+Uw6CBq4pp3uf2Xz+vrdHhAZ/Vmz2zDZBk9zx+jW+6BN
	 hDPhEggrXgOQJwpC+OJ+HAxpVxjcIokuGMZ+aiAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 264/321] scsi: core: Fix the return value of scsi_logical_block_count()
Date: Tue, 27 Aug 2024 16:39:32 +0200
Message-ID: <20240827143848.298208824@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -228,7 +228,7 @@ static inline sector_t scsi_get_lba(stru
 
 static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
 {
-	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
+	unsigned int shift = ilog2(scmd->device->sector_size);
 
 	return blk_rq_bytes(scsi_cmd_to_rq(scmd)) >> shift;
 }


