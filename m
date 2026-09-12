Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D97372EF0;
	Sat, 12 Sep 2026 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230966; cv=none; b=B8nB+gvnqCkg8xsIKqHV6LuLiNUpKpbOqDVm5mRK2gy3nNQuXghI5zMPlj/jzIcp0zrxBAACg2VvuwurcOZq2zX4num0ugaRnprOmFs7pBqR2wRveJHGyrvnm6D2VX5YR/6VSwSfOIzRXfWkuwSyiQI3bhO2FLXAl6KfM7WMbw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230966; c=relaxed/simple;
	bh=BlwBTnA1X1vQV3UgWcQlKWalggLenT2i4wC+MWYHvKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4ZR3FawrRCY4jxNwkFw0f+dSfHIV+pmpbdfaHLWXbFWmoZmc2Iue+q2BbuVum9/lpSmENd+E+w2x/vp6aHx7dIghHFp6NubMjoZB2hpzNhdznyfCEJ/hb4FhEnTbWbBw1MTHN7Q9d0BqHYaUC+Zw8+/r3nGOgxERVMgc+KHb2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GELK78Dq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GELK78Dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A334C1F00893;
	Sat, 12 Sep 2026 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230964;
	bh=WsSQA1+Wm9VtPUkICRHKP04XiM2hLqOZczqlRCHloRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GELK78DqDUNqK02yhh12miQW/wHcg5GWxUFviKjK7+5RnzB5iassezJ+aRvZdOpHV
	 ErLvVYroL3YHAEJHyhJxBn32gS8Tukg02t6/Zo4OAs7ACgW4gPqQV7r/tymrKQ9ht1
	 NJWjRMfRxMdZKNEaJFnp7LMTNANNnjQrBv71kGS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0902/1191] mfd: iqs62x: Reject zero-length firmware records
Date: Sat, 12 Sep 2026 09:00:30 +0200
Message-ID: <20260912065608.495033117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 1895fce25b060..71af8f803c5ce 100644
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



