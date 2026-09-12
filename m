Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8350A347FEC;
	Sat, 12 Sep 2026 13:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218031; cv=none; b=COE7Z7lPavPOCPatGKXeTc0p7XGa0mnGz8Rfh8K+OJjDB/0Wp3TAsir9HA47UMs3wTS6IpQJS68zDn1CRT3uqV4mB0UnsImBpMq9s6WQxbMFVA8NIA/HvEhddo9oz4LyT0PBmLfPcnY7nj3NgVnQAJ+Sj1Akt9uu0piZxsXVFJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218031; c=relaxed/simple;
	bh=G4nqjxws+kcuPGlTlS7OVIf1HJkGAvFzs+Y6smRo+WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RN8OGCwNCdjFB03eU+lQp0mOnIb+VXzHDkbLZ8yusIhKho/lQlAkRrS3rNiQv5cA2Q0V50F2u7cREgsSgErj3AywdrgvHi8YJZwGaWESEnwrt7RSvnGvb2stlw+i9zbiFOOKDGEFiwHOo2FfB4dH9cGMkViKwYnO27ebtHV+ybE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsRmUHnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsRmUHnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD9E1F000FF;
	Sat, 12 Sep 2026 13:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218030;
	bh=e92xKZm2De3Gx5VLdO9bM4F3GzTIXzBpD+aVUL08y5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsRmUHnWl3YZbuloeUra4TgvWyApKAPNRoGy8YrNaFtLDy3EBcAeCx7QGqATVjlVH
	 dcbsx/1tqSjvZLm76hozHYqsxqayJVsodI63+c4khn9RYJJead6X8/DQM2oUTjB1dG
	 EZxU6aBuvgdVojpyLt55BFpBmv2550p9mX59T+tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1059/1376] nvme-apple: Never set the opcode in the NVMMU TCB
Date: Sat, 12 Sep 2026 08:58:05 +0200
Message-ID: <20260912065631.162833360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 3d0443cf55f42..6606d7644186d 100644
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



