Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90BA28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4676C433EF;
	Mon, 12 Dec 2022 13:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851402;
	bh=PQitczCFPdkNK0NVB7ulIq7ss+TEjvCqMtPOWF+vZSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyRuJAtBHUpsR/SdjA3blKhXxcXmsJrJ5Ytjl3pjq06GSA/oQDsdYMJOqqHzcnfM8
	 IWba+DnVttVEnJHR7Mu2KymMna4Rlv35L4U3AVh0bBDznqBWEkaND9ZLOxKf9pc1eZ
	 KvNmrLluzVnOLcs+oxEP0cjo27rhAu50U0aocb3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pankaj Raghav <p.raghav@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 54/67] nvme initialize core quirks before calling nvme_init_subsystem
Date: Mon, 12 Dec 2022 14:17:29 +0100
Message-Id: <20221212130920.199516337@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pankaj Raghav <p.raghav@samsung.com>

[ Upstream commit 6f2d71524bcfdeb1fcbd22a4a92a5b7b161ab224 ]

A device might have a core quirk for NVME_QUIRK_IGNORE_DEV_SUBNQN
(such as Samsung X5) but it would still give a:

    "missing or invalid SUBNQN field"

warning as core quirks are filled after calling nvme_init_subnqn.  Fill
ctrl->quirks from struct core_quirks before calling nvme_init_subsystem
to fix this.

Tested on a Samsung X5.

Fixes: ab9e00cc72fa ("nvme: track subsystems")
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3b5e5fb158be..029a89aead53 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2806,10 +2806,6 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 	if (!ctrl->identified) {
 		int i;
 
-		ret = nvme_init_subsystem(ctrl, id);
-		if (ret)
-			goto out_free;
-
 		/*
 		 * Check for quirks.  Quirk can depend on firmware version,
 		 * so, in principle, the set of quirks present can change
@@ -2822,6 +2818,10 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 			if (quirk_matches(id, &core_quirks[i]))
 				ctrl->quirks |= core_quirks[i].quirks;
 		}
+
+		ret = nvme_init_subsystem(ctrl, id);
+		if (ret)
+			goto out_free;
 	}
 	memcpy(ctrl->subsys->firmware_rev, id->fr,
 	       sizeof(ctrl->subsys->firmware_rev));
-- 
2.35.1



