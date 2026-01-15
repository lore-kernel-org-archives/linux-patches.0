Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDAE2874E6;
	Thu, 15 Jan 2026 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497404; cv=none; b=BrXBoorfprGJlrHaor7XHDw8IAR9aeWiQW5uxlJ1gm6P6XOA68gYhK2+oAt8VIjpClmuqYJFGEPpyysIvQ4oTPWj02W6wdhoEQAJuILZcXBmLQv7RBGSEvoPIFy5UYECfUG6xyRQFKv8JZvyNZ0+MDXW5oBKv5uzPN0MTYjgkf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497404; c=relaxed/simple;
	bh=ebyuVoe1cT2BoKMDRme6FllSTjXTu5ZvUelyKEx2r4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz/Db6dNOC9rD1gzPS/3kCPgGPDnrAqyP9A8J9oo4nqWNMMGeZVof0mAviHf5z554d2FHg4Svcwo5VllqM+h+u6g8l4RXhLpHXASZ3SSQ/IK5YYDuLGqgkGjkj8dzvTHS7AXfbBKiVszNJ3If1WtdrZ3LBeEDVAg/5e+Vy3abN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tShNr9qL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tShNr9qL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364CFC16AAE;
	Thu, 15 Jan 2026 17:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497404;
	bh=ebyuVoe1cT2BoKMDRme6FllSTjXTu5ZvUelyKEx2r4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tShNr9qLhlS/uBIQ0wQlIdAr0E1ZM71BsUpAOu3OI4uiqpHSZX1ebciF/BZGFwH+q
	 n66d2bE3VcqL3F/MKUqO2A1bZBvuS7v6clcupN3/+hLds736NZa+A6cJInrMfa+JKW
	 VOEXDreFao/JpE11/JzS5XbaEYxBoT9Ulx1IPxBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/554] scsi: target: Do not write NUL characters into ASCII configfs output
Date: Thu, 15 Jan 2026 17:42:16 +0100
Message-ID: <20260115164248.776572340@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c03b55f235e283cae49c88b9602fd11096b92eba ]

NUL characters are not allowed in ASCII configfs output. Hence this
patch.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251027184639.3501254-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_configfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 73a9e7b0ecbc7..120c19e41012b 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2677,7 +2677,6 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 		cur_len = snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&dev->dev_group.cg_item));
-		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
-- 
2.51.0



