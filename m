Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42EB28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FFBC433EF;
	Mon, 12 Dec 2022 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852036;
	bh=VV/KvFqRZGcvcxDTtprpKAiGRCx+qLjUd/EA4R1ZDFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCox676BsrQnzJgSy8gsmujvk4CAeDjMYSX7zfce6PCQtCtdSj57MQYHwHClEgsaq
	 YqX08Uw1n9pA/j1hnRwtRRlGwJdWWbhu54WgKAOTWKjY++i7LQ+KbMz2cbiACsNzTw
	 GXomwuywur55LKnqWs03P5P8ZnbFp3e9Hn8Ee3/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pankaj Raghav <p.raghav@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/123] nvme initialize core quirks before calling nvme_init_subsystem
Date: Mon, 12 Dec 2022 14:17:41 +0100
Message-Id: <20221212130931.099530676@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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
index 694373951b18..692ee0f4a1ec 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2921,10 +2921,6 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 	if (!ctrl->identified) {
 		unsigned int i;
 
-		ret = nvme_init_subsystem(ctrl, id);
-		if (ret)
-			goto out_free;
-
 		/*
 		 * Check for quirks.  Quirk can depend on firmware version,
 		 * so, in principle, the set of quirks present can change
@@ -2937,6 +2933,10 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
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



