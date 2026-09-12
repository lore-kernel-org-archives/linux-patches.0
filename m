Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4543093A6;
	Sat, 12 Sep 2026 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223449; cv=none; b=Bn68oHsynn2RkAugq/y7S3OeHfcmcDaGsTt4qfC/qTR/OEb0qq9DCVyAqOBg2FQUxe21ZIv4eqFuQO74qPDg1I4ss/bmlzpcxX7+1HzvgJnBL4f3iFC7ReqYsqjD6MAgARsZCXryTBe58U7S84NdHqPPVMOnnbKBSZoWfY5Vny0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223449; c=relaxed/simple;
	bh=G7mN6bQFgdMVSQxt5V3YzqjiHZSQkcF7dNK+pVKWhBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7Yr57P216S6fIy/qZWHMMeQE6k5eZQ3P6nljdQuY7SSya+C6+jWlvAu21obh5rnq5ud1/1LdBHlH++aSM3cIN3kPZ1iIO/ajK4J/FEs6Qf41Ll8rb1AAgKm5NVT7om6dpRxbTrRlJ60EbwZGZftimEgm7yDsaZkHmcyk3HI7Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psiG9bdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psiG9bdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593E71F000FF;
	Sat, 12 Sep 2026 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223448;
	bh=3RnyR80r4YO796CeDpiQn+EG7wwB2FDAP9fji9Eknac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psiG9bdyS/YaN8aMQtS3IrRh8Y4J4uXDqkbr9jD9QtwEg7Hyx5oY1/OghO9du3Qq7
	 KO5zxg3vkLwrJotYhnLR5f/E1Mfnfj05decCtXrQ27+9pnbqRFT2D9ML9vK9In89Qp
	 wNp5Q5CGHFcNiLU0wWMypqzlBPKftz3X/e6QbLzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0792/1424] UDF symlink pathComponent header OOB read
Date: Sat, 12 Sep 2026 08:53:44 +0200
Message-ID: <20260912065625.035186010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit d23eb7380d1594cda31a5dc8487dd2a5c8def8c7 ]

udf_symlink_filler() can enter udf_pc_to_char() with a partial pathComponent header.

Validate that enough input remains for a complete pathComponent header
before accessing it. Reject malformed symlink data that would otherwise
make udf_pc_to_char() perform an out-of-bounds read.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Link: https://patch.msgid.link/20260717104722.41446-1-david.lee@trailofbits.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/symlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index f7eaf7b145940..ee78403bf7c9d 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -36,6 +36,8 @@ static int udf_pc_to_char(struct super_block *sb, unsigned char *from,
 	/* Reserve one byte for terminating \0 */
 	tolen--;
 	while (elen < fromlen) {
+		if (fromlen - elen < sizeof(struct pathComponent))
+			return -EIO;
 		pc = (struct pathComponent *)(from + elen);
 		elen += sizeof(struct pathComponent);
 		switch (pc->componentType) {
-- 
2.53.0



