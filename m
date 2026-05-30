Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5008630E847;
	Sat, 30 May 2026 17:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161774; cv=none; b=p0z6Y3eCCOoZOzb7fapwIvQEUVg967JkZIfwGZUjR11vDHTQkvPoFhbEt5KhQu0E/RtRyW/bw61gxKg+NJRm6N/cFuaUR0zqK8ZFn8g+oInneuR8fCGuadt2rP/5JLwtxspJwuZb13/IG+N4j6i2ZwPavPCwoReDOPYofncLH5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161774; c=relaxed/simple;
	bh=cRc740wbwLMXHLtBssQe4C4yO6HT0P6lyiBKg8tGN/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9ukBO3LoD1tlv2CSxKMR2cG8s29NvjHyeAOXFfwq2TbCUxTEC6idUozPEwFdtLWpJRFX8uHlkX99kBGPxVW65oVHfqn/QTjKiQ6lAInZxCA+9WjfCCmpxorOGniYnpbFLgbqwcl8KxcXcgLvmdoOu5VaYX/BimZklX0ZDOxHbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+C5wRZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+C5wRZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6CC1F00893;
	Sat, 30 May 2026 17:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161773;
	bh=u+xMBxj8CxKAKawbUv9zIjs3zW9TZdvPGbVSBHS7/hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+C5wRZhfui6Je+w2+8Sc9TJnj9TtZAE0fxSpBVatLOp0KxEhPjWiHSQHTP2MGn21
	 BU3rgiyJ1gBvuz0R6/wRf1IPV36HetZ6x9RNOmGIcFoMK2mm+x5AfNGCtoN3by8gmM
	 yZxf6rnx3EWbpaY/uCiIk0n1UtVt4r9pNXD3PoPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bae Yeonju <iwasbaeyz@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 722/969] fs/adfs: validate nzones in adfs_validate_bblk()
Date: Sat, 30 May 2026 18:04:06 +0200
Message-ID: <20260530160320.476272973@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bae Yeonju <iwasbaeyz@gmail.com>

[ Upstream commit dd9d3e16c2d5fa166e13dce07413be51f42c8f5d ]

Reject ADFS disc records with a zero zone count during boot block
validation, before the disc record is used.

When nzones is 0, adfs_read_map() passes it to kmalloc_array(0, ...)
which returns ZERO_SIZE_PTR, and adfs_map_layout() then writes to
dm[-1], causing an out-of-bounds write before the allocated buffer.

adfs_validate_dr0() already rejects nzones != 1 for old-format
images.  Add the equivalent check to adfs_validate_bblk() for
new-format images so that a crafted image with nzones == 0 is
rejected at probe time.

Found by syzkaller.

Fixes: f6f14a0d71b0 ("fs/adfs: map: move map-specific sb initialisation to map.c")
Signed-off-by: Bae Yeonju <iwasbaeyz@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/adfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index e8bfc38239cd5..76e37c6d4cad4 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -343,6 +343,9 @@ static int adfs_validate_bblk(struct super_block *sb, struct buffer_head *bh,
 	if (adfs_checkdiscrecord(dr))
 		return -EILSEQ;
 
+	if ((dr->nzones | dr->nzones_high << 8) == 0)
+		return -EILSEQ;
+
 	*drp = dr;
 	return 0;
 }
-- 
2.53.0



