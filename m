Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BF215218A;
	Tue,  2 Jul 2024 17:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940174; cv=none; b=kHHkKQ2ByeuaLDrADg6G3OLNdCDJELloQ1CwBFoi3Q4A81mDfEzmBEqmxmt2QG8Ansfli8AYP3TW4HdVAzz3o/XWq9v9iHWF/fPFY5CQs6vCZ2ACRoM6HoSkD7JRqUMSeMlcFejZGCS6sdSDMjlBow9T8exUkarBY3D3YOpGoIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940174; c=relaxed/simple;
	bh=2RJIYhKxq1E5ghkpn+da3P7Q/Vl+Jsp5CbZ7EaMte38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYcTjyPGq5AcmnMJGmaB4CWvgxxaLNeqtDHcgPgLGfHqQcS+BO4Y4HC4eMLBMd2Au8tRT0IAFHwcIu9AX42cbYKM0ppU2DeG7IUhfiy4GajkC3LntmzhDjLXc/qKrdc0GaPMwRUQ6VG7Mzmwg3rKasOAf4ZOSyST239jaEapr9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUakiJs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUakiJs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAC9C116B1;
	Tue,  2 Jul 2024 17:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940173;
	bh=2RJIYhKxq1E5ghkpn+da3P7Q/Vl+Jsp5CbZ7EaMte38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUakiJs6VDGGV2eWLOoW1d1yqplNL3Z6jcQCEIuDKWh2eu2+vFPRzdoDqsqZW/wNX
	 4g6eo0IVo5hYGjD+Gi1lVpnM/Bt2Bop3Y8PDtFrKNDfODfp5+zmLUQ53bCOh4xzx0E
	 uPR14jU4QIBsq7+qogPcZkqNdrLbSEZx8PyLdBc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 074/222] mtd: partitions: redboot: Added conversion of operands to a larger type
Date: Tue,  2 Jul 2024 19:01:52 +0200
Message-ID: <20240702170246.809547689@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



