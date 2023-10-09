Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DCA22F00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7XTJK09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD07C433C9;
	Mon,  9 Oct 2023 13:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858160;
	bh=6jFow32Jfc1LCAyi/yUTT9zm+twVnA+ayzRvOxoR3WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7XTJK09TXPTsQFdyJEydHYoQbDYuJbah3ftmbkCCzEWdrhmOam4fmoZNVB+qx+i3
	 ZWRXUDhtjs/TFG9uBYKgR+twJE2VA4P7jP4RZxUEb525k+8BYeK0vWSwVXt4SlQNsC
	 M0ehRTbGWb7S1Kn0RRXvEMNu4R6r+yrGVhwDCnmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <hmadhani@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/131] scsi: qla2xxx: Fix update_fcport for current_topology
Date: Mon,  9 Oct 2023 15:01:14 +0200
Message-ID: <20231009130117.354030457@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit 89eb2e7e794da2691e5aca02ed102bb287e3575a ]

logout_on_delete flag should not be set if the topology is Loop. This patch
fixes unintentional logout during loop topology.

Link: https://lore.kernel.org/r/20191217220617.28084-6-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 6dfe4344c168 ("scsi: qla2xxx: Fix deletion race condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f6d5d77ea45bb..28ba87cd227a2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5485,7 +5485,10 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	fcport->login_retry = vha->hw->login_retry_count;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 	fcport->deleted = 0;
-	fcport->logout_on_delete = 1;
+	if (vha->hw->current_topology == ISP_CFG_NL)
+		fcport->logout_on_delete = 0;
+	else
+		fcport->logout_on_delete = 1;
 	fcport->n2n_chip_reset = fcport->n2n_link_reset_cnt = 0;
 
 	switch (vha->hw->current_topology) {
-- 
2.40.1



