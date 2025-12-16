Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFA434573F;
	Tue, 16 Dec 2025 11:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885506; cv=none; b=IcXLAATnRyOVujvTzHOIev8pDsQkm1KtHLaVlsBBk/3lLeVAdjWukAF4rC/56XTwJ7QtLYSOa4x/wK8PdqHxG0AotKiKuMIvyLQ/l5EcqC5bpBS+o9bneIBkZ5II3kPy/WdZFZp/92lJJkefpoVqSs92dYN3LQzB7mk9E3l96Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885506; c=relaxed/simple;
	bh=qz3Vl+oKTi/QTbzOLzyq2cvkRpDKC0f0AUxBjltB9eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOmA6z5FCR0LQOEN6iK5q+VmlC1BeW73txAwxZr6NdzzSDpntsA8JvMXJF5wqyVMchIGYG9JhsGjEYtEACe4o/0DXy+OaT6SlpZ7rVPQARqSTjbjomHQiFS8OU8YSaRNxI4DGykwKf/cyC1r1hds5lvrmBbZT+WEE4oznGDMHSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WReIWtCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WReIWtCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EB4C4CEF1;
	Tue, 16 Dec 2025 11:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885506;
	bh=qz3Vl+oKTi/QTbzOLzyq2cvkRpDKC0f0AUxBjltB9eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WReIWtCDpBvESuny98WORx5GAvwcGT4/sWxqaLJzZ6nSxabGQWqIyof1ghabvxrC3
	 RZN+BxBqkT3Djhkjq8/pKbIpta+Npm8lXd6Tfx8kg1q+Ft5RJ9oOhZyWlJ5Ley+UYs
	 engwSe+eJpqk6+5i8XbUw1/3Yi4uvB6ImgJUm2M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 159/507] scsi: target: Do not write NUL characters into ASCII configfs output
Date: Tue, 16 Dec 2025 12:10:00 +0100
Message-ID: <20251216111351.282756850@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b19acd662726d..1bd28482e7cb3 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2772,7 +2772,6 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 		cur_len = snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&dev->dev_group.cg_item));
-		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
-- 
2.51.0



