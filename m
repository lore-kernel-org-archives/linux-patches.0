Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5216811705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72FBC433C8;
	Mon, 11 Sep 2023 14:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443111;
	bh=xjbZzIhsuAigZ29H7qf4hh2QV5SOW+66wgA/p6fiAKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwsTpWbFsDv1CJhgkEV4ZUcCAa68dATchIplJwSkFZc+2iQtUI+Vdtlt1uUZ5N47c
	 fWV+NJ78jXONw/QKoADSLGnWgOwx/QWUjR4TOl0hm/0wJM1i3n+24arZCAasEfypfL
	 DWW4J38ag/OMcPUSNwn87JciW6OKMv9pOdrYlBlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 261/737] pds_core: protect devlink callbacks from fw_down state
Date: Mon, 11 Sep 2023 15:42:00 +0200
Message-ID: <20230911134657.877314631@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 91202ce78fcd070982a115f0bf6f328af619aa00 ]

Don't access structs that have been cleared when in the fw_down
state and the various structs have been cleaned and are waiting
to recover.  This caused a panic on rmmod when already in fw_down
and devlink_param_unregister() tried to check the parameters.

Fixes: 40ced8944536 ("pds_core: devlink params for enabling VIF support")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230824161754.34264-2-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index 9c6b3653c1c7c..d9607033bbf21 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -10,6 +10,9 @@ pdsc_viftype *pdsc_dl_find_viftype_by_id(struct pdsc *pdsc,
 {
 	int vt;
 
+	if (!pdsc->viftype_status)
+		return NULL;
+
 	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
 		if (pdsc->viftype_status[vt].dl_id == dl_id)
 			return &pdsc->viftype_status[vt];
-- 
2.40.1



