Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC0A4772A1;
	Sat, 12 Sep 2026 11:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210871; cv=none; b=FYfFHcdxxXLu1nvUh8jULoA+s9oCLnh4Uvdae3+WBjl6CuhlsZHhKj9j9Y9bZLsI5YMUHlESqFV1iwOIR+YtTGe/xjG1Apr7dKmEfreT4sWstfpGfnNnBspg33N33czWQ503LOR9+O7Vu7yostyebYSA3Yw2ZMO21ZhVvy3HF2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210871; c=relaxed/simple;
	bh=UCi3hmgUrZvv4UMYbnSR3woMwA6b18BziABTsEpYZIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B18UDrURp5DMTARhdtk4+GWT7zH1lbORvvcyl6R5TcdQhw1HItxRPRqvEg4Jn45wLYYokPHHkwuH3lljnr4vkb5Y3qiIrFuxePB9qUZF+1+fHMrP/fy3vJusO4LV4FVRl3jKvTibsH5R7Ufe3GYpb6vQowIKyug9yvqKM5zeejk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPL6XXVZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPL6XXVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C5E1F000FF;
	Sat, 12 Sep 2026 11:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210869;
	bh=iaMg9+GZ9y7gndD0azwAEauTNAC2cfCVFv9w7zNGTB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPL6XXVZMRDDYFRoThNKoc0Z/kMljaX0gUeLaZ1nFv5srjPWWMvh7qOyw/FsYH1aX
	 G7NUluMohbDsi6bF9stC0sXCVSTQKitheDQbjmm9F3qZXHJb5D0m1soN+KLKO3S+nr
	 b+7oeYvVsCfjsluMu09AJccbQ5fgQksCUDO7iTx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1115/1518] nvme-apple: Never set the opcode in the NVMMU TCB
Date: Sat, 12 Sep 2026 08:54:44 +0200
Message-ID: <20260912065648.676278863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ff2b5d063024b..450f385074bed 100644
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



