Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1334D288B9;
	Sat, 12 Sep 2026 16:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231230; cv=none; b=UAEpExkQyZ68VSsLYK/SBFTM+8hXV1Qfa3DHR4L5qpbvaCUKFj2UrhZk2CznTMmADF5bWu8aak6Mh12GMTZo68l0qMXSKUX6a5OOr3YXj3aRze+m7V5+VGTqdwBA1mGW22CxoQb/XR2u7duDde7RFlea8n0HiCVvEDtyrcJ2SrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231230; c=relaxed/simple;
	bh=6el0o1uYzmLFHe/vZyg7ZeLgS0e0HpdCIuH5dPD7+No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m176HxTffWBtxyl2Z9cekrZQ+oOixs5+S43zTZRmO/RdI6rdg3M5w83czKF2sorqHBBAtA8Qpu9VCQWMsEQQlyyljyHm+Kqjmxx9q7aDyZTG4lQHSCGJI41hY6inLeoknehPrVQKG7G5V3cZs9Bw2xR5FJ8jV2Rc1a+D2f+mhL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCYM4o/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCYM4o/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36371F000FF;
	Sat, 12 Sep 2026 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231228;
	bh=ZFm0chKqhnf02cw3mbzzTYj67jQ/pTiaXBemk115jO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCYM4o/UJKUwX0SDu3MdWdmuBjTKKC4DSEj591FTJfj/QkUyUryht7GYiePER/iSr
	 f170BaxpIL8MdLodsubVeo3a6cn6xbRRu9RWf61x+dgffAeCv0BorQlTMjcUTdTqUd
	 41hVKB7u3fpmNMPbX7ANc0gaoXvl4ztk0eDjlfN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0955/1191] nvme-apple: Never set the opcode in the NVMMU TCB
Date: Sat, 12 Sep 2026 09:01:23 +0200
Message-ID: <20260912065609.672772848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 90d92728db6dd..8d687c3174def 100644
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



