Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5204117E90E;
	Mon, 27 May 2024 19:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836870; cv=none; b=UxWLobKnuqBCFc0AqEbfvK7G8WoKpdQP1GHXi080w5YT5rToBVPE490aZyRW+TVPgs1v7g8qBZRy9515cW+1/osltD2fJ6R3ceb5no9eA2UmQyqTDF4jwei5SPK///0ypWCeW1fvxXChHW+jZK2AU3ZkzpeT+NGj99cucHoPVyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836870; c=relaxed/simple;
	bh=Siamr7/kTcHRlVt8gz86Khsgpk0wbE3hiEpJVY3G6Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5no/lg7Zlt9RcvIKwkpc3JmN8Y0DuqbddcXoEvU03CXNUiZC2tX/Bx020DhJHIyjqvJBh7AWthRqNr7dWUgYdCoVTy9JauTmwXwBoGNap9HwkGgz2WVcb0VT5eplhshAzb3T+dtQCclIEKV5e2jWUMcO1SW3VVcpIwzBxf5VKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDH8rSmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDH8rSmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61EDC2BBFC;
	Mon, 27 May 2024 19:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836870;
	bh=Siamr7/kTcHRlVt8gz86Khsgpk0wbE3hiEpJVY3G6Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDH8rSmyZ1pTY8C+BWJujTrit40xJnmsN0d6WtLAglJMpUpTBVLvpqnoJocfKZPcL
	 HNGc4DHdvoeeSwYD8wX9BpscaYY0bztH4NYdTYbXkDRWr/Ptz7qirfkBVBswxgZ38f
	 6dMa+NpCBbuE28527J5tXs9EORK8HszJ0qlvrC1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 219/427] scsi: qedf: Ensure the copied buf is NUL terminated
Date: Mon, 27 May 2024 20:54:26 +0200
Message-ID: <20240527185623.013331807@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 451fd236bfd05..96174353e3898 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -170,7 +170,7 @@ qedf_dbg_debug_cmd_write(struct file *filp, const char __user *buffer,
 	if (!count || *ppos)
 		return 0;
 
-	kern_buf = memdup_user(buffer, count);
+	kern_buf = memdup_user_nul(buffer, count);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
-- 
2.43.0



