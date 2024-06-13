Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E23143C7E;
	Thu, 13 Jun 2024 11:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279844; cv=none; b=TJVuUD8PNTlphN/2eVe/pRLF7fc1RidJYdnuBJZ+XmXne8PpoFz/6iN+k9Ks37NlM5Uy/n3JM4s3Z1NpZPio+y6IvjNCBuiIfq/9LIjPqfD8BfjpK12kVgTYon4tQ6oyq1M4gpOZ5BWjZ0D1x8mAfF2MCiJ8ph9by/9nkaVkTfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279844; c=relaxed/simple;
	bh=1wDhBlEWu0vIEJQZELIayosyshRi8lViiKWpQmkEPeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSEvCIimTena0dkNTucoLEXvDPDGePjrAt994UGDPqLb6bNrCI5ptlk1l0SxAB86uutPlLrIPBeDVK1Acnf9u/Rjs9frH1PJWtfp/XamMtcrB7W3oFXFjHHb1hlKcdwtOXukDOVXYsxX8lr+ZipcYbvvfG4R3ybVJH8Mmfk7b/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArWpcPU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArWpcPU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDFEC2BBFC;
	Thu, 13 Jun 2024 11:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279844;
	bh=1wDhBlEWu0vIEJQZELIayosyshRi8lViiKWpQmkEPeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArWpcPU99hNqxrFhwa7vn5yi3tEPfPDgG3vPQhsywygQAykMy31wfYo+zmF8DWt9q
	 f6hCDrIJgAcirqQmQ2Yp6p99blB4gMAqhQw74aLPD98SpmnyDt8okcyC8RJf6ME6a/
	 ahse0v8FcHr0jte5lsbAk93GcL2Osolb/ryAOPCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/202] null_blk: Fix missing mutex_destroy() at module removal
Date: Thu, 13 Jun 2024 13:32:03 +0200
Message-ID: <20240613113228.740926303@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 07d1b99825f40f9c0d93e6b99d79a08d0717bac1 ]

When a mutex lock is not used any more, the function mutex_destroy
should be called to mark the mutex lock uninitialized.

Fixes: f2298c0403b0 ("null_blk: multi queue aware block test driver")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20240425171635.4227-1-yanjun.zhu@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 6cbdd8a691d2b..b6210bf0724d5 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1868,6 +1868,8 @@ static void __exit null_exit(void)
 
 	if (g_queue_mode == NULL_Q_MQ && shared_tags)
 		blk_mq_free_tag_set(&tag_set);
+
+	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.43.0



