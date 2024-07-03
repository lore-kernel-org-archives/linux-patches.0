Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABFA1922DF;
	Wed,  3 Jul 2024 11:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005102; cv=none; b=kuMBfTUsBziipDyK7LAGzCxLss2WP/0sCzb5Ht2Coh6dxrFF3yAIL9BHHfMI6Z9Pq1pJJ42T8tk4E56MQhKJgFN0hK/QfFSMUrjXApnB21UVzJef9V11r0210wN8dmb1KyOUCW/yuzZ1Sh94AD4RU9bSApeoU/Fkfzk6JJvAha8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005102; c=relaxed/simple;
	bh=EXjCA15p8YYtNA4wpK7Mcgpcewz8KPabC9IJQUuCn3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yq7LHU8t9eezUGZuJ9HpXzvXE6FOoF55q0/zL6x/H0NzmA3o2sAFa0GkhdMYIJ6b546y3BQ/oIb0IHvXnU4r25tDC5sFouTENBLq2sORxD+XqDLQxt5SxYFIhc2jWAX95s6+cHEF2UAx/qPVrl3EKVaga/KCq3BpLDbHRnyqUxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyUjaRu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyUjaRu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306DAC2BD10;
	Wed,  3 Jul 2024 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005102;
	bh=EXjCA15p8YYtNA4wpK7Mcgpcewz8KPabC9IJQUuCn3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyUjaRu84U9DGqM1hRZRwcEqScn0J5hy3kb/6OvkibV3qNkupH/j7c/rE4fNVL7FY
	 OSJauVkFuCH5X3DUOR99Y4dyQ6h+bAGowWFnA1Hfs5qOG00Hwr1TeYP5eS48uHc2bW
	 epRxyjjL4t4tekURkOUUJkzdSoSWUHy/Opw0s7V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/290] mtd: partitions: redboot: Added conversion of operands to a larger type
Date: Wed,  3 Jul 2024 12:40:11 +0200
Message-ID: <20240703102912.842104625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



