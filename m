Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0759042067;
	Tue, 23 Jul 2024 18:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759486; cv=none; b=sjXiMozSxVaaOxgkJToT8yS7Sdc047YCPiZ6jf8Pt/oH2vMJCjxH44LA+L/IHYDBRrw6tPWbl7VkQLRYBZ6Mr8dlqUQ0olfj7Pwz8mI12BYIl8exXP8d1ItsmxQ+BnwO69LRtECkWTW3+7HAwffgKzU5vbr+z3oK1XwW0lOHRzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759486; c=relaxed/simple;
	bh=WpO/tfxzZbbpkuTsZsxY+9g/jFnhLbs3ZfEEMZqrIiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1MtzLs9VcMCGop4MEwlWzYPcVUzwic37jUvlKSDKlIkR523OeV+Ky9SsrY+/4vRIc9OFOEVN4IFA8AxiZs3/fNv6eDu1mpFmoQjzMteUJXATTyw1TO43WRdUaZ1vPsYPvqGi1VM5IiJho4WeOWjb/Jpz1REnxH/0Mkj4ovhgd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+yxEdtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+yxEdtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E519C4AF0A;
	Tue, 23 Jul 2024 18:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759485;
	bh=WpO/tfxzZbbpkuTsZsxY+9g/jFnhLbs3ZfEEMZqrIiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+yxEdtPfcrmy/S2sdZZS3FH2/6TQuD/ubUM4HB5FuhqT69wVEUS+x+RaQQO9VCbP
	 WIr7iXj8f6xx0mytDTBX+xyi919DqJNwQdvh7TQBghUAT94wXnRoPuxdYJbqTJV6Hp
	 nUD1UJENYqThooUib8CW8OMhoJYb70jXKazGN798=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/129] scsi: qedf: Dont process stag work during unload and recovery
Date: Tue, 23 Jul 2024 20:22:32 +0200
Message-ID: <20240723180404.937709370@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 51071f0831ea975fc045526dd7e17efe669dc6e1 ]

Stag work can cause issues during unload and recovery, hence don't process
it.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240515091101.18754-2-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 91f3f1d7098eb..c27e27cff0790 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3996,6 +3996,22 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
+	if (!qedf) {
+		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		return;
+	}
+
+	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Already is in recovery, hence not calling software context reset.\n");
+		return;
+	}
+
+	if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Driver unloading\n");
+		return;
+	}
+
 	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
 			dev_name(&qedf->pdev->dev), __func__, __LINE__,
 			qedf->dbg_ctx.host_no);
-- 
2.43.0



