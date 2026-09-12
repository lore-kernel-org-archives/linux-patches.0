Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB29C3AFAEA;
	Sat, 12 Sep 2026 19:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239952; cv=none; b=YqgMTGIoLlmFkplsWJ7ZjMKQXD7vAVrORNDa3OIWggZ0q7Ckl1vkw8Y25QZ2OK3yOMeBL5A+kHEghHXFs0Y2JVxQ3ReEjsybBYEFSpbm+0zYQxuORgMC5Od1nGXKKpM40S6mAip6rx1/HpIijuRVgRkBIV/4NcZ3C50uq++y6Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239952; c=relaxed/simple;
	bh=FVUY1nT20fD+gRXYi0ApCC4kV4/fJZtdpmBWEYbHVzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQBaAcJvTRCnD1GhV4iebAdaYaAnn6pmiOA/Cii8XbYAeH3X1K8WxqbP2tVJRndm40BF8eJ8gXqSqnkVmB7wBXq+wWk6TYr9bUXy65o2LYqWsqEiRfV8a0KvE3/Nfo5iTPE16zMuIJT6h0/unrdk7Qzyl4s6yGAtXKUQGKDMvhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ex4FWOu6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ex4FWOu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17C41F000FF;
	Sat, 12 Sep 2026 19:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239951;
	bh=hIgrVVX/QOz2829dAGfoiJyt/5m2/q7jigtOQs2fDLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ex4FWOu6S72YA1e5iuPrJsmJT9zC3kVQYCTTuGmCgG0Pmzx9eAQdL0EMumujXgPaJ
	 6Hk3lep9Fw4TXzHob6UnpROA319IRfYchTmielQhf3JrqQpmvpQ0aIgox7P6Ls/FJP
	 P6Zknh1CiVpxe068/xIK5+ui16Dh8SjtQdvFE7i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 726/935] mfd: iqs62x: Reject zero-length firmware records
Date: Sat, 12 Sep 2026 09:02:36 +0200
Message-ID: <20260912065543.484212876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9805cf1912453..640eb7b234c03 100644
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



