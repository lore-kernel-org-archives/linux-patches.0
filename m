Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F706414A0C;
	Sat, 12 Sep 2026 08:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202200; cv=none; b=u9sVKoBAlsUV4AVZ6PYu9y9ZjEpl4yMmkPMlAp1y4MFqbvuKAJ9koMfrjDakmRB/Gffy0mWpcZ1nWieY26d8rKd/DTb4V1BanbbDbbp6rCRmpZJqZDUiuts4hTUQZ1CivtfWuz9xfhoUuI7KrWqlmSlFwDvebWxZJBdmuuyna7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202200; c=relaxed/simple;
	bh=Zc13SMefLcDcNJ9BgoN7LEvImTSQaCncXXwKWIzeTHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnKtkJlmr5gZJCKEapRNsGCAOwXGRBaYmpBP233JkPu1t9Tc4z4tKRRj/Ff9bXulNu0dywoOeC2Lq3ApeE3z0LJ97nCpX5aDiADWKwhDfO5T8XjeOhPhuNbNW6FK+V0D7qXkjUoJunJlj/aoy+F7fOYbV5vssyrA/jwyewOLHLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUGfZ3c5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUGfZ3c5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79C61F000FF;
	Sat, 12 Sep 2026 08:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202197;
	bh=1Ea05HgFvFItxXlofhUt0W+Iqs5ZLm6QWcVygwnN4GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUGfZ3c5CaLgVPt+gZ1CeJCj1a3oEzSoHZ0bU+VCD/Scg+Zgltofg5JVgyoG9y0Ty
	 GydYp3NHvGPj9VLrxqeIlb0N9C2FzQQlKwOQS2wM/4bsroY1LZgJUowyVJAMYSht1t
	 8ve5jkjw6PxMN12C7usoorGV7P4i+qpF1qDnh6vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1154/1815] mfd: iqs62x: Reject zero-length firmware records
Date: Sat, 12 Sep 2026 08:48:24 +0200
Message-ID: <20260912065716.104127453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ee017617d1d1b..412ae7777f729 100644
--- a/drivers/mfd/iqs62x.c
+++ b/drivers/mfd/iqs62x.c
@@ -237,7 +237,7 @@ static int iqs62x_firmware_parse(struct iqs62x_core *iqs62x,
 		fw_rec = (struct iqs62x_fw_rec *)(fw->data + pos);
 		pos += sizeof(*fw_rec);
 
-		if (pos + fw_rec->len - 1 > fw->size) {
+		if (!fw_rec->len || fw_rec->len - 1 > fw->size - pos) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.53.0



