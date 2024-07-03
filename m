Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CF86E5ED;
	Wed,  3 Jul 2024 11:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006060; cv=none; b=uOg69ulZgBHqMWa7lUkV2MPefNO7M2cAHqhxmUqJ8j1urPB8JLJe9antVNk9FtQUvH2mqP4wt1KNB5S3lKTACW1COhKJ1paq9AQrSDZ13Bx0ByWnybZx8lURkqRaRQFmffPE8+w7I0hMx03qReHJkDNep1rAOioFkAxTf0wgFEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006060; c=relaxed/simple;
	bh=NzEjiXdHHUudT0nVvS28kD1hZsPHUDQ7U9mVOQkg9+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibu4l5D0QCmHX8Fc3DxYUXWc0XhvPOKQl47Jz2JlJ5W358F5rdl+C5SLsud0sIknPweZVbP3gViZZ+5Xw3oBkuTuPSG1WE5nrZErxFA9vdt2wXU+mkwKWFkKPCEWk88WS5ytg8t8TL8mGQ9txUBMQsVwM6QldAKKm+JLG0Tg33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEYRnZKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEYRnZKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4007CC2BD10;
	Wed,  3 Jul 2024 11:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006060;
	bh=NzEjiXdHHUudT0nVvS28kD1hZsPHUDQ7U9mVOQkg9+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEYRnZKwHTpBIQA7OOxH8FdAApF5n3tOxD4K0KvAsfiW3iliFU2fvOZGShQIQGe7j
	 3iy5tS3pwjRs4v1ylZOK7ucJMWm6FDwnULBbpR5CWKacxWMRm2OE5QN2lOikSOdJv3
	 ZTelpFbOa0ztZoNInmooz10ICWukDFHkvSQ6Ie3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/356] mtd: partitions: redboot: Added conversion of operands to a larger type
Date: Wed,  3 Jul 2024 12:40:24 +0200
Message-ID: <20240703102924.015446232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit 1162bc2f8f5de7da23d18aa4b7fbd4e93c369c50 ]

The value of an arithmetic expression directory * master->erasesize is
subject to overflow due to a failure to cast operands to a larger data
type before perfroming arithmetic

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240315093758.20790-1-arefev@swemel.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/redboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/redboot.c b/drivers/mtd/parsers/redboot.c
index a16b42a885816..3b55b676ca6b9 100644
--- a/drivers/mtd/parsers/redboot.c
+++ b/drivers/mtd/parsers/redboot.c
@@ -102,7 +102,7 @@ static int parse_redboot_partitions(struct mtd_info *master,
 			offset -= master->erasesize;
 		}
 	} else {
-		offset = directory * master->erasesize;
+		offset = (unsigned long) directory * master->erasesize;
 		while (mtd_block_isbad(master, offset)) {
 			offset += master->erasesize;
 			if (offset == master->size)
-- 
2.43.0



