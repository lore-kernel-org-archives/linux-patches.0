Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76433143883;
	Thu, 13 Jun 2024 11:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278828; cv=none; b=W24ke/qjnl4S6H8ey6oIZxh1GIHQI+mkZ2nekJxFa5oxDZ6FxiwHp/Yp2DwW0KZ8pf4hyFKdYGnGj0M4Kxe98k+Lu19QM4Ef5nF8mW//nrktL19trazprcCRoCLX1ORoepMlL+hw1VeME4uPws3EZiGk+jzXAs44LNKSV3h/x58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278828; c=relaxed/simple;
	bh=1CZ8CVJQ2PKbjhqjTMOf8XFLi6nS0KqtVCYp8+U+00o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eW3+z3zsgEFaTVWyOk+3PCG5CWHA7fEy9ZGmQBl+F1PoDIsiTG2DlX4B3WidHLWXRaz80wVz9wM7r6vyob87qrH0xXhjyIsX1P7u4cLvMPBKRtcPuf/VH6T5QMU0ErBdBVDfG1qMGyn9Jeu9TwriM79rBWzkEituV7lNez2ZAjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcQoInlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcQoInlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60E0C4AF4D;
	Thu, 13 Jun 2024 11:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278828;
	bh=1CZ8CVJQ2PKbjhqjTMOf8XFLi6nS0KqtVCYp8+U+00o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcQoInlTAVWKmJEb/IHB+GDEKU+OAXbjBrGk3WcKkIsadNP3caiJCYjxkT43kn4vl
	 7lG81gbg7Zm+6nkebWkO62JHguOw47yuY6eIAx450mp/Mpwb+hygazx6mnlt9L/dye
	 qN44WAYw/zIjsNXc19Ywkd3L/N1kwgSiNIKN8+L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/213] scsi: qedf: Ensure the copied buf is NUL terminated
Date: Thu, 13 Jun 2024 13:31:40 +0200
Message-ID: <20240613113230.016883948@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit d0184a375ee797eb657d74861ba0935b6e405c62 ]

Currently, we allocate a count-sized kernel buffer and copy count from
userspace to that buffer. Later, we use kstrtouint on this buffer but we
don't ensure that the string is terminated inside the buffer, this can
lead to OOB read when using kstrtouint. Fix this issue by using
memdup_user_nul instead of memdup_user.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://lore.kernel.org/r/20240424-fix-oob-read-v2-4-f1f1b53a10f4@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index 84f1ddcfbb218..4636c045e1e3e 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -190,7 +190,7 @@ qedf_dbg_debug_cmd_write(struct file *filp, const char __user *buffer,
 	if (!count || *ppos)
 		return 0;
 
-	kern_buf = memdup_user(buffer, count);
+	kern_buf = memdup_user_nul(buffer, count);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
-- 
2.43.0



