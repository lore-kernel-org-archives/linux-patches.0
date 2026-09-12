Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DFE415F36;
	Sat, 12 Sep 2026 10:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209989; cv=none; b=MnwnM3XkQv+dtwXiA4ZS499q3GB4CQ7/HCTUs9/lDxYgW0d4VP1eImpNE5TeBM/aputOPuArThVVOx1yOj+H8Sti4bQSpMzvW736+ejw9V0WxFK3vr7ViCT07ow+HXQ9HDctjTKbgNhOabpgQJa18iwIWfbwnkpDs2F5SHu2mq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209989; c=relaxed/simple;
	bh=+pM7VzGPXoDCbTgcMZf1xJGEOHaD1n5hO+XD67MLLWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbnfBCnEbOGmDUsmKnX0QshjgwkCpMhx+CHwQc0K/hx1a2izrOa0Vrl10TI5IH7Lv3LNMXVpx3LuJTepzpqtceuhYcueCTdPwfCSFEgs5klAmtDu1QYgrNhtr2miaI8EGmI3bxs7aN2Szp3MkLQuKYo7FpgRxmJ6odWe5PLqq6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/C55eHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/C55eHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3505C1F000FF;
	Sat, 12 Sep 2026 10:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209988;
	bh=6gbp+56oqQMrVqtSUPeij3cULqqJ9wuEdP+2NLQmLfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/C55eHI47TE/wt+Qt/4BDNUWhzuHQM+yUAo57VphO0K2+JCzIKMr6JlA4wqLEFJF
	 gp9QMMtVgKSMsneJg2Lm65yr6rGn7cb0VkqqVuR13TN3cM8ZUj94I6ufSEDBSn7OwX
	 GmnHZFr0vFsfiDZlrvQSm9tF9U9uEcdy8K5efOzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0935/1518] mfd: iqs62x: Reject zero-length firmware records
Date: Sat, 12 Sep 2026 08:51:44 +0200
Message-ID: <20260912065644.601535187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



