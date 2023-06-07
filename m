Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123D63AE5C
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8477EC433D2;
	Wed,  7 Jun 2023 20:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169849;
	bh=l9k4Ba504JrgNcKDbap2cFVJnlwBTOvIBPAi0WF8Q9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+MNaF+wBjtiRw6PbiiVu+nJ+kqCl61U7/fuMMO6Aq4jbyZ+tBinzmkfIsqlbRC6R
	 WLoHeWhhKb4HU7KRh7YAXBExwTl9kNF7PKb/5SC3DvfOxFZKkrv15AVOWUodXT8dhv
	 55VOpnr6b233kyoj1R9kctXZOZsGds73jmixcvG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 238/286] btrfs: call btrfs_orig_bbio_end_io in btrfs_end_bio_work
Date: Wed,  7 Jun 2023 22:15:37 +0200
Message-ID: <20230607200931.070368575@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ Upstream commit 45c2f36871955b51b4ce083c447388d8c72d6b91 ]

When I implemented the storage layer bio splitting, I was under the
assumption that we'll never split metadata bios.  But Qu reminded me that
this can actually happen with very old file systems with unaligned
metadata chunks and RAID0.

I still haven't seen such a case in practice, but we better handled this
case, especially as it is fairly easily to do not calling the ->end_іo
method directly in btrfs_end_io_work, and using the proper
btrfs_orig_bbio_end_io helper instead.

In addition to the old file system with unaligned metadata chunks case
documented in the commit log, the combination of the new scrub code
with Johannes pending raid-stripe-tree also triggers this case.  We
spent some time debugging it and found that this patch solves
the problem.

Fixes: 103c19723c80 ("btrfs: split the bio submission path into a separate file")
CC: stable@vger.kernel.org # 6.3+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 726592868e9c5..ada899613486a 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -307,7 +307,7 @@ static void btrfs_end_bio_work(struct work_struct *work)
 
 	/* Metadata reads are checked and repaired by the submitter. */
 	if (bbio->bio.bi_opf & REQ_META)
-		bbio->end_io(bbio);
+		btrfs_orig_bbio_end_io(bbio);
 	else
 		btrfs_check_read_bio(bbio, bbio->bio.bi_private);
 }
-- 
2.39.2



