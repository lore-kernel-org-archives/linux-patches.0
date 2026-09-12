Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D95637189C;
	Sat, 12 Sep 2026 08:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203124; cv=none; b=BezptQ+27sXMQT/VjtR3dkgd6iglq/3Lx69A66aQJIZ9jXwHblPlDIqXFuXfg5Bj8JJIWRLx4hO313Kykudqz0ElfrUYGpsYEJZxFA/n+X8mtBQp7nXIRjaIKtJNNvS6LY11CUi0Ip8NQutKB/IRUA3xQX443Z9qNZgI3grrSMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203124; c=relaxed/simple;
	bh=VqUN94WeNEk6a3J1uyIeezh+R5c4d97R0TB54PFgMmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGQIrOj9wNP9VsPXJdSr754kKaPdM+dDLexmlmhBbKPseNQQQ631Ii4Qok915CkdZojomi4ieg9HL80BWQ3nIsxQGqADDTE3YO7cO6NKn0s28h+sd1Jsu0h5+TadBsPBXJFzxCEk8qfwAlrmtrBfETKzsi3F+D4syQ/yrsf+R7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1TxWda8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1TxWda8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC161F000FF;
	Sat, 12 Sep 2026 08:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203122;
	bh=MaOqsJcozSj/bAjUF2d1/PLj6HR9c7c765schyq4SMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h1TxWda8e9E5poVUw/t6mpMO+w3wZQXVs7bOoJw3AnywN0m4eDQF810BAKVIx4GNf
	 l1LrjU8Pjy8ANOXfHj6qmFlGhP6HN2jqGoZ6AUkZWNSt81drVqxsxAMrBabofha8W/
	 TWYuIvWpDr5t4f9Anl4AISuJTJfRajRD5fk9vtaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1344/1815] nvme-apple: Never set the opcode in the NVMMU TCB
Date: Sat, 12 Sep 2026 08:51:34 +0200
Message-ID: <20260912065720.575588411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

[ Upstream commit cc0fec9b42cfbc69d70cb4c4b616408a7037b445 ]

macOS always sets this to zero and the firmware starting with macOS 15
has started to complain about what we're doing here.

Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
Tested-by: Joshua Peisach <jpeisach@ubuntu.com>
Tested-by: Janne Grunau <j@jannau.net>
Tested-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 60dffd3fa0fbc..0c3f371c792f2 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -335,7 +335,7 @@ static void apple_nvme_submit_cmd_t8103(struct apple_nvme_queue *q,
 	u32 tag = nvme_tag_from_cid(cmd->common.command_id);
 	struct apple_nvmmu_tcb *tcb = &q->tcbs[tag];
 
-	tcb->opcode = cmd->common.opcode;
+	tcb->opcode = 0;
 	tcb->prp1 = cmd->common.dptr.prp1;
 	tcb->prp2 = cmd->common.dptr.prp2;
 	tcb->length = cmd->rw.length;
-- 
2.53.0



