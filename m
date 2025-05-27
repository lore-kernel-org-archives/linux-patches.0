Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD45280304;
	Tue, 27 May 2025 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368459; cv=none; b=C4tQ2dGA89/w0vNtgZAd6bkGev4PBBr1ehpt6CwJIW0U0yo463ucFMFeJfLZZzTuXHfu5C9nEhO9+Vr2lmJDVs4JqODzheoiky5vk4aQo5u+cF3zkFT9MO1vjflrsMGhlJg0jSmbyWVpjMBEgVSxLYaxktFeDfKvWBMxozq2t28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368459; c=relaxed/simple;
	bh=kpIgzkrjgoeDFu+7mXYMuTH26MyTF/KSmfXghWPS8GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+yvOM/Qk/PpqkTeTo1gLpjGDBomwugW79MfaFIde9/Gj7etNdh5IaP5FJHhAZUFYXnHPD0g7sCpuMSTKwshjcRwCi2w3jqbVrSScLbGG1Iqm15tbYKse8oV9gMeImDMLUONNvDYbJJzo8rXXAOtDWKPIBSPio6xQyESWV3Fq88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFdghsKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFdghsKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF880C4CEE9;
	Tue, 27 May 2025 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368459;
	bh=kpIgzkrjgoeDFu+7mXYMuTH26MyTF/KSmfXghWPS8GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFdghsKNlChAEl8pnSY3PS/ntnOUSBvMby7a37T85PNV7kJaKdLVsPdlxjzitpWBn
	 Oh5wqlySahXqHa73gfXJpFMRPKIDA/9ezFrnMjRp/wfMq0z0Fea8v+VNI8AnILwEmX
	 kdqs2wGblthFyIyUo7fB1B6D3uZXEY/R0wecyxHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hesse <mail@eworm.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 706/783] loop: dont require ->write_iter for writable files in loop_configure
Date: Tue, 27 May 2025 18:28:23 +0200
Message-ID: <20250527162541.870153995@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 355341e4359b2d5edf0ed5e117f7e9e7a0a5dac0 ]

Block devices can be opened read-write even if they can't be written to
for historic reasons.  Remove the check requiring file->f_op->write_iter
when the block devices was opened in loop_configure. The call to
loop_check_backing_file just below ensures the ->write_iter is present
for backing files opened for writing, which is the only check that is
actually needed.

Fixes: f5c84eff634b ("loop: Add sanity check for read/write_iter")
Reported-by: Christian Hesse <mail@eworm.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250520135420.1177312-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f68f86e9cb716..0b135d1ca25ea 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -973,9 +973,6 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	if (!file)
 		return -EBADF;
 
-	if ((mode & BLK_OPEN_WRITE) && !file->f_op->write_iter)
-		return -EINVAL;
-
 	error = loop_check_backing_file(file);
 	if (error)
 		return error;
-- 
2.39.5



