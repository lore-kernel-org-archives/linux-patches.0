Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C69B390609;
	Sat, 12 Sep 2026 19:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243099; cv=none; b=WxFPd1iZLeYg7zp/TvwfHrl3DaP5Bn7YkqJxrp0AoYdMqknNhAC9n19D2YzMjt1xb3gB1rIpHMml52Zqrk3T8d4hah+14dKGVwojAJZJo0Ep+kPEOoiCPzgiXBwcaoYzhZWfbim65nUKDvS5dJnw+u8Lht3CoDM9bmViz6RbrnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243099; c=relaxed/simple;
	bh=EvC1LXm8xiAew7sqYuCHgBplnEgAd7bzMvKZa3axJr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvQW0Waato4uX7oJFATRSD/qg1Zd54iJIxlnbEVXY+U+jIOXBwr+FtoyHCIqauD8+ZF8moe5xhzvrn1CA7gzI/+GlgkZPFdaQ1wvwQZYaO0/w3368d4TvIHNX8w6byHPyt5ZHHO5gFtnmbPOzpzsA9SHkOZyzUc2kMOVquW2Quk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEnUDOOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEnUDOOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D961F000FF;
	Sat, 12 Sep 2026 19:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243097;
	bh=EocEI2czxGOiKmZGNHAsQgNvoCng8amz9OYvih4Plew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zEnUDOOxKswbZf+OID+AT0e4jozv3hEwMb2i2oZXwIYGCif/6xMdNDfGM4E+h5LVt
	 6gLtvv/LubxTErCcgwWvfxO2NpbKXLAjrPZWEBC8a4HDwwltLQinyjSe+AC+DGzL8+
	 GIHwVa46UREDmK1FptN+YmSWg5WWi19KM0ddzT3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 635/798] mfd: iqs62x: Reject zero-length firmware records
Date: Sat, 12 Sep 2026 09:04:23 +0200
Message-ID: <20260912065531.676678420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 08ea045e0b82cbcadb7a2efc43a23561489a00f2 ]

struct iqs62x_fw_rec includes the first data byte in its fixed-size header,
so the parser advances by len - 1 bytes after that header. A zero len makes
the size_t cursor update move back by one byte, so the next record overlaps
the current record instead of following a valid declared extent.

Reject zero-length records and express the remaining-size check without an
offset addition.

Fixes: 4d9cf7df8d35 ("mfd: Add support for Azoteq IQS620A/621/622/624/625")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://lore.kernel.org/all/20260706091034.75865-1-pengpeng@iscas.ac.cn/
Link: https://patch.msgid.link/20260720115423.94994-1-pengpeng@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/iqs62x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/iqs62x.c b/drivers/mfd/iqs62x.c
index 761b4ef3a3810..1de464a8f1bcd 100644
--- a/drivers/mfd/iqs62x.c
+++ b/drivers/mfd/iqs62x.c
@@ -229,7 +229,7 @@ static int iqs62x_firmware_parse(struct iqs62x_core *iqs62x,
 		fw_rec = (struct iqs62x_fw_rec *)(fw->data + pos);
 		pos += sizeof(*fw_rec);
 
-		if (pos + fw_rec->len - 1 > fw->size) {
+		if (!fw_rec->len || fw_rec->len - 1 > fw->size - pos) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.53.0



