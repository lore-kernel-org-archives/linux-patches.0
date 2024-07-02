Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDDC1B583A;
	Tue,  2 Jul 2024 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940860; cv=none; b=mNnT38Qgao3ZZzcOObjBRa6nFmdDDnSll1IiYMgDHDGxeQIwjWrnVgn87E9RpA2D62Z3/xnBfuWkGAAMDAoiznvSDlqbSad7Kx4X9ZKKLcOup2pJF8yT8dy1QAZiVDVDGh8lKXIKxT0xxwj5YBZ1AXCYp5ozUGXOKLawntoV2Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940860; c=relaxed/simple;
	bh=U1a2wtliN/+DlJiI1XInp1XtDshL9OXE6tyWMeTIlio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/ZEU8X7PfnqJnxYbU8MbloHfWDRQ3cD6MdssTf9poJM3RZPnDoLMdpBBkwhrNhEGPecW7iI3DNYZxT9JrAu1FAKqkqTr+ibg25M+HuaEuNTg6krmsxfDbjuf/M2QKV+qeKzzzbWOQa+6Ski+c4K+oVZbRJvh6xmRUBaJleDrNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI6e5QKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI6e5QKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3956C116B1;
	Tue,  2 Jul 2024 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940860;
	bh=U1a2wtliN/+DlJiI1XInp1XtDshL9OXE6tyWMeTIlio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fI6e5QKQBR+zF9qkmU4AWcjGA9GpOPK0WsB10Yk4O0b6hefEfomi7VVextwg2jIfJ
	 NOco49aV4NuAwKVGgAfljIFnESkowHr0Xxmdw7ncyWaKKpf5vy7nTxal+kV1JOwhS0
	 DqT4b8Q3kmFcYhVz0L5sKDRpdpf/KYo368MfYScM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/163] mtd: partitions: redboot: Added conversion of operands to a larger type
Date: Tue,  2 Jul 2024 19:02:51 +0200
Message-ID: <20240702170235.222094351@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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



