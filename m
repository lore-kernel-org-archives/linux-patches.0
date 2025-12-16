Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA203341069;
	Tue, 16 Dec 2025 11:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884159; cv=none; b=GJfVuBqwbpbNzLXI1IVNu4qnzN3dwNg5AyEYXx5F7OshrmE3ETJz+vTngFSxFQuNkRhO9ArbV+OoRR1e+D3lIUw5V30Bg2FIW9nmFScV+0j33sU+3BPI+JOlsab1VNkvHhQeS0KJjNugteYcQpDkVXzt0sl5cyCHYQB6PfqAplM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884159; c=relaxed/simple;
	bh=sB/+SAmZjpz45agXHcKBDhsj7XEgxs6lebnj6bVqQWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mr9Kq/brefwyMsQul1Jy4k6y1NURBPP34iqUuRF96GCMSMY9PGtOGxUCZozAT/SQjcNTjcaNaqvlqbLo6Zcq18rqhjUuHcsttEOF6qyRToMOhshK8PV4UtU4Vm5/mJaR5W2Wdi0OLvyaUAmig0DIDwbNGHLXGYNxoujJP/GQgsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNG4Q/vo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNG4Q/vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B434C4CEF1;
	Tue, 16 Dec 2025 11:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884159;
	bh=sB/+SAmZjpz45agXHcKBDhsj7XEgxs6lebnj6bVqQWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNG4Q/voaNtuxuvXhOzPsqzapk1LDem90gmyNTnTaAYwO2NxvU9j/rJHdX496P7jD
	 rpM/aldXRkyBLjNTNaS3cyKUkE6B4ixmYwI7meWGgFhGem/ISFZV4oseZAcSaI+y4g
	 pg7v3coS/og2iSnlE20coVZ294f8YcMmq2EhNXac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/354] scsi: target: Do not write NUL characters into ASCII configfs output
Date: Tue, 16 Dec 2025 12:11:17 +0100
Message-ID: <20251216111324.906804947@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 3188bca17e1b9..68b40e01d5a09 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2774,7 +2774,6 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 		cur_len = snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&dev->dev_group.cg_item));
-		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
-- 
2.51.0



