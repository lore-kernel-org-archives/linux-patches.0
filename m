Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11DC21883E;
	Sat, 12 Sep 2026 12:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217410; cv=none; b=Furc0z8OSuvU9zPc+xyXL+Pm278Eq2w6k9RL3TyKdcqQKxZb5l85vf8WqJuzQLwJSJwICqK8WT3HK8H2QN2eM9pmzUkHeCCfO/E3Ytw1MmXh6gnCp5/Anat64WBUNzgA1DH70YMMaSckIp5dKRR75OkomPr3YPBzYsBK88QYtSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217410; c=relaxed/simple;
	bh=xEommNnUk/wecccKWQu6fLI88aINhlqeACbAHTioFGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGrzjDd8ZT7VJ2oY+n3+5lkv4CTyb9CHmIEL4TdKQbjsWyQOws8aElmYWJDo8E+JtTv91CyVcvCFIXUisjcmJXfUwVHd7Lurz3Y7OqXtkF4yGFTk+kz/V0C7CNCCZQ1UvyzFs0JTPuk41WvLXD/KDmHxgXetIBVNv2ep9L+xvLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8ONp8WF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8ONp8WF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4131F000FF;
	Sat, 12 Sep 2026 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217409;
	bh=wsVf0GyrV7rOpJzGaT8z3O6STPDyLsJcUm18Yod2tus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8ONp8WFTDHb+9RB3N8LTozDFvWIK+etCaQM2i9Drvj2axfb8wD9RR2/5S6QmVgRs
	 10Q/eu2EEnfMr8VOO1xRT36bQ3Mt/inDYF+jWYpKhvVr0T7CUMy6XkMczbaEw4T3dR
	 2m2RgS7yKaesI2dXRtEeQYndnZnN581aFntg6HaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0936/1376] mfd: iqs62x: Reject zero-length firmware records
Date: Sat, 12 Sep 2026 08:56:02 +0200
Message-ID: <20260912065628.423069061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



