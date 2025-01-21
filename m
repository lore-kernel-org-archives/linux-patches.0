Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC4A1F55E3;
	Tue, 21 Jan 2025 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482105; cv=none; b=unl+hP78ZgezqNNiNaiy+hPSid6H+RHrFutcgruOi+tcuSfudToIPkXASaWLHQj6KxiU2sncpCukcB//fOoydLnCNW4nMp3Tleu37mCTzIFeHWdEd7oEm9AQUR3wJqqe0ifVY3GXO+u6Xg0scFQ1bAJyiDnMJgynx7NVrssAHqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482105; c=relaxed/simple;
	bh=Gf8/PfrpdDtwhyMK0PTWq7pTdRb8llqqaTJ1WE/gKIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQx5jeOkSbvvHjinHaZ7MVaJv5yFQ7q0OzkXrjviYZPnPZW8XGe+MtW9W18VzSzGqVBtJ7i6y6wlk9LlK8QZ0yPC+Rg4zqCRDVrXQidmxiN+sHHT/Jfcbp3jviD6PfPsFhhyDE3hNPOY9DOvqTHoUXivtHTr4rwme0VbYcvdJuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGmwdNoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGmwdNoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0B5C4CEDF;
	Tue, 21 Jan 2025 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482104;
	bh=Gf8/PfrpdDtwhyMK0PTWq7pTdRb8llqqaTJ1WE/gKIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGmwdNoEbkXjJB+ngNXZPvcF19H6ko17yQ1E/d/ub6av76aRQA1znwnRuv2AeT8Ah
	 LjBcTJKSW0cJl5ozl80R5MMRZTBAvN7Q+IuBPDZab8w6bkOfpdZMrGQCmLYsAbNSXS
	 bKqNxOR0Scedqirb/ekVRfjIbl66ZZntSHS44dcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 36/72] nvmet: propagate npwg topology
Date: Tue, 21 Jan 2025 18:52:02 +0100
Message-ID: <20250121174524.814808803@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit b579d6fdc3a9149bb4d2b3133cc0767130ed13e6 ]

Ensure we propagate npwg to the target as well instead
of assuming its the same logical blocks per physical block.

This ensures devices with large IUs information properly
propagated on the target.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 468833675cc94..c0b342cc93db3 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -36,7 +36,7 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	 */
 	id->nsfeat |= 1 << 4;
 	/* NPWG = Namespace Preferred Write Granularity. 0's based */
-	id->npwg = lpp0b;
+	id->npwg = to0based(bdev_io_min(bdev) / bdev_logical_block_size(bdev));
 	/* NPWA = Namespace Preferred Write Alignment. 0's based */
 	id->npwa = id->npwg;
 	/* NPDG = Namespace Preferred Deallocate Granularity. 0's based */
-- 
2.39.5



