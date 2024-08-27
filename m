Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5920C1E487;
	Tue, 27 Aug 2024 14:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770762; cv=none; b=kJlfkrWtyITiM1FOJ3Adqnr3f2RgSglfw1SnTulf28Eygh8w7DonRb/ReKxD9hL2G8rWdya2M324OYgNGmPjYxXK4+jFT9++5iuNigHF9ntYkr7Ju36oQXs4pLnqCcqfIWQHBciNrcaW01dcvTuqwdu+WSbJYf2zBWgumn9SfCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770762; c=relaxed/simple;
	bh=8ioMCcEUOusC0EciMTuglR1j1hi0e4Mj0/e8M0pOzPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2yuGn2EmI0emUJ1+4fBv2YoG9QfAROup6LacPOreBjtzCCa5qVFyFGGp94G4EaLe3ZgBZqOfLlCzUtwi14Y3rDiLKliAcJdi6OH1DnY8nPB/dY/P1gckHDPFcBLwNWFRZZTpauoKhw+yy2dWWr9uYnfsrO4FOgOJsN8EKRbP3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLlh8Zl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLlh8Zl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BFBC61044;
	Tue, 27 Aug 2024 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770762;
	bh=8ioMCcEUOusC0EciMTuglR1j1hi0e4Mj0/e8M0pOzPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLlh8Zl4RsSiFtyK0vIZpG2XxRM+3XztZ9JgiCF0bd+AsT9iw5bjJLtsjAo7S8aVq
	 44TvlLaHz66L40rkEoRN+tfR98XhxoKetdWJ5RFiDyvZLBe7e9F+qAVd9Zij7G+e5v
	 75m/j6yeYnc7NRTSoE6nbNY5zK2Q5LGA1Ri1ss7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 295/341] scsi: core: Fix the return value of scsi_logical_block_count()
Date: Tue, 27 Aug 2024 16:38:46 +0200
Message-ID: <20240827143854.620173514@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


