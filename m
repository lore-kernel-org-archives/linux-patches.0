Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE72187540;
	Wed,  3 Jul 2024 10:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004184; cv=none; b=F0c7T0lryFZn/1XHHdTf/TwPy/PUXxUihg75Ed9RtiNHLbOc4IqkRTkyavyaG5yF9/8e0vpARPOOgRJvEioN2B0V3biExOZBPvP4r9P92z6iBags5l7xVbF12QXkrGUOjO2K67YAIVZHk7FOqiGNgirZRnf1REjbQnRbbWdLNak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004184; c=relaxed/simple;
	bh=3zEdCE4RlrGh6IqdflXxI7jg8QLIdap3nuj/y/aNFZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLeDgTKGsntxilZu68bBPtBvSCWWEj8RqUz85VKdTA9QH3Gck/ZQn75R4C1fcVJhHPlyDxSFhRtBLDj9+g3/pN1oAdja9rqmHEzRY9aNLh2niftZTbxQqksR0FE2YsffXJk7INi12YuxXZl5pzTOujVDnU9Gfts4jcvKM+eTkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8QbK3cg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8QbK3cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17894C32781;
	Wed,  3 Jul 2024 10:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004184;
	bh=3zEdCE4RlrGh6IqdflXxI7jg8QLIdap3nuj/y/aNFZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8QbK3cgksmk7Yucy7IHi93pBmETrJN5NsN1g7jW9dfC4iKav9HThvQos9FPlgTR5
	 VqNV1nZPxg6XqJpDdT1gPcmKvQrX/2L21unRiekPBQ+y4hlaibpOhCsTs392VTSNRt
	 i73oVoW3rk8LBiUsmpZ+ARxI2OdIMWkgmv3Af7wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/189] mtd: partitions: redboot: Added conversion of operands to a larger type
Date: Wed,  3 Jul 2024 12:40:09 +0200
Message-ID: <20240703102847.060960838@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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
index 4f3bcc59a6385..3351be6514732 100644
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



