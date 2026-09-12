Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEF4309F08;
	Sat, 12 Sep 2026 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225253; cv=none; b=r+FJybsLcwd3aorLaE9ca4lSSgsjIpIcrPbT7KjnC9Ia/1mOO3gE95hfkZse0xbYDhBvBkLJpOhcbWqoZVgkgU26SnF0IaFyTwrwECaZFpWZLOdDC4NC9mT35VD72IiVflF4A0iGQjdjBRmBmn+Ha6XVJ1tzsq7QEcpvfIHZoxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225253; c=relaxed/simple;
	bh=InBYcX7j4TO2XQTSuw1PIJ5OqSOh3IiI9yxOw7sZfsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwknRQ8yJiKl6Yed+xvECmLYY7R9enCYJ7RphHSFEvzd9iI+dlIDkYdrtzfcYP7zQ0/BypANVN7SQ1d/96mYOW+Qy2JH9aF9sfUUgZewKQ8C4gbNrXAFHn9aG2rKl99DMybZSgOOKCDhiBv7SSyTZMy0BeWxA8+P9Kg1+09ny+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sm1VzDT/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sm1VzDT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888281F000FF;
	Sat, 12 Sep 2026 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225252;
	bh=FD0fT+viQiVaBjQ3yef68jaFsppmue+Yd5bLZDODFwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sm1VzDT/aB8nbQ7MET0Bp65vHVQ0LuEdW0xn6xRtMig25RUNpJPN9a7/C6QU4kGNv
	 VspJQi6GPK/RrAWEJ+tChH++vhoHX2Bw6zj6bKf3W9q7i9GX3cMFiHYBIIFTOMx0Vs
	 brxjimSaXk/VxecxV0+upmZRzuBdmSRyw63Hw/r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1160/1424] nvme-apple: Never set the opcode in the NVMMU TCB
Date: Sat, 12 Sep 2026 08:59:52 +0200
Message-ID: <20260912065633.273141613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 932b706240f27..68b4c3ea6c4b2 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -304,7 +304,7 @@ static void apple_nvme_submit_cmd(struct apple_nvme_queue *q,
 	u32 tag = nvme_tag_from_cid(cmd->common.command_id);
 	struct apple_nvmmu_tcb *tcb = &q->tcbs[tag];
 
-	tcb->opcode = cmd->common.opcode;
+	tcb->opcode = 0;
 	tcb->prp1 = cmd->common.dptr.prp1;
 	tcb->prp2 = cmd->common.dptr.prp2;
 	tcb->length = cmd->rw.length;
-- 
2.53.0



